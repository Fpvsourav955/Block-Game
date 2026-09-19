import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../models/block_piece.dart';
import '../config/game_config.dart';
import 'piece_component.dart';

class PieceTrayComponent extends PositionComponent {
  final List<BlockPiece?> pieces;
  final double cellSize;
  final List<PieceComponent?> slotComponents = [null, null, null];
  int? draggedSlotIndex;

  PieceTrayComponent({
    required this.pieces,
    required this.cellSize,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    refreshSlots();
  }

  void refreshSlots() {
    for (int i = 0; i < 3; i++) {
      slotComponents[i]?.removeFromParent();
      slotComponents[i] = null;

      final piece = pieces[i];
      if (piece != null && draggedSlotIndex != i) {
        final slotWidth = size.x / 3;
        final slotCenter = Vector2(slotWidth * i + slotWidth / 2, size.y / 2);
        final pieceWidth = piece.width * cellSize * GameConfig.trayPieceScale;
        final pieceHeight = piece.height * cellSize * GameConfig.trayPieceScale;

        final comp = PieceComponent(
          piece: piece,
          baseCellSize: cellSize,
          position: Vector2(slotCenter.x - pieceWidth / 2, slotCenter.y - pieceHeight / 2),
          renderScale: GameConfig.trayPieceScale,
        );
        slotComponents[i] = comp;
        add(comp);
      }
    }
  }

  int? getSlotAtPosition(Vector2 localPos) {
    if (localPos.y < 0 || localPos.y > size.y) return null;
    final slotWidth = size.x / 3;
    final index = (localPos.x / slotWidth).floor();
    if (index >= 0 && index < 3 && pieces[index] != null) {
      return index;
    }
    return null;
  }

  void hideSlot(int index) {
    draggedSlotIndex = index;
    slotComponents[index]?.opacity = 0.0;
  }

  void showSlot(int index) {
    if (draggedSlotIndex == index) {
      draggedSlotIndex = null;
    }
    slotComponents[index]?.opacity = 1.0;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final slotWidth = size.x / 3;
    for (int i = 0; i < 3; i++) {
      final slotRect = Rect.fromLTWH(
        i * slotWidth + 8,
        4,
        slotWidth - 16,
        size.y - 8,
      );
      final rrect = RRect.fromRectAndRadius(slotRect, const Radius.circular(12.0));
      final slotPaint = Paint()
        ..color = const Color(0xFF0D1730).withOpacity(0.4)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, slotPaint);
    }
  }
}
