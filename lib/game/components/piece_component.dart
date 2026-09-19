import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../models/block_piece.dart';
import '../config/game_config.dart';
import 'block_component.dart';

class PieceComponent extends PositionComponent {
  final BlockPiece piece;
  final double baseCellSize;
  double renderScale;
  bool isBeingDragged;
  double opacity;

  PieceComponent({
    required this.piece,
    required this.baseCellSize,
    required Vector2 position,
    this.renderScale = GameConfig.trayPieceScale,
    this.isBeingDragged = false,
    this.opacity = 1.0,
  }) : super(
          position: position,
          size: Vector2(
            piece.width * baseCellSize * renderScale,
            piece.height * baseCellSize * renderScale,
          ),
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (opacity <= 0.0) return;

    final scaledCellSize = baseCellSize * renderScale;
    final spacing = GameConfig.cellSpacing * renderScale;

    if (isBeingDragged) {
      final glowPaint = Paint()
        ..color = piece.theme.glow.withOpacity(0.35 * opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      for (final coord in piece.coordinates) {
        final rect = Rect.fromLTWH(
          coord.x * (scaledCellSize + spacing),
          coord.y * (scaledCellSize + spacing),
          scaledCellSize,
          scaledCellSize,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(GameConfig.blockCornerRadius * renderScale)),
          glowPaint,
        );
      }
    }

    for (final coord in piece.coordinates) {
      final rect = Rect.fromLTWH(
        coord.x * (scaledCellSize + spacing),
        coord.y * (scaledCellSize + spacing),
        scaledCellSize,
        scaledCellSize,
      );

      BlockPainter.drawBlock(
        canvas: canvas,
        rect: rect,
        theme: piece.theme,
        radius: GameConfig.blockCornerRadius * renderScale,
        opacity: opacity,
      );
    }
  }
}
