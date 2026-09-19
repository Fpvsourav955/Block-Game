import { RAW_SHAPES, BLOCK_PALETTE } from './constants';
import { BlockPiece, BoardCellData } from '../types';
import { countOccupiedCells, canPieceFitAnywhere } from './boardEngine';

export function createPieceFromRaw(
  raw: typeof RAW_SHAPES[0],
  overrideColor?: number
): BlockPiece {
  const colorIndex = overrideColor !== undefined ? overrideColor : raw.colorIndex;
  const theme = BLOCK_PALETTE[colorIndex % BLOCK_PALETTE.length];
  const coordinates = raw.coords.map(([x, y]) => ({ x, y }));
  const width = Math.max(...coordinates.map((c) => c.x)) + 1;
  const height = Math.max(...coordinates.map((c) => c.y)) + 1;

  return {
    id: `${raw.id}_${Date.now()}_${Math.random().toString(36).substring(2, 7)}`,
    name: raw.name,
    coordinates,
    colorIndex,
    theme,
    width,
    height,
  };
}

export function generatePieceTray(grid: BoardCellData[][]): BlockPiece[] {
  const tray: BlockPiece[] = [];
  const usedColors: number[] = [];

  const smallPool = RAW_SHAPES.filter((s) => s.coords.length <= 3);
  const mediumPool = RAW_SHAPES.filter((s) => s.coords.length === 4);
  const largePool = RAW_SHAPES.filter((s) => s.coords.length >= 5);

  const getUnusedColor = (): number => {
    const available = Array.from({ length: BLOCK_PALETTE.length }, (_, i) => i).filter(
      (c) => !usedColors.includes(c)
    );
    const color = available.length > 0
      ? available[Math.floor(Math.random() * available.length)]
      : Math.floor(Math.random() * BLOCK_PALETTE.length);
    usedColors.push(color);
    return color;
  };

  const occupied = countOccupiedCells(grid);

  if (occupied > 40) {
    tray.push(createPieceFromRaw(smallPool[Math.floor(Math.random() * smallPool.length)], getUnusedColor()));
    tray.push(createPieceFromRaw(smallPool[Math.floor(Math.random() * smallPool.length)], getUnusedColor()));
    tray.push(createPieceFromRaw(mediumPool[Math.floor(Math.random() * mediumPool.length)], getUnusedColor()));
  } else if (occupied > 24) {
    tray.push(createPieceFromRaw(smallPool[Math.floor(Math.random() * smallPool.length)], getUnusedColor()));
    tray.push(createPieceFromRaw(mediumPool[Math.floor(Math.random() * mediumPool.length)], getUnusedColor()));
    tray.push(createPieceFromRaw(RAW_SHAPES[Math.floor(Math.random() * RAW_SHAPES.length)], getUnusedColor()));
  } else {
    tray.push(createPieceFromRaw(smallPool[Math.floor(Math.random() * smallPool.length)], getUnusedColor()));
    tray.push(createPieceFromRaw(mediumPool[Math.floor(Math.random() * mediumPool.length)], getUnusedColor()));
    tray.push(createPieceFromRaw(largePool[Math.floor(Math.random() * largePool.length)], getUnusedColor()));
  }

  const atLeastOneFits = tray.some((piece) => canPieceFitAnywhere(grid, piece));
  if (!atLeastOneFits) {
    const fittingSmall = smallPool
      .map((s) => createPieceFromRaw(s, getUnusedColor()))
      .filter((p) => canPieceFitAnywhere(grid, p));
    if (fittingSmall.length > 0) {
      tray[0] = fittingSmall[Math.floor(Math.random() * fittingSmall.length)];
    }
  }

  return tray.sort(() => Math.random() - 0.5);
}
