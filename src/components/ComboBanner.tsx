import React from 'react';

interface ComboBannerProps {
  label: string;
  multiplier: number;
}

export const ComboBanner: React.FC<ComboBannerProps> = ({ label, multiplier }) => {
  if (!label) return null;

  return (
    <div
      id="combo-banner-overlay"
      className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-40 pointer-events-none flex flex-col items-center justify-center animate-[scaleBounce_0.4s_ease-out]"
    >
      <div className="relative">
        <h2 className="text-3xl sm:text-4xl font-black italic tracking-wider text-transparent bg-clip-text bg-gradient-to-r from-amber-300 via-yellow-200 to-amber-400 drop-shadow-[0_4px_12px_rgba(0,0,0,0.8)] font-['Fredoka']">
          {label}
        </h2>
        {multiplier > 1 && (
          <div className="text-center font-black text-cyan-300 text-lg sm:text-xl drop-shadow-[0_0_10px_rgba(6,182,212,0.8)] uppercase tracking-widest mt-1">
            Combo Multiplier x{multiplier}!
          </div>
        )}
      </div>
    </div>
  );
};
