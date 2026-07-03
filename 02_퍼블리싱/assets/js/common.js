/* ============================================================
   Mom's Time — Common Script (퍼블리싱 데모 인터랙션)
   ============================================================ */

document.addEventListener('DOMContentLoaded', function () {
  // 뒤로가기 버튼
  document.querySelectorAll('[data-back]').forEach(function (btn) {
    btn.addEventListener('click', function () {
      history.back();
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
