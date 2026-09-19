import React from 'react';
import { BlockPiece } from '../types';
import { BlockCell } from './BlockCell';

interface PieceTrayProps {
  pieces: (BlockPiece | null)[];
  draggedIndex: number | null;
  onPiecePointerDown: (index: number, e: React.PointerEvent) => void;
}

export const PieceTray: React.FC<PieceTrayProps> = ({
  pieces,
  draggedIndex,
  onPiecePointerDown,
}) => {
  return (
    <div
      id="piece-tray-container"
      className="w-full max-w-[420px] mx-auto h-[120px] sm:h-[135px] px-2 flex items-center justify-around gap-2 select-none"
    >
      {pieces.map((piece, index) => {
        const isDragging = draggedIndex === index;

        return (
          <div
            key={index}
            id={`tray-slot-${index}`}
            className="flex-1 h-full rounded-2xl bg-[#0D1730]/40 border border-[#1E293B]/40 flex items-center justify-center p-2 relative"
          >
            {piece && (
              <div
                id={`piece-${index}`}
                onPointerDown={(e) => onPiecePointerDown(index, e)}
                style={{
                  opacity: isDragging ? 0 : 1,
                  touchAction: 'none',
                }}
                className="cursor-grab active:cursor-grabbing transition-transform duration-150 hover:scale-105 active:scale-95 flex items-center justify-center"
              >
                <div
                  className="grid gap-[2px]"
                  style={{
                    gridTemplateColumns: `repeat(${piece.width}, minmax(0, 1fr))`,
                    gridTemplateRows: `repeat(${piece.height}, minmax(0, 1fr))`,
                  }}
                >
                  {Array.from({ length: piece.height }).map((_, r) =>
                    Array.from({ length: piece.width }).map((_, c) => {
                      const hasBlock = piece.coordinates.some(
                        (coord) => coord.x === c && coord.y === r
                      );
                      return (
                        <div
                          key={`${r}-${c}`}
                          className="w-[18px] h-[18px] sm:w-[22px] sm:h-[22px] flex items-center justify-center"
                        >
                          {hasBlock ? (
                            <BlockCell theme={piece.theme} />
                          ) : (
                            <div className="w-full h-full" />
                          )}
                        </div>
                      );
                    })
                  )}
                </div>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};
