import React from 'react';
import { BlockTheme } from '../types';

interface BlockCellProps {
  theme?: BlockTheme | null;
  size?: number;
  isGhost?: boolean;
  isClearing?: boolean;
  className?: string;
}

export const BlockCell: React.FC<BlockCellProps> = ({
  theme,
  size,
  isGhost = false,
  isClearing = false,
  className = '',
}) => {
  if (!theme) {
    return (
      <div
        className={`w-full h-full rounded-[4px] bg-[#111E3D] border border-[#172952]/60 transition-colors ${className}`}
        style={size ? { width: size, height: size } : undefined}
      />
    );
  }

  if (isGhost) {
    return (
      <div
        className={`w-full h-full rounded-[4px] transition-all duration-75 ${className}`}
        style={{
          width: size,
          height: size,
          backgroundColor: `${theme.base}66`,
          boxShadow: `0 0 10px ${theme.glow}88, inset 0 0 4px ${theme.highlight}`,
          border: `2px solid ${theme.highlight}CC`,
        }}
      />
    );
  }

  return (
    <div
      className={`relative w-full h-full rounded-[5px] select-none overflow-hidden transition-transform ${
        isClearing ? 'animate-pulse scale-90 opacity-40' : ''
      } ${className}`}
      style={{
        width: size,
        height: size,
        background: `linear-gradient(145deg, ${theme.highlight} 0%, ${theme.base} 45%, ${theme.shadow} 100%)`,
        boxShadow: `inset 0 2px 2px rgba(255,255,255,0.4), inset 0 -2px 2px rgba(0,0,0,0.35), inset 2px 0 2px rgba(255,255,255,0.18), inset -2px 0 2px rgba(0,0,0,0.2), 0 3px 6px rgba(0,0,0,0.35)`,
      }}
    >
      {/* 20-30% 3D Top-Left Bevel Highlight */}
      <div className="absolute inset-[2px] rounded-[3px] bg-gradient-to-br from-white/25 via-transparent to-transparent pointer-events-none" />
      {/* Subtle bottom shadow ridge */}
      <div className="absolute bottom-0 inset-x-0 h-[2.5px] bg-black/35 pointer-events-none" />
      {/* Subtle top edge specular gleam */}
      <div className="absolute top-0 inset-x-0 h-[1.5px] bg-white/45 pointer-events-none" />
    </div>
  );
};
