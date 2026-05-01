/* ═══════════════════════════════════════
   WORDS FEVER · core.js
   Nav · Hamburger · Tabs · Reveal · Counters · Page transitions
═══════════════════════════════════════ */

document.addEventListener('DOMContentLoaded', () => {

  /* ── NAV SCROLL ── */
  const nav = document.querySelector('nav');
  if (nav) {
    window.addEventListener('scroll', () => {
      nav.classList.toggle('scrolled', scrollY > 40);
    }, { passive: true });
  }

  /* ── ACTIVE NAV LINK ── */
  const page = location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.nav-links a, .mnav a').forEach(a => {
    const href = a.getAttribute('href');
    if (href === page || (page === '' && href === 'index.html')) {
      a.classList.add('active');
    }
  });

  /* ── HAMBURGER ── */
  const hbg  = document.getElementById('hbg');
  const mnav = document.getElementById('mnav');
  if (hbg && mnav) {
    hbg.addEventListener('click', () => {
      hbg.classList.toggle('open');
      mnav.classList.toggle('open');
    });
  }

  /* ── CLOSE MENU ON LINK CLICK ── */
  window.closeMenu = function() {
    if (hbg)  hbg.classList.remove('open');
    if (mnav) mnav.classList.remove('open');
  };

  /* ── SMOOTH PAGE TRANSITIONS ── */
  document.querySelectorAll('a[href$=".html"]').forEach(link => {
    link.addEventListener('click', e => {
      const href = link.getAttribute('href');
      if (href && !href.startsWith('#') && !link.hasAttribute('download')) {
        e.preventDefault();
        document.body.classList.add('exit');
        setTimeout(() => { window.location.href = href; }, 350);
      }
    });
  });

  /* ── SCROLL REVEAL ── */
  const ro = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (e.isIntersecting) { e.target.classList.add('visible'); ro.unobserve(e.target); }
    });
  }, { threshold: 0.1 });
  document.querySelectorAll('.reveal, .rl, .rr').forEach(el => ro.observe(el));

  /* ── ANIMATED COUNTERS ── */
  function runCounter(el, target, duration) {
    const start = performance.now();
    const tick = now => {
      const p   = Math.min((now - start) / duration, 1);
      const val = 1 - Math.pow(1 - p, 3); // cubic ease-out
      el.textContent = Math.round(val * target);
      if (p < 1) requestAnimationFrame(tick);
    };
    requestAnimationFrame(tick);
  }
  const co = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (e.isIntersecting) {
        const t = parseInt(e.target.dataset.count);
        if (!isNaN(t)) runCounter(e.target, t, 1400);
        co.unobserve(e.target);
      }
    });
  }, { threshold: 0.5 });
  document.querySelectorAll('[data-count]').forEach(el => co.observe(el));

  /* ── TABS ── */
  window.setTab = function(id, btn) {
    const group = btn.closest('.tabs-group');
    const panels = group ? group.nextElementSibling : document;
    document.querySelectorAll('.tab').forEach(b => b.classList.remove('on'));
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('on'));
    btn.classList.add('on');
    const panel = document.getElementById('tab-' + id);
    if (panel) panel.classList.add('on');
  };

  /* ── FAQ ACCORDION ── */
  window.toggleFAQ = function(btn) {
    const item   = btn.closest('.faq-item');
    const isOpen = item.classList.contains('open');
    document.querySelectorAll('.faq-item.open').forEach(i => i.classList.remove('open'));
    if (!isOpen) item.classList.add('open');
  };

  /* ── AUTO-DETECT PLATFORM FOR DOWNLOAD PAGE ── */
  const isAndroid = /android/i.test(navigator.userAgent);
  const isIOS     = /iphone|ipad|ipod/i.test(navigator.userAgent);
  if (isIOS) {
    const iosBtn = document.querySelector('[data-tab="i"]');
    if (iosBtn) iosBtn.click();
  }

});
