export interface BlockTheme {
  name: string;
  base: string;
  highlight: string;
  shadow: string;
  glow: string;
}

export interface Coordinate {
  x: number;
  y: number;
}

export interface BlockPiece {
  id: string;
  name: string;
  coordinates: Coordinate[];
  colorIndex: number;
  theme: BlockTheme;
  width: number;
  height: number;
}

export interface BoardCellData {
  occupied: boolean;
  colorIndex: number;
  theme: BlockTheme | null;
  isClearing: boolean;
}

export interface DragState {
  piece: BlockPiece;
  trayIndex: number;
  currentX: number;
  currentY: number;
  targetRow: number | null;
  targetCol: number | null;
  isValid: boolean;
}

export interface GameSettingsState {
  soundEnabled: boolean;
  musicEnabled: boolean;
  vibrationEnabled: boolean;
}

export interface CareerStats {
  highScore: number;
  totalGamesPlayed: number;
  totalLinesCleared: number;
  highestCombo: number;
}

export interface LineClearResult {
  rows: number[];
  cols: number[];
}
