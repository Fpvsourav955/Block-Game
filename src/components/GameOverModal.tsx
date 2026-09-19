import React, { useEffect, useState } from 'react';
import { RotateCcw, Home, Crown, Star, Flame, Trophy } from 'lucide-react';

interface GameOverModalProps {
  isOpen: boolean;
  score: number;
  highScore: number;
  linesCleared: number;
  maxCombo: number;
  isNewRecord: boolean;
  onPlayAgain: () => void;
  onHome: () => void;
}

export const GameOverModal: React.FC<GameOverModalProps> = ({
  isOpen,
  score,
  highScore,
  linesCleared,
  maxCombo,
  isNewRecord,
  onPlayAgain,
  onHome,
}) => {
  const [animatedScore, setAnimatedScore] = useState(0);

  useEffect(() => {
    if (!isOpen) return;
    setAnimatedScore(0);

    const duration = 800;
    const start = performance.now();

    const frame = (now: number) => {
      const progress = Math.min((now - start) / duration, 1);
      const ease = 1 - Math.pow(1 - progress, 3);
      setAnimatedScore(Math.round(ease * score));
      if (progress < 1) {
        requestAnimationFrame(frame);
      }
    };

    requestAnimationFrame(frame);
  }, [isOpen, score]);

  if (!isOpen) return null;

  return (
    <div
      id="game-over-modal-backdrop"
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-[fadeIn_0.25s_ease-out]"
    >
      <div
        id="game-over-card"
        className={`w-full max-w-sm rounded-[28px] bg-[#1E293B] border-2 p-6 shadow-2xl flex flex-col items-center gap-4 text-white relative animate-[scaleBounce_0.35s_ease-out] ${
          isNewRecord
            ? 'border-amber-400 shadow-[0_0_40px_rgba(251,191,36,0.3)]'
            : 'border-sky-500/70 shadow-[0_0_30px_rgba(14,165,233,0.2)]'
        }`}
      >
        {/* New Record Banner or Game Over */}
        {isNewRecord ? (
          <div className="flex flex-col items-center gap-1">
            <div className="flex items-center gap-2">
              <Star className="w-6 h-6 text-amber-400 fill-amber-400 animate-spin" />
              <Crown className="w-10 h-10 text-amber-400 fill-amber-400 drop-shadow-[0_0_12px_rgba(250,204,21,0.8)]" />
              <Star className="w-6 h-6 text-amber-400 fill-amber-400 animate-spin" />
            </div>
            <h2 className="text-2xl font-black tracking-wider text-amber-300 font-['Fredoka'] drop-shadow-[0_2px_4px_rgba(0,0,0,0.5)]">
              NEW RECORD!
            </h2>
          </div>
        ) : (
          <div className="flex flex-col items-center gap-0.5">
            <Trophy className="w-8 h-8 text-sky-400 mb-1" />
            <h2 className="text-2xl font-black tracking-widest text-red-400 font-['Fredoka']">
              GAME OVER
            </h2>
          </div>
        )}

        {/* Big Animated Score */}
        <div className="flex flex-col items-center">
          <div className="text-5xl sm:text-6xl font-black tracking-tight text-white font-['Fredoka'] drop-shadow-[0_4px_8px_rgba(0,0,0,0.6)]">
            {animatedScore.toLocaleString()}
          </div>
          <div className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">
            Final Score
          </div>
        </div>

        {/* Stats Grid */}
        <div className="w-full grid grid-cols-3 gap-2 p-3 rounded-2xl bg-[#0F172A] border border-[#334155]">
          <div className="flex flex-col items-center">
            <div className="flex items-center gap-1 text-amber-400 mb-0.5">
              <Crown className="w-3.5 h-3.5 fill-amber-400" />
              <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Best</span>
            </div>
            <div className="text-base font-black text-white">{highScore.toLocaleString()}</div>
          </div>

          <div className="flex flex-col items-center border-x border-[#334155]">
            <div className="flex items-center gap-1 text-cyan-400 mb-0.5">
              <Flame className="w-3.5 h-3.5" />
              <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Lines</span>
            </div>
            <div className="text-base font-black text-cyan-400">{linesCleared}</div>
          </div>

          <div className="flex flex-col items-center">
            <div className="flex items-center gap-1 text-purple-400 mb-0.5">
              <Star className="w-3.5 h-3.5 fill-purple-400" />
              <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Combo</span>
            </div>
            <div className="text-base font-black text-purple-300">x{maxCombo}</div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="w-full flex flex-col gap-2.5 pt-2">
          <button
            id="play-again-btn"
            onClick={onPlayAgain}
            className="w-full py-3.5 px-4 rounded-2xl bg-gradient-to-b from-emerald-500 to-emerald-700 hover:from-emerald-400 hover:to-emerald-600 active:scale-95 text-white font-black text-lg tracking-wide shadow-[0_4px_0_#15803d,0_8px_16px_rgba(0,0,0,0.4)] flex items-center justify-center gap-2 transition-all"
          >
            <RotateCcw className="w-5 h-5" />
            <span>PLAY AGAIN</span>
          </button>

          <button
            id="home-btn"
            onClick={onHome}
            className="w-full py-2.5 px-4 rounded-xl bg-slate-800/80 hover:bg-slate-700 active:scale-95 text-slate-300 hover:text-white font-bold text-sm tracking-wide border border-slate-700 flex items-center justify-center gap-2 transition-all"
          >
            <Home className="w-4 h-4" />
            <span>MAIN MENU</span>
          </button>
        </div>
      </div>
    </div>
  );
};
