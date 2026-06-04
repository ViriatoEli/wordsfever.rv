/* ═══════════════════════════════════════
   WORDS FEVER · particles.js
   Canvas ember particle system
═══════════════════════════════════════ */

(function() {
  const canvas = document.getElementById('hero-canvas');
  if (!canvas) return;

  const ctx = canvas.getContext('2d');
  let W, H;

  function resize() {
    const p = canvas.parentElement;
    W = canvas.width  = p.offsetWidth;
    H = canvas.height = p.offsetHeight;
  }
  window.addEventListener('resize', resize, { passive: true });
  resize();

  const PALETTE = ['#FF4D1C','#FF6B35','#FF8C42','#FFAA55','#FFDB58','#FF3300'];

  class Ember {
    constructor(init) { this.spawn(init); }

    spawn(init) {
      this.x     = Math.random() * W;
      this.y     = init ? Math.random() * H : H + 12;
      this.r     = Math.random() * 2.4 + 0.4;
      this.vy    = -(Math.random() * 0.8 + 0.22);
      this.vx    = (Math.random() - 0.5) * 0.35;
      this.life  = 1;
      this.decay = Math.random() * 0.0035 + 0.0006;
      this.color = PALETTE[Math.floor(Math.random() * PALETTE.length)];
      this.angle = Math.random() * Math.PI * 2;
      this.wob   = (Math.random() - 0.5) * 0.045;
    }

    update() {
      this.y     += this.vy;
      this.x     += this.vx + Math.sin(this.angle) * 0.28;
      this.angle += this.wob;
      this.life  -= this.decay;
      if (this.life <= 0 || this.y < -12) this.spawn(false);
    }

    draw() {
      ctx.save();
      ctx.globalAlpha = this.life * 0.58;
      ctx.fillStyle   = this.color;
      ctx.shadowColor = this.color;
      ctx.shadowBlur  = 10;
      ctx.beginPath();
      ctx.arc(this.x, this.y, this.r, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
    }
  }

  const COUNT  = 130;
  const embers = Array.from({ length: COUNT }, () => new Ember(true));

  let running = true;
  document.addEventListener('visibilitychange', () => { running = !document.hidden; });

  (function loop() {
    if (running) {
      ctx.clearRect(0, 0, W, H);
      for (const e of embers) { e.update(); e.draw(); }
    }
    requestAnimationFrame(loop);
  })();
})();
