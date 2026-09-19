import 'package:flutter/material.dart';
import '../config/color_config.dart';

class PieceCoordinate {
  final int x;
  final int y;

  const PieceCoordinate(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PieceCoordinate && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class BlockPiece {
  final String id;
  final String name;
  final List<PieceCoordinate> coordinates;
  final int colorIndex;
  final BlockColorTheme theme;
  final int width;
  final int height;

  BlockPiece({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.colorIndex,
    required this.theme,
  })  : width = coordinates.map((c) => c.x).reduce((a, b) => a > b ? a : b) + 1,
        height = coordinates.map((c) => c.y).reduce((a, b) => a > b ? a : b) + 1;

  int get blockCount => coordinates.length;

  static List<BlockPiece> getTemplates() {
    return [
      _make('dot_1', 'Dot 1x1', [const PieceCoordinate(0, 0)], 0),
      _make('line_h_2', 'Line H2', [const PieceCoordinate(0, 0), const PieceCoordinate(1, 0)], 1),
      _make('line_v_2', 'Line V2', [const PieceCoordinate(0, 0), const PieceCoordinate(0, 1)], 1),
      _make('line_h_3', 'Line H3', [const PieceCoordinate(0, 0), const PieceCoordinate(1, 0), const PieceCoordinate(2, 0)], 2),
      _make('line_v_3', 'Line V3', [const PieceCoordinate(0, 0), const PieceCoordinate(0, 1), const PieceCoordinate(0, 2)], 2),
      _make('line_h_4', 'Line H4', [const PieceCoordinate(0, 0), const PieceCoordinate(1, 0), const PieceCoordinate(2, 0), const PieceCoordinate(3, 0)], 3),
      _make('line_v_4', 'Line V4', [const PieceCoordinate(0, 0), const PieceCoordinate(0, 1), const PieceCoordinate(0, 2), const PieceCoordinate(0, 3)], 3),
      _make('line_h_5', 'Line H5', [const PieceCoordinate(0, 0), const PieceCoordinate(1, 0), const PieceCoordinate(2, 0), const PieceCoordinate(3, 0), const PieceCoordinate(4, 0)], 4),
      _make('line_v_5', 'Line V5', [const PieceCoordinate(0, 0), const PieceCoordinate(0, 1), const PieceCoordinate(0, 2), const PieceCoordinate(0, 3), const PieceCoordinate(0, 4)], 4),
      _make('sq_2x2', 'Square 2x2', [
        const PieceCoordinate(0, 0), const PieceCoordinate(1, 0),
        const PieceCoordinate(0, 1), const PieceCoordinate(1, 1),
      ], 5),
      _make('sq_3x3', 'Square 3x3', [
        const PieceCoordinate(0, 0), const PieceCoordinate(1, 0), const PieceCoordinate(2, 0),
        const PieceCoordinate(0, 1), const PieceCoordinate(1, 1), const PieceCoordinate(2, 1),
        const PieceCoordinate(0, 2), const PieceCoordinate(1, 2), const PieceCoordinate(2, 2),
      ], 6),
      _make('rect_2x3', 'Rect 2x3', [
        const PieceCoordinate(0, 0), const PieceCoordinate(1, 0),
        const PieceCoordinate(0, 1), const PieceCoordinate(1, 1),
        const PieceCoordinate(0, 2), const PieceCoordinate(1, 2),
      ], 7),
      _make('rect_3x2', 'Rect 3x2', [
        const PieceCoordinate(0, 0), const PieceCoordinate(1, 0), const PieceCoordinate(2, 0),
        const PieceCoordinate(0, 1), const PieceCoordinate(1, 1), const PieceCoordinate(2, 1),
      ], 0),
      _make('l_3_tl', 'Corner 2x2 TL', [
        const PieceCoordinate(0, 0), const PieceCoordinate(1, 0),
        const PieceCoordinate(0, 1),
      ], 1),
      _make('l_3_tr', 'Corner 2x2 TR', [
        const PieceCoordinate(0, 0), const PieceCoordinate(1, 0),
        const PieceCoordinate(1, 1),
      ], 2),
      _make('l_3_bl', 'Corner 2x2 BL', [
        const PieceCoordinate(0, 0),
        const PieceCoordinate(0, 1), const PieceCoordinate(1, 1),
      ], 3),
      _make('l_3_br', 'Corner 2x2 BR', [
        const PieceCoordinate(1, 0),
        const PieceCoordinate(0, 1), const PieceCoordinate(1, 1),
      ], 4),
      _make('l_4_tl', 'L 3x3 TL', [
        const PieceCoordinate(0, 0), const PieceCoordinate(1, 0), const PieceCoordinate(2, 0),
        const PieceCoordinate(0, 1),
        const PieceCoordinate(0, 2),
      ], 5),
      _make('l_4_br', 'L 3x3 BR', [
        const PieceCoordinate(2, 0),
        const PieceCoordinate(2, 1),
        const PieceCoordinate(0, 2), const PieceCoordinate(1, 2), const PieceCoordinate(2, 2),
      ], 6),
      _make('t_up', 'T Up', [
        const PieceCoordinate(1, 0),
        const PieceCoordinate(0, 1), const PieceCoordinate(1, 1), const PieceCoordinate(2, 1),
      ], 7),
      _make('t_down', 'T Down', [
        const PieceCoordinate(0, 0), const PieceCoordinate(1, 0), const PieceCoordinate(2, 0),
        const PieceCoordinate(1, 1),
      ], 0),
      _make('z_h', 'Z Horizontal', [
        const PieceCoordinate(0, 0), const PieceCoordinate(1, 0),
        const PieceCoordinate(1, 1), const PieceCoordinate(2, 1),
      ], 1),
      _make('s_h', 'S Horizontal', [
        const PieceCoordinate(1, 0), const PieceCoordinate(2, 0),
        const PieceCoordinate(0, 1), const PieceCoordinate(1, 1),
      ], 2),
    ];
  }

  static BlockPiece _make(String id, String name, List<PieceCoordinate> coords, int colorIndex) {
    return BlockPiece(
      id: id,
      name: name,
      coordinates: coords,
      colorIndex: colorIndex,
      theme: ColorConfig.getThemeByIndex(colorIndex),
    );
  }

  BlockPiece clone() {
    return BlockPiece(
      id: id,
      name: name,
      coordinates: List.from(coordinates),
      colorIndex: colorIndex,
      theme: theme,
    );
  }
}
