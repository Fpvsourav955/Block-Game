import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../config/color_config.dart';
import '../config/game_config.dart';
import '../systems/board_system.dart';
import '../models/block_piece.dart';
import 'block_component.dart';

class BoardComponent extends PositionComponent {
  final BoardSystem boardSystem;
  double cellSize = 0.0;
  double cellSpacing = GameConfig.cellSpacing;

  List<PieceCoordinate>? activePreviewCoords;
  int? previewRow;
  int? previewCol;
  BlockPiece? previewPiece;
  bool previewValid = false;

  BoardComponent({
    required this.boardSystem,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    calculateCellSize();
  }

  void calculateCellSize() {
    final availableSize = size.x - (cellSpacing * (GameConfig.boardDimension + 1));
    cellSize = availableSize / GameConfig.boardDimension;
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    calculateCellSize();
  }

  void updatePreview({
    required BlockPiece? piece,
    required int? startRow,
    required int? startCol,
    required bool isValid,
  }) {
    previewPiece = piece;
    previewRow = startRow;
    previewCol = startCol;
    previewValid = isValid;
    if (piece != null) {
      activePreviewCoords = piece.coordinates;
    } else {
      activePreviewCoords = null;
    }
  }

  void clearPreview() {
    previewPiece = null;
    previewRow = null;
    previewCol = null;
    activePreviewCoords = null;
    previewValid = false;
  }

  Rect getCellRect(int row, int col) {
    final x = cellSpacing + col * (cellSize + cellSpacing);
    final y = cellSpacing + row * (cellSize + cellSpacing);
    return Rect.fromLTWH(x, y, cellSize, cellSize);
  }

  (int, int)? getGridCoordinates(Vector2 localPos) {
    for (int r = 0; r < GameConfig.boardDimension; r++) {
      for (int c = 0; c < GameConfig.boardDimension; c++) {
        final rect = getCellRect(r, c);
        if (rect.inflate(cellSpacing).contains(Offset(localPos.x, localPos.y))) {
          return (r, c);
        }
      }
    }
    return null;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final boardRect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(boardRect, const Radius.circular(GameConfig.boardCornerRadius));

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawRRect(rrect.shift(const Offset(0, 8)), shadowPaint);

    final borderGradient = Paint()
      ..shader = ui.Gradient.linear(
        boardRect.topLeft,
        boardRect.bottomRight,
        [
          const Color(0xFF2A437E),
          const Color(0xFF14244D),
          const Color(0xFF0D1836),
        ],
      )
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, borderGradient);

    final innerBoardRect = boardRect.deflate(2.0);
    final innerRRect = RRect.fromRectAndRadius(innerBoardRect, const Radius.circular(GameConfig.boardCornerRadius - 2));
    final bgPaint = Paint()
      ..color = ColorConfig.boardBackground
      ..style = PaintingStyle.fill;
    canvas.drawRRect(innerRRect, bgPaint);

    for (int r = 0; r < GameConfig.boardDimension; r++) {
      for (int c = 0; c < GameConfig.boardDimension; c++) {
        final cellRect = getCellRect(r, c);
        final cellRRect = RRect.fromRectAndRadius(cellRect, const Radius.circular(GameConfig.blockCornerRadius));

        final cellBgPaint = Paint()
          ..color = ColorConfig.cellEmpty
          ..style = PaintingStyle.fill;
        canvas.drawRRect(cellRRect, cellBgPaint);

        final cellBorderPaint = Paint()
          ..color = ColorConfig.cellEmptyBorder
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawRRect(cellRRect, cellBorderPaint);

        final cell = boardSystem.grid[r][c];
        if (cell.isOccupied) {
          BlockPainter.drawBlock(
            canvas: canvas,
            rect: cellRect,
            theme: cell.block!.theme,
            radius: GameConfig.blockCornerRadius,
            opacity: cell.isClearing ? 0.35 : 1.0,
          );
        }
      }
    }

    if (previewPiece != null && previewRow != null && previewCol != null && previewValid) {
      for (final coord in previewPiece!.coordinates) {
        final r = previewRow! + coord.y;
        final c = previewCol! + coord.x;
        if (r >= 0 && r < GameConfig.boardDimension && c >= 0 && c < GameConfig.boardDimension) {
          final previewRect = getCellRect(r, c);
          BlockPainter.drawBlock(
            canvas: canvas,
            rect: previewRect,
            theme: previewPiece!.theme,
            radius: GameConfig.blockCornerRadius,
            isGhostPreview: true,
          );
        }
      }
    }
  }
}
