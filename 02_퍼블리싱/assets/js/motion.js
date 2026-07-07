/* ============================================================
   Mom's Time — Motion Script
   .content 하위 블록을 순차 리빌하고, 버튼/탭에 리플을 추가.
   JS 미작동 시 리빌 클래스가 안 붙으므로 콘텐츠는 항상 노출.
   ============================================================ */
(function () {
  var reduce = window.matchMedia &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  function ready(fn) {
    if (document.readyState !== 'loading') fn();
    else document.addEventListener('DOMContentLoaded', fn);
  }

  ready(function () {
    if (!reduce) setupReveal();
    setupRipple();
  });

  /* 스크롤 진입 시 순차 등장 */
  function setupReveal() {
    if (!('IntersectionObserver' in window)) return;

    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) {
          e.target.classList.add('mt-in');
          io.unobserve(e.target);
        }
      });
    }, { threshold: 0.06, rootMargin: '0px 0px -5% 0px' });

    document.querySelectorAll('.content').forEach(function (scope) {
      var kids = Array.prototype.filter.call(scope.children, function (el) {
        return el.nodeType === 1 && !el.hasAttribute('data-no-reveal');
      });
      kids.forEach(function (el, i) {
        el.classList.add('mt-reveal');
        el.style.transitionDelay = Math.min(i * 65, 380) + 'ms';
        io.observe(el);
      });
    });
  }

  /* 눌림 리플 */
  function setupRipple() {
    document.addEventListener('pointerdown', function (ev) {
      var t = ev.target.closest('.btn, .bottom-nav__item, .quick-menu__item, .sns-btn, .fab');
      if (!t) return;
      if (reduce) return;
      var rect = t.getBoundingClientRect();
      var d = Math.max(rect.width, rect.height);
      var rip = document.createElement('span');
      rip.className = 'mt-rip';
      rip.style.width = rip.style.height = d + 'px';
      rip.style.left = (ev.clientX - rect.left - d / 2) + 'px';
      rip.style.top = (ev.clientY - rect.top - d / 2) + 'px';
      if (getComputedStyle(t).position === 'static') t.style.position = 'relative';
      t.classList.add('mt-ripple');
      t.appendChild(rip);
      setTimeout(function () { rip.remove(); }, 650);
    }, { passive: true });
  }
})();
