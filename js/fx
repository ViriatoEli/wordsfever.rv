/* ═══════════════════════════════════════
   WORDS FEVER · fx.js
   Custom cursor · 3D card tilt · Magnetic buttons
═══════════════════════════════════════ */

document.addEventListener('DOMContentLoaded', () => {

  /* ── CUSTOM CURSOR ── */
  const cursor = document.createElement('div');
  cursor.className = 'cursor';
  document.body.appendChild(cursor);

  let mx = -200, my = -200, cx = -200, cy = -200;
  document.addEventListener('mousemove', e => { mx = e.clientX; my = e.clientY; }, { passive: true });

  document.querySelectorAll('a, button, [data-tilt]').forEach(el => {
    el.addEventListener('mouseenter', () => cursor.classList.add('big'));
    el.addEventListener('mouseleave', () => cursor.classList.remove('big'));
  });

  (function cursorLoop() {
    cx += (mx - cx) * 0.12;
    cy += (my - cy) * 0.12;
    cursor.style.transform = `translate(${cx - 11}px, ${cy - 11}px)`;
    requestAnimationFrame(cursorLoop);
  })();

  /* Hide scroll-hint as soon as user starts scrolling */
  const scrollHint = document.querySelector('.scroll-hint');
  if (scrollHint) {
    window.addEventListener('scroll', function hideHint() {
      scrollHint.classList.add('hidden');
      window.removeEventListener('scroll', hideHint);
    }, { passive: true });
  }

  /* ── 3D CARD TILT ── */
  document.querySelectorAll('[data-tilt]').forEach(card => {
    card.style.transition = 'transform .15s ease, box-shadow .15s ease';

    card.addEventListener('mousemove', e => {
      const r = card.getBoundingClientRect();
      const x = (e.clientX - r.left) / r.width  - 0.5;
      const y = (e.clientY - r.top)  / r.height - 0.5;
      card.style.transform = `perspective(900px) rotateY(${x * 11}deg) rotateX(${-y * 11}deg) translateZ(8px)`;
      card.style.setProperty('--mx', `${(x + 0.5) * 100}%`);
      card.style.setProperty('--my', `${(y + 0.5) * 100}%`);
    });

    card.addEventListener('mouseleave', () => {
      card.style.transform = '';
      card.style.setProperty('--mx', '50%');
      card.style.setProperty('--my', '50%');
    });
  });

  /* ── MAGNETIC BUTTONS ── */
  document.querySelectorAll('.btn').forEach(btn => {
    btn.addEventListener('mousemove', e => {
      const r = btn.getBoundingClientRect();
      const x = (e.clientX - r.left - r.width  / 2) * 0.28;
      const y = (e.clientY - r.top  - r.height / 2) * 0.28;
      btn.style.transform = `translate(${x}px, ${y}px) translateY(-3px) scale(1.02)`;
    });
    btn.addEventListener('mouseleave', () => {
      btn.style.transform = '';
    });
  });

  /* ── WORD CHIP HOVER STAGGER ── */
  document.querySelectorAll('.wchip').forEach((chip, i) => {
    chip.style.transitionDelay = `${i * 40}ms`;
    chip.style.transition = 'background .3s, border-color .3s, color .3s';
  });

});
