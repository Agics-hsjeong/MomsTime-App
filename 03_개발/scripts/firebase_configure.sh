#!/usr/bin/env bash
# Mom's Time — Firebase 연결 스크립트
# 사용법:
#   1) 터미널에서 firebase login (최초 1회, 브라우저 인증)
#   2) ./scripts/firebase_configure.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export PATH="$PATH:$HOME/.pub-cache/bin"

echo "==> Firebase CLI 확인"
if ! command -v firebase >/dev/null 2>&1; then
  echo "firebase CLI가 없습니다. 설치: npm install -g firebase-tools"
  exit 1
fi

echo "==> FlutterFire CLI 확인"
if ! command -v flutterfire >/dev/null 2>&1; then
  echo "flutterfire CLI 설치 중..."
  dart pub global activate flutterfire_cli
fi

echo "==> Firebase 로그인 상태 확인"
if ! firebase projects:list --project momstime-app >/dev/null 2>&1; then
  echo ""
  echo "Firebase에 로그인되어 있지 않습니다."
  echo "아래 명령을 실행한 뒤 브라우저에서 Google 계정으로 인증하세요:"
  echo "  firebase login"
  echo ""
  exit 1
fi

echo "==> flutterfire configure (project: momstime-app)"
flutterfire configure \
  --project=momstime-app \
  --yes \
  --platforms=android,ios,web \
  --android-package-name=com.momstime.mom_time \
  --ios-bundle-id=com.momstime.momTime \
  --overwrite-firebase-options

echo ""
echo "완료! 생성된 파일:"
echo "  - lib/firebase_options.dart"
echo "  - android/app/google-services.json"
echo "  - ios/Runner/GoogleService-Info.plist"
echo ""
echo "다음: cd ios && pod install && cd .."
echo "      flutter run"
