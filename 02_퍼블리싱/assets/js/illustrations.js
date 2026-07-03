/* ============================================================
   Mom's Time — Illustration Set
   디자인 시안의 일러스트(임산부 / AI 로봇 / 로고 / 다이아몬드 / 선물)를
   SVG로 재현합니다. [data-illust="name"] 요소에 자동 주입됩니다.
   ============================================================ */

var MT_ILLUST = {

  /* ---------- 브랜드 로고 (하트 + 엄마) ---------- */
  logo:
    '<svg viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" style="width:100%;height:100%">' +
      '<defs><linearGradient id="mtLogoG" x1="0" y1="0" x2="1" y2="1">' +
        '<stop offset="0" stop-color="#F58BA8"/><stop offset="1" stop-color="#EF4B77"/>' +
      '</linearGradient></defs>' +
      '<path d="M60 34 C52 18 28 18 20 34 C12 50 26 66 60 94 C94 66 108 50 100 34 C92 18 68 18 60 34 Z" ' +
        'stroke="url(#mtLogoG)" stroke-width="6" stroke-linejoin="round"/>' +
      '<path d="M66 12 C63 6 54 6 51 12 C48 18 54 25 60 30 C66 25 72 18 69 12 Z" ' +
        'stroke="url(#mtLogoG)" stroke-width="4" stroke-linejoin="round"/>' +
      '<path d="M54 46 C48 50 46 60 51 68 C55 74 63 75 68 70" ' +
        'stroke="url(#mtLogoG)" stroke-width="4" stroke-linecap="round"/>' +
      '<path d="M57 47 C60 42 67 42 69 47" stroke="url(#mtLogoG)" stroke-width="4" stroke-linecap="round"/>' +
    '</svg>',

  /* ---------- 임산부 일러스트 (플랫, 핑크) ---------- */
  pregnant:
    '<svg viewBox="0 0 220 300" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" style="width:100%;height:100%">' +
      /* 뒷머리 */
      '<path d="M64 88 C68 40 152 40 156 88 C162 138 150 178 138 186 L82 186 C70 178 58 138 64 88 Z" fill="#6E4B3B"/>' +
      /* 목 */
      '<rect x="100" y="128" width="20" height="30" rx="9" fill="#EDBBA0"/>' +
      /* 상의(핑크) + 배 */
      '<path d="M60 300 C54 214 76 166 110 166 C144 166 166 214 160 300 Z" fill="#F2A7C0"/>' +
      '<path d="M94 300 C84 250 90 196 110 196 C130 196 136 250 126 300 Z" fill="#F7BCD1" opacity=".55"/>' +
      /* 팔(핑크 소매) */
      '<path d="M72 214 C74 252 92 276 108 282" stroke="#F2A7C0" stroke-width="22" stroke-linecap="round"/>' +
      '<path d="M148 214 C146 252 128 276 112 282" stroke="#F2A7C0" stroke-width="22" stroke-linecap="round"/>' +
      /* 손(피부) */
      '<ellipse cx="99" cy="280" rx="16" ry="12" fill="#F6C9AE"/>' +
      '<ellipse cx="121" cy="280" rx="16" ry="12" fill="#F6C9AE"/>' +
      /* 얼굴 */
      '<ellipse cx="110" cy="96" rx="40" ry="44" fill="#F6C9AE"/>' +
      /* 옆머리(얼굴 프레임) */
      '<path d="M66 92 C66 66 78 76 84 100 C86 120 82 150 78 168 C70 150 62 118 66 92 Z" fill="#6E4B3B"/>' +
      '<path d="M154 92 C154 66 142 76 136 100 C134 120 138 150 142 168 C150 150 158 118 154 92 Z" fill="#6E4B3B"/>' +
      /* 앞머리(부드러운 헤어라인) */
      '<path d="M68 102 C68 58 152 58 152 102 C150 84 140 74 110 74 C80 74 70 84 68 102 Z" fill="#5F4030"/>' +
      /* 감은 눈 */
      '<path d="M88 98 q8 8 16 0" stroke="#4A3222" stroke-width="3" stroke-linecap="round"/>' +
      '<path d="M116 98 q8 8 16 0" stroke="#4A3222" stroke-width="3" stroke-linecap="round"/>' +
      /* 미소 */
      '<path d="M102 116 q8 6 16 0" stroke="#C97B6E" stroke-width="3" stroke-linecap="round"/>' +
      /* 볼 */
      '<ellipse cx="85" cy="112" rx="7" ry="4.5" fill="#F0A0A8" opacity=".65"/>' +
      '<ellipse cx="135" cy="112" rx="7" ry="4.5" fill="#F0A0A8" opacity=".65"/>' +
    '</svg>',

  /* ---------- AI 로봇 마스코트 ---------- */
  robot:
    '<svg viewBox="0 0 200 214" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" style="width:100%;height:100%">' +
      /* 반짝이 */
      '<g fill="#F7A8C4">' +
        '<path d="M26 62 l3 8 8 3 -8 3 -3 8 -3 -8 -8 -3 8 -3z"/>' +
        '<path d="M174 48 l2.4 6 6 2.4 -6 2.4 -2.4 6 -2.4 -6 -6 -2.4 6 -2.4z"/>' +
      '</g>' +
      /* 안테나 */
      '<rect x="97" y="18" width="6" height="24" rx="3" fill="#F58BB0"/>' +
      '<circle cx="100" cy="14" r="8" fill="#F2547F"/>' +
      /* 귀(헤드폰) */
      '<rect x="26" y="74" width="22" height="46" rx="11" fill="#F58BB0"/>' +
      '<rect x="152" y="74" width="22" height="46" rx="11" fill="#F58BB0"/>' +
      /* 머리 */
      '<rect x="40" y="40" width="120" height="106" rx="38" fill="#FFFFFF" stroke="#F3D9E2" stroke-width="2"/>' +
      /* 얼굴 스크린 */
      '<rect x="56" y="58" width="88" height="70" rx="28" fill="#34344B"/>' +
      /* 웃는 눈 */
      '<path d="M74 90 q9 10 18 0" stroke="#FFFFFF" stroke-width="5" stroke-linecap="round"/>' +
      '<path d="M108 90 q9 10 18 0" stroke="#FFFFFF" stroke-width="5" stroke-linecap="round"/>' +
      /* 볼 */
      '<ellipse cx="72" cy="106" rx="6" ry="4" fill="#F58BB0"/>' +
      '<ellipse cx="128" cy="106" rx="6" ry="4" fill="#F58BB0"/>' +
      /* 몸통 */
      '<path d="M60 150 q0 -6 8 -6 h64 q8 0 8 6 v20 q0 24 -24 24 h-32 q-24 0 -24 -24z" fill="#FBD6E2"/>' +
      /* 팔 */
      '<rect x="50" y="150" width="14" height="30" rx="7" fill="#F58BB0"/>' +
      '<rect x="136" y="150" width="14" height="30" rx="7" fill="#F58BB0"/>' +
      /* 가슴 하트 */
      '<path d="M100 160 c-4 -6 -14 -5 -14 3 c0 6 8 11 14 15 c6 -4 14 -9 14 -15 c0 -8 -10 -9 -14 -3z" fill="#F2547F"/>' +
    '</svg>',

  /* ---------- 프리미엄 다이아몬드 ---------- */
  gem:
    '<svg viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" style="width:100%;height:100%">' +
      '<g fill="#F7A8C4" opacity=".9">' +
        '<path d="M18 40 l2.4 6 6 2.4 -6 2.4 -2.4 6 -2.4 -6 -6 -2.4 6 -2.4z"/>' +
        '<path d="M104 66 l2 5 5 2 -5 2 -2 5 -2 -5 -5 -2 5 -2z"/>' +
      '</g>' +
      '<path d="M40 34 h40 l18 20 -38 52 -38 -52z" fill="#C9B6F5"/>' +
      '<path d="M40 34 l-18 20 h30z" fill="#B49BF0"/>' +
      '<path d="M80 34 l18 20 h-30z" fill="#9E82E8"/>' +
      '<path d="M22 54 h30 l8 52z" fill="#A98CEE"/>' +
      '<path d="M98 54 h-30 l-8 52z" fill="#8E6FE0"/>' +
      '<path d="M52 54 h16 l-8 52z" fill="#C4B0F4"/>' +
      '<path d="M40 34 l12 20 h16 l12 -20z" fill="#D9CCF9"/>' +
    '</svg>',

  /* ---------- 선물 상자 ---------- */
  gift:
    '<svg viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" style="width:100%;height:100%">' +
      '<rect x="24" y="52" width="72" height="46" rx="8" fill="#F7BCD1"/>' +
      '<rect x="24" y="44" width="72" height="18" rx="6" fill="#F2A7C0"/>' +
      '<rect x="52" y="44" width="16" height="54" fill="#FFE1EC"/>' +
      '<path d="M60 44 C52 30 34 32 40 42 C44 48 54 46 60 44 Z" fill="#F58BB0"/>' +
      '<path d="M60 44 C68 30 86 32 80 42 C76 48 66 46 60 44 Z" fill="#F58BB0"/>' +
      '<circle cx="60" cy="42" r="6" fill="#F2547F"/>' +
    '</svg>'
};

document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('[data-illust]').forEach(function (el) {
    var svg = MT_ILLUST[el.getAttribute('data-illust')];
    if (svg) {
      el.innerHTML = svg;
      el.style.display = 'inline-flex';
      el.style.alignItems = 'center';
      el.style.justifyContent = 'center';
    }
  });
});
