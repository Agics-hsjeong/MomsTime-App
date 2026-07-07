/* ============================================================
   Mom's Time — Common Script (퍼블리싱 데모 인터랙션)
   ============================================================ */

document.addEventListener('DOMContentLoaded', function () {
  // 뒤로가기 버튼 (히스토리 없으면 홈 또는 지정 화면으로 폴백)
  document.querySelectorAll('[data-back]').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var fallback = btn.getAttribute('data-back') || '05_home.html';
      if (window.history.length > 1) history.back();
      else window.location.href = fallback;
    });
  });

  // 세그먼트 / 탭 활성화 토글
  document.querySelectorAll('.segment, .tabs').forEach(function (group) {
    group.addEventListener('click', function (e) {
      var btn = e.target.closest('.segment__btn, .tabs__btn');
      if (!btn) return;
      group.querySelectorAll('.is-active').forEach(function (el) {
        el.classList.remove('is-active');
      });
      btn.classList.add('is-active');

      // data-tab-target이 있으면 해당 패널 전환
      var target = btn.getAttribute('data-tab-target');
      if (target) {
        var scope = group.closest('[data-tab-scope]') || document;
        scope.querySelectorAll('[data-tab-panel]').forEach(function (panel) {
          panel.hidden = panel.getAttribute('data-tab-panel') !== target;
        });
      }
    });
  });

  // 원형 체크 토글 (복약 완료 등)
  document.querySelectorAll('.check-circle[data-toggle]').forEach(function (chk) {
    chk.addEventListener('click', function () {
      chk.classList.toggle('is-checked');
    });
  });

  // 다이얼로그 열기/닫기
  document.querySelectorAll('[data-dialog-open]').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var dlg = document.getElementById(btn.getAttribute('data-dialog-open'));
      if (dlg) dlg.hidden = false;
    });
  });
  document.querySelectorAll('[data-dialog-close]').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var dlg = btn.closest('.dialog-backdrop');
      if (dlg) dlg.hidden = true;
    });
  });
});

/* ---- 행 전체를 상세 화면으로 연결 (내부 컨트롤 클릭은 제외) ---- */
document.addEventListener('click', function (e) {
  var row = e.target.closest('[data-href]');
  if (!row) return;
  if (e.target.closest('a, button, input, label, select, textarea, .switch, .check-circle')) return;
  window.location.href = row.getAttribute('data-href');
});
document.addEventListener('keydown', function (e) {
  if (e.key !== 'Enter' && e.key !== ' ') return;
  var el = e.target;
  if (el && el.getAttribute && el.getAttribute('data-href')) {
    e.preventDefault();
    window.location.href = el.getAttribute('data-href');
  }
});
