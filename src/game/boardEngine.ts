import { BOARD_DIM } from './constants';
import { BoardCellData, BlockPiece, LineClearResult } from '../types';

export function createEmptyGrid(): BoardCellData[][] {
  const grid: BoardCellData[][] = [];
  for (let r = 0; r < BOARD_DIM; r++) {
    const row: BoardCellData[] = [];
    for (let c = 0; c < BOARD_DIM; c++) {
      row.push({
        occupied: false,
        colorIndex: 0,
        theme: null,
        isClearing: false,
      });
    }
    grid.push(row);
  }
  return grid;
}

export function canPlacePiece(grid: BoardCellData[][], piece: BlockPiece, startRow: number, startCol: number): boolean {
  for (const coord of piece.coordinates) {
    const r = startRow + coord.y;
    const c = startCol + coord.x;
    if (r < 0 || r >= BOARD_DIM || c < 0 || c >= BOARD_DIM) {
      return false;
    }
    if (grid[r][c].occupied) {
      return false;
    }
  }
  return true;
}

export function canPieceFitAnywhere(grid: BoardCellData[][], piece: BlockPiece): boolean {
  for (let r = 0; r <= BOARD_DIM - piece.height; r++) {
    for (let c = 0; c <= BOARD_DIM - piece.width; c++) {
      if (canPlacePiece(grid, piece, r, c)) {
        return true;
      }
    }
  }
  return false;
}

export function placePieceOnGrid(
  grid: BoardCellData[][],
  piece: BlockPiece,
  startRow: number,
  startCol: number
): BoardCellData[][] {
  const newGrid = grid.map((row) => row.map((cell) => ({ ...cell })));
  for (const coord of piece.coordinates) {
    const r = startRow + coord.y;
    const c = startCol + coord.x;
    newGrid[r][c] = {
      occupied: true,
      colorIndex: piece.colorIndex,
      theme: piece.theme,
      isClearing: false,
    };
  }
  return newGrid;
}

export function findCompletedLines(grid: BoardCellData[][]): LineClearResult {
  const rows: number[] = [];
  const cols: number[] = [];

  for (let r = 0; r < BOARD_DIM; r++) {
    let full = true;
    for (let c = 0; c < BOARD_DIM; c++) {
      if (!grid[r][c].occupied) {
        full = false;
        break;
      }
    }
    if (full) rows.push(r);
  }

  for (let c = 0; c < BOARD_DIM; c++) {
    let full = true;
    for (let r = 0; r < BOARD_DIM; r++) {
      if (!grid[r][c].occupied) {
        full = false;
        break;
      }
    }
    if (full) cols.push(c);
  }

  return { rows, cols };
}

export function markLinesForClearing(grid: BoardCellData[][], lines: LineClearResult): BoardCellData[][] {
  const newGrid = grid.map((row) => row.map((cell) => ({ ...cell })));
  for (const r of lines.rows) {
    for (let c = 0; c < BOARD_DIM; c++) {
      newGrid[r][c].isClearing = true;
    }
  }
  for (const c of lines.cols) {
    for (let r = 0; r < BOARD_DIM; r++) {
      newGrid[r][c].isClearing = true;
    }
  }
  return newGrid;
}

export function executeClearOnGrid(grid: BoardCellData[][], lines: LineClearResult): BoardCellData[][] {
  const newGrid = grid.map((row) => row.map((cell) => ({ ...cell })));
  for (const r of lines.rows) {
    for (let c = 0; c < BOARD_DIM; c++) {
      newGrid[r][c] = {
        occupied: false,
        colorIndex: 0,
        theme: null,
        isClearing: false,
      };
    }
  }
  for (const c of lines.cols) {
    for (let r = 0; r < BOARD_DIM; r++) {
      newGrid[r][c] = {
        occupied: false,
        colorIndex: 0,
        theme: null,
        isClearing: false,
      };
    }
  }
  return newGrid;
}

export function countOccupiedCells(grid: BoardCellData[][]): number {
  let count = 0;
  for (let r = 0; r < BOARD_DIM; r++) {
    for (let c = 0; c < BOARD_DIM; c++) {
      if (grid[r][c].occupied) count++;
    }
  }
  return count;
}
