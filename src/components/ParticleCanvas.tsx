import React, { useRef, useEffect, useImperativeHandle, forwardRef } from 'react';

export interface ParticleCanvasHandle {
  spawnPlacement: (x: number, y: number, color: string) => void;
  spawnLineClear: (rects: { x: number; y: number; width: number; height: number; color: string }[]) => void;
  spawnComboStars: (x: number, y: number, color?: string) => void;
  spawnConfetti: () => void;
}

interface Particle {
  x: number;
  y: number;
  vx: number;
  vy: number;
  size: number;
  color: string;
  alpha: number;
  maxLife: number;
  life: number;
  shape: 'circle' | 'square' | 'star' | 'confetti';
  rotation: number;
  rotationSpeed: number;
}

export const ParticleCanvas = forwardRef<ParticleCanvasHandle>((_, ref) => {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const particlesRef = useRef<Particle[]>([]);
  const animFrameRef = useRef<number | null>(null);

  useImperativeHandle(ref, () => ({
    spawnPlacement: (x: number, y: number, color: string) => {
      for (let i = 0; i < 8; i++) {
        const angle = Math.random() * Math.PI * 2;
        const speed = 40 + Math.random() * 80;
        particlesRef.current.push({
          x,
          y,
          vx: Math.cos(angle) * speed,
          vy: Math.sin(angle) * speed - 20,
          size: 3 + Math.random() * 3,
          color,
          alpha: 1,
          maxLife: 0.35 + Math.random() * 0.2,
          life: 0.35 + Math.random() * 0.2,
          shape: 'circle',
          rotation: 0,
          rotationSpeed: 0,
        });
      }
    },
    spawnLineClear: (items) => {
      items.forEach((item) => {
        for (let i = 0; i < 5; i++) {
          const px = item.x + Math.random() * item.width;
          const py = item.y + Math.random() * item.height;
          const angle = Math.random() * Math.PI * 2;
          const speed = 70 + Math.random() * 110;
          particlesRef.current.push({
            x: px,
            y: py,
            vx: Math.cos(angle) * speed,
            vy: Math.sin(angle) * speed - 30,
            size: 5 + Math.random() * 5,
            color: item.color,
            alpha: 1,
            maxLife: 0.45 + Math.random() * 0.25,
            life: 0.45 + Math.random() * 0.25,
            shape: 'square',
            rotation: Math.random() * Math.PI,
            rotationSpeed: (Math.random() - 0.5) * 8,
          });
        }
      });
    },
    spawnComboStars: (x, y, color = '#67E8F9') => {
      for (let i = 0; i < 18; i++) {
        const angle = (i / 18) * Math.PI * 2 + (Math.random() - 0.5) * 0.2;
        const speed = 110 + Math.random() * 140;
        particlesRef.current.push({
          x,
          y,
          vx: Math.cos(angle) * speed,
          vy: Math.sin(angle) * speed - 40,
          size: 7 + Math.random() * 6,
          color,
          alpha: 1,
          maxLife: 0.65 + Math.random() * 0.3,
          life: 0.65 + Math.random() * 0.3,
          shape: 'star',
          rotation: Math.random() * Math.PI,
          rotationSpeed: (Math.random() - 0.5) * 6,
        });
      }
    },
    spawnConfetti: () => {
      const colors = ['#FACC15', '#38BDF8', '#4ADE80', '#F472B6', '#C084FC', '#FB923C'];
      const rect = canvasRef.current?.getBoundingClientRect();
      const w = rect?.width || window.innerWidth;
      const h = rect?.height || window.innerHeight;

      for (let i = 0; i < 60; i++) {
        particlesRef.current.push({
          x: w * (0.2 + Math.random() * 0.6),
          y: h * 0.3 + Math.random() * 50,
          vx: (Math.random() - 0.5) * 300,
          vy: -150 - Math.random() * 250,
          size: 6 + Math.random() * 6,
          color: colors[Math.floor(Math.random() * colors.length)],
          alpha: 1,
          maxLife: 1.4 + Math.random() * 0.6,
          life: 1.4 + Math.random() * 0.6,
          shape: 'confetti',
          rotation: Math.random() * Math.PI * 2,
          rotationSpeed: (Math.random() - 0.5) * 12,
        });
      }
    },
  }));

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const resize = () => {
      const parent = canvas.parentElement;
      if (parent) {
        canvas.width = parent.clientWidth * window.devicePixelRatio;
        canvas.height = parent.clientHeight * window.devicePixelRatio;
      }
    };
    resize();
    window.addEventListener('resize', resize);

    let lastTime = performance.now();

    const loop = (time: number) => {
      const dt = Math.min((time - lastTime) / 1000, 0.1);
      lastTime = time;

      ctx.clearRect(0, 0, canvas.width, canvas.height);
      const scale = window.devicePixelRatio || 1;

      particlesRef.current = particlesRef.current.filter((p) => {
        p.life -= dt;
        if (p.life <= 0) return false;

        p.x += p.vx * dt;
        p.y += p.vy * dt;
        p.vy += (p.shape === 'confetti' ? 260 : 180) * dt;
        p.rotation += p.rotationSpeed * dt;
        p.alpha = Math.max(0, p.life / p.maxLife);

        ctx.save();
        ctx.globalAlpha = p.alpha;
        ctx.fillStyle = p.color;
        ctx.translate(p.x * scale, p.y * scale);
        ctx.rotate(p.rotation);

        const s = p.size * scale;
        if (p.shape === 'circle') {
          ctx.beginPath();
          ctx.arc(0, 0, s / 2, 0, Math.PI * 2);
          ctx.fill();
        } else if (p.shape === 'square' || p.shape === 'confetti') {
          ctx.fillRect(-s / 2, -s / 2, s, p.shape === 'confetti' ? s * 1.5 : s);
        } else if (p.shape === 'star') {
          ctx.beginPath();
          for (let k = 0; k < 5; k++) {
            ctx.lineTo(Math.cos(((18 + k * 72) * Math.PI) / 180) * s, -Math.sin(((18 + k * 72) * Math.PI) / 180) * s);
            ctx.lineTo(Math.cos(((54 + k * 72) * Math.PI) / 180) * (s / 2), -Math.sin(((54 + k * 72) * Math.PI) / 180) * (s / 2));
          }
          ctx.closePath();
          ctx.fill();
        }

        ctx.restore();
        return true;
      });

      animFrameRef.current = requestAnimationFrame(loop);
    };

    animFrameRef.current = requestAnimationFrame(loop);

    return () => {
      window.removeEventListener('resize', resize);
      if (animFrameRef.current) cancelAnimationFrame(animFrameRef.current);
    };
  }, []);

  return (
    <canvas
      ref={canvasRef}
      className="absolute inset-0 pointer-events-none w-full h-full z-30"
    />
  );
});

ParticleCanvas.displayName = 'ParticleCanvas';
