import React from 'react';
import { Crown, Settings, Zap } from 'lucide-react';

interface TopHUDProps {
  score: number;
  highScore: number;
  comboCount: number;
  onOpenSettings: () => void;
}

export const TopHUD: React.FC<TopHUDProps> = ({
  score,
  highScore,
  comboCount,
  onOpenSettings,
}) => {
  return (
    <header className="w-full max-w-[420px] mx-auto px-4 pt-3 pb-1 flex items-center justify-between select-none">
      {/* High Score Left */}
      <div
        id="hud-high-score"
        className="flex items-center gap-1.5 bg-[#172554]/60 border border-[#1E40AF]/40 rounded-full px-3 py-1.5 shadow-[0_2px_8px_rgba(0,0,0,0.3)]"
      >
        <Crown className="w-5 h-5 text-amber-400 drop-shadow-[0_2px_4px_rgba(250,204,21,0.5)] fill-amber-400" />
        <span className="font-extrabold text-amber-300 text-base tracking-wide font-['Fredoka']">
          {highScore.toLocaleString()}
        </span>
      </div>

      {/* Main Score Center */}
      <div className="flex flex-col items-center">
        <div
          id="hud-current-score"
          key={score}
          className="text-4xl sm:text-5xl font-black text-white tracking-tight font-['Fredoka'] drop-shadow-[0_4px_8px_rgba(0,0,0,0.5)] transition-transform duration-150 animate-[scaleBounce_0.2s_ease-out]"
        >
          {score.toLocaleString()}
        </div>
        {comboCount > 1 && (
          <div className="flex items-center gap-1 bg-gradient-to-r from-cyan-500 to-blue-600 text-white font-black text-xs px-2.5 py-0.5 rounded-full shadow-[0_0_12px_rgba(6,182,212,0.6)] animate-bounce mt-0.5">
            <Zap className="w-3 h-3 fill-yellow-300 text-yellow-300" />
            <span>COMBO x{comboCount}</span>
          </div>
        )}
      </div>

      {/* Settings Button Right */}
      <button
        id="hud-settings-btn"
        onClick={onOpenSettings}
        className="w-10 h-10 rounded-xl bg-[#1E293B]/70 hover:bg-[#334155]/80 active:scale-90 border border-[#334155] flex items-center justify-center text-slate-300 hover:text-white transition-all shadow-[0_2px_8px_rgba(0,0,0,0.3)]"
        aria-label="Settings"
      >
        <Settings className="w-5 h-5" />
      </button>
    </header>
  );
};
