import { BlockTheme } from '../types';

export const BOARD_DIM = 8;
export const TOTAL_CELLS = 64;

export const BLOCK_PALETTE: BlockTheme[] = [
  {
    name: 'Blue',
    base: '#2563EB',
    highlight: '#60A5FA',
    shadow: '#1D4ED8',
    glow: '#93C5FD',
  },
  {
    name: 'Cyan',
    base: '#06B6D4',
    highlight: '#67E8F9',
    shadow: '#0891B2',
    glow: '#A5F3FC',
  },
  {
    name: 'Green',
    base: '#16A34A',
    highlight: '#4ADE80',
    shadow: '#15803D',
    glow: '#86EFAC',
  },
  {
    name: 'Yellow',
    base: '#EAB308',
    highlight: '#FDE047',
    shadow: '#CA8A04',
    glow: '#FEF08A',
  },
  {
    name: 'Orange',
    base: '#EA580C',
    highlight: '#FB923C',
    shadow: '#C2410C',
    glow: '#FDBA74',
  },
  {
    name: 'Red',
    base: '#DC2626',
    highlight: '#F87171',
    shadow: '#B91C1C',
    glow: '#FCA5A5',
  },
  {
    name: 'Pink',
    base: '#DB2777',
    highlight: '#F472B6',
    shadow: '#BE185D',
    glow: '#FBCFE8',
  },
  {
    name: 'Purple',
    base: '#9333EA',
    highlight: '#C084FC',
    shadow: '#7E22CE',
    glow: '#E9D5FF',
  },
];

export const RAW_SHAPES: Array<{ id: string; name: string; coords: [number, number][]; colorIndex: number }> = [
  { id: 'dot_1', name: 'Dot 1x1', coords: [[0, 0]], colorIndex: 0 },
  { id: 'line_h_2', name: 'Line H2', coords: [[0, 0], [1, 0]], colorIndex: 1 },
  { id: 'line_v_2', name: 'Line V2', coords: [[0, 0], [0, 1]], colorIndex: 1 },
  { id: 'line_h_3', name: 'Line H3', coords: [[0, 0], [1, 0], [2, 0]], colorIndex: 2 },
  { id: 'line_v_3', name: 'Line V3', coords: [[0, 0], [0, 1], [0, 2]], colorIndex: 2 },
  { id: 'line_h_4', name: 'Line H4', coords: [[0, 0], [1, 0], [2, 0], [3, 0]], colorIndex: 3 },
  { id: 'line_v_4', name: 'Line V4', coords: [[0, 0], [0, 1], [0, 2], [0, 3]], colorIndex: 3 },
  { id: 'line_h_5', name: 'Line H5', coords: [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0]], colorIndex: 4 },
  { id: 'line_v_5', name: 'Line V5', coords: [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4]], colorIndex: 4 },
  {
    id: 'sq_2x2',
    name: 'Square 2x2',
    coords: [[0, 0], [1, 0], [0, 1], [1, 1]],
    colorIndex: 5,
  },
  {
    id: 'sq_3x3',
    name: 'Square 3x3',
    coords: [
      [0, 0], [1, 0], [2, 0],
      [0, 1], [1, 1], [2, 1],
      [0, 2], [1, 2], [2, 2],
    ],
    colorIndex: 6,
  },
  {
    id: 'rect_2x3',
    name: 'Rect 2x3',
    coords: [[0, 0], [1, 0], [0, 1], [1, 1], [0, 2], [1, 2]],
    colorIndex: 7,
  },
  {
    id: 'rect_3x2',
    name: 'Rect 3x2',
    coords: [[0, 0], [1, 0], [2, 0], [0, 1], [1, 1], [2, 1]],
    colorIndex: 0,
  },
  {
    id: 'l_3_tl',
    name: 'Corner 2x2 TL',
    coords: [[0, 0], [1, 0], [0, 1]],
    colorIndex: 1,
  },
  {
    id: 'l_3_tr',
    name: 'Corner 2x2 TR',
    coords: [[0, 0], [1, 0], [1, 1]],
    colorIndex: 2,
  },
  {
    id: 'l_3_bl',
    name: 'Corner 2x2 BL',
    coords: [[0, 0], [0, 1], [1, 1]],
    colorIndex: 3,
  },
  {
    id: 'l_3_br',
    name: 'Corner 2x2 BR',
    coords: [[1, 0], [0, 1], [1, 1]],
    colorIndex: 4,
  },
  {
    id: 'l_4_tl',
    name: 'L 3x3 TL',
    coords: [[0, 0], [1, 0], [2, 0], [0, 1], [0, 2]],
    colorIndex: 5,
  },
  {
    id: 'l_4_br',
    name: 'L 3x3 BR',
    coords: [[2, 0], [2, 1], [0, 2], [1, 2], [2, 2]],
    colorIndex: 6,
  },
  {
    id: 't_up',
    name: 'T Up',
    coords: [[1, 0], [0, 1], [1, 1], [2, 1]],
    colorIndex: 7,
  },
  {
    id: 't_down',
    name: 'T Down',
    coords: [[0, 0], [1, 0], [2, 0], [1, 1]],
    colorIndex: 0,
  },
  {
    id: 'z_h',
    name: 'Z Horizontal',
    coords: [[0, 0], [1, 0], [1, 1], [2, 1]],
    colorIndex: 1,
  },
  {
    id: 's_h',
    name: 'S Horizontal',
    coords: [[1, 0], [2, 0], [0, 1], [1, 1]],
    colorIndex: 2,
  },
];

export const POINTS_PER_BLOCK = 10;
export const POINTS_PER_LINE = 100;
export const MULTI_LINE_BONUS_MULTIPLIER = 50;
export const COMBO_BASE_BONUS = 80;
export const DRAG_FINGER_OFFSET_Y = 80;
