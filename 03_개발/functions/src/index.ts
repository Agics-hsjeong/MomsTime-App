import * as admin from "firebase-admin";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2/options";
import { defineSecret } from "firebase-functions/params";
import { GoogleGenerativeAI } from "@google/generative-ai";

admin.initializeApp();

// 한국 사용자 기준 + Firestore 권장 리전
setGlobalOptions({ region: "asia-northeast3" });

const GEMINI_API_KEY = defineSecret("GEMINI_API_KEY");

function requireAuth(request: { auth?: { uid?: string } | null }) {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "로그인이 필요합니다.");
  }
  return uid;
}

function fallbackAskAI(message: string) {
  const q = message.toLowerCase();
  if (q.includes("감기") || q.includes("콧물") || q.includes("기침")) {
    return (
      "임신 중 감기는 흔하게 발생할 수 있어요.\n" +
      "충분한 수분 섭취와 휴식을 우선으로 하시고, 해열이 있으면 의료진과 상의해 주세요.\n" +
      "고열·호흡곤란·지속되는 증상이 있으면 즉시 진료가 필요합니다."
    );
  }
  if (q.includes("약") || q.includes("복용")) {
    return (
      "임신·수유 중 약 복용은 반드시 의사·약사와 상의하는 것이 안전해요.\n" +
      "처방받은 약은 지시된 용량과 시간을 지키고, 영양제·한약 등도 임의로 추가하지 않는 것이 좋아요."
    );
  }
  if (q.includes("영양") || q.includes("엽산")) {
    return (
      "임신 준비·임신 초기에는 엽산이 중요해요.\n" +
      "균형 잡힌 식사와 함께 의료진이 권장하는 영양제를 꾸준히 챙기세요."
    );
  }
  return (
    "질문해주셔서 감사해요.\n" +
    "증상(언제부터/강도), 임신 주차, 복용 중인 약을 알려주시면 더 구체적으로 도와드릴게요.\n" +
    "급한 증상이나 지속되는 불편함은 반드시 의료진과 상담해주세요."
  );
}

function fallbackBriefing(nickname: string, stage: string) {
  const name = nickname?.trim() ? nickname.trim() : "엄마";
  const stageLabel = stage?.trim() ? stage.trim() : "건강 관리";
  return {
    title: "오늘의 AI 브리핑",
    summary:
      `${name}님, 오늘도 ${stageLabel}에 맞춰 건강한 하루를 보내세요.\n` +
      "복약 일정과 수분 섭취를 챙기고, 무리한 활동은 피하는 것이 좋아요.",
    tips: [
      "오늘 예정된 복약 시간을 확인해보세요.",
      "하루 1.5~2L 정도 수분을 섭취해보세요.",
      "가벼운 산책이나 스트레칭으로 컨디션을 유지해보세요.",
    ],
    warnings: ["지속되는 복통, 출혈, 심한 두통은 즉시 의료진과 상담하세요."],
  };
}

async function geminiText(prompt: string) {
  const key = GEMINI_API_KEY.value();
  if (!key) return null;
  const genAI = new GoogleGenerativeAI(key);
  const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
  const result = await model.generateContent(prompt);
  const text = result.response.text();
  return text?.trim() ? text.trim() : null;
}

export const askAI = onCall<{ message?: string }>({ secrets: [GEMINI_API_KEY] }, async (request) => {
  requireAuth(request);
  const message = request.data?.message?.trim();
  if (!message) {
    throw new HttpsError("invalid-argument", "message가 필요합니다.");
  }

  const prompt =
    "너는 임신/산모 건강을 돕는 상담 도우미야.\n" +
    "의학적 진단은 하지 말고, 안전한 범위의 일반적인 정보/주의사항/다음 행동을 안내해.\n" +
    "긴급 신호(출혈, 심한 복통, 호흡곤란, 고열 등)가 있으면 즉시 진료를 권고해.\n\n" +
    `사용자 질문: ${message}\n\n` +
    "답변(한국어, 6~10문장, 줄바꿈 포함):";

  try {
    const ai = await geminiText(prompt);
    if (ai) return { reply: ai };
  } catch (e) {
    console.error("[askAI] gemini error:", e);
  }
  return { reply: fallbackAskAI(message) };
});

export const generateDailyBriefing = onCall<{
  nickname?: string;
  stage?: string;
}>({ secrets: [GEMINI_API_KEY] }, async (request) => {
  requireAuth(request);
  const nickname = request.data?.nickname ?? "";
  const stage = request.data?.stage ?? "";

  const prompt =
    "너는 임신/산모 건강 앱의 '오늘의 브리핑'을 작성하는 도우미야.\n" +
    "아래 형식으로만 JSON을 반환해:\n" +
    '{ "title": string, "summary": string, "tips": string[], "warnings": string[] }\n' +
    "tips는 3개, warnings는 1~2개.\n" +
    "너무 과장하지 말고 실천 가능한 조언 중심.\n\n" +
    `닉네임: ${nickname}\n` +
    `단계: ${stage}\n`;

  try {
    const ai = await geminiText(prompt);
    if (ai) {
      // 모델이 JSON 외 텍스트를 섞는 경우가 있어 최대한 안전하게 파싱 시도
      const jsonStart = ai.indexOf("{");
      const jsonEnd = ai.lastIndexOf("}");
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        const parsed = JSON.parse(ai.slice(jsonStart, jsonEnd + 1)) as {
          title?: string;
          summary?: string;
          tips?: unknown;
          warnings?: unknown;
        };
        return {
          title: parsed.title ?? "오늘의 AI 브리핑",
          summary: parsed.summary ?? "",
          tips: Array.isArray(parsed.tips) ? parsed.tips.map(String) : [],
          warnings: Array.isArray(parsed.warnings)
            ? parsed.warnings.map(String)
            : [],
        };
      }
    }
  } catch (e) {
    console.error("[generateDailyBriefing] gemini error:", e);
  }
  return fallbackBriefing(nickname, stage);
});

export const sendNotification = onCall<{
  uid?: string;
  title?: string;
  body?: string;
  data?: Record<string, string>;
}>(async (request) => {
  // MVP: 본인에게만 테스트 푸시 허용 (악용 방지)
  const callerUid = requireAuth(request);

  const targetUid = (request.data?.uid ?? callerUid).trim();
  if (targetUid !== callerUid) {
    throw new HttpsError(
      "permission-denied",
      "현재는 본인 계정에만 테스트 푸시를 보낼 수 있어요."
    );
  }

  const title = (request.data?.title ?? "Mom's Time").trim();
  const body = (request.data?.body ?? "").trim();
  const data = request.data?.data ?? {};

  const userSnap = await admin.firestore().collection("users").doc(targetUid).get();
  const user = userSnap.data() ?? {};
  const token = user["fcmToken"] as string | undefined;
  if (!token) {
    throw new HttpsError("failed-precondition", "FCM 토큰이 없습니다.");
  }

  const settings = (user["notificationSettings"] ?? {}) as Record<string, unknown>;
  const allowPush =
    settings["enabled"] === undefined ? true : Boolean(settings["enabled"]);
  if (!allowPush) {
    return { ok: true, skipped: true, reason: "disabled" };
  }

  const message: admin.messaging.Message = {
    token,
    notification: {
      title,
      body,
    },
    data,
    android: {
      priority: "high",
      notification: { channelId: "moms_time_default" },
    },
    apns: {
      payload: {
        aps: {
          sound: "default",
        },
      },
    },
  };

  // 알림함(리스트)에는 push 수신 여부와 관계없이 남기기
  await admin
    .firestore()
    .collection("users")
    .doc(targetUid)
    .collection("notifications")
    .add({
      title,
      body,
      type: data["type"] ?? "system",
      actionLabel: data["actionLabel"] ?? "",
      actionRoute: data["actionRoute"] ?? "",
      read: false,
      sentAt: admin.firestore.FieldValue.serverTimestamp(),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

  const msgId = await admin.messaging().send(message);
  return { ok: true, messageId: msgId };
});

