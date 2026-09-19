import React from 'react';
import { BOARD_DIM } from '../game/constants';
import { BoardCellData, BlockPiece } from '../types';
import { BlockCell } from './BlockCell';

interface GameBoardProps {
  grid: BoardCellData[][];
  previewPiece: BlockPiece | null;
  previewRow: number | null;
  previewCol: number | null;
  previewValid: boolean;
  onBoardLayoutChange?: (rect: DOMRect) => void;
  boardRef: React.RefObject<HTMLDivElement | null>;
}

export const GameBoard: React.FC<GameBoardProps> = ({
  grid,
  previewPiece,
  previewRow,
  previewCol,
  previewValid,
  boardRef,
}) => {
  const isPreviewCell = (r: number, c: number): boolean => {
    if (!previewPiece || previewRow === null || previewCol === null || !previewValid) {
      return false;
    }
    return previewPiece.coordinates.some(
      (coord) => previewRow + coord.y === r && previewCol + coord.x === c
    );
  };

  return (
    <div className="relative w-full max-w-[390px] aspect-square mx-auto p-2 sm:p-3 select-none">
      {/* Outer 3D Board Frame with Bevel and Glow */}
      <div
        ref={boardRef}
        id="game-board-container"
        className="relative w-full h-full rounded-[20px] p-[6px] sm:p-2 bg-gradient-to-b from-[#1E3A8A] via-[#0D1836] to-[#080F24] shadow-[0_12px_32px_rgba(0,0,0,0.65),inset_0_2px_2px_rgba(255,255,255,0.2),inset_0_-3px_4px_rgba(0,0,0,0.5)] border border-[#25427C]/70"
      >
        {/* Inner Grid Container */}
        <div className="w-full h-full rounded-[14px] bg-[#0A1329] p-[3px] shadow-[inset_0_3px_8px_rgba(0,0,0,0.6)] grid grid-cols-8 grid-rows-8 gap-[3px]">
          {grid.map((row, r) =>
            row.map((cell, c) => {
              const inPreview = isPreviewCell(r, c);

              return (
                <div
                  key={`${r}-${c}`}
                  id={`cell-${r}-${c}`}
                  data-row={r}
                  data-col={c}
                  className="relative w-full h-full flex items-center justify-center"
                >
                  {cell.occupied ? (
                    <BlockCell
                      theme={cell.theme}
                      isClearing={cell.isClearing}
                    />
                  ) : inPreview && previewPiece ? (
                    <BlockCell
                      theme={previewPiece.theme}
                      isGhost={true}
                    />
                  ) : (
                    <BlockCell theme={null} />
                  )}
                </div>
              );
            })
          )}
        </div>
      </div>
    </div>
  );
};
