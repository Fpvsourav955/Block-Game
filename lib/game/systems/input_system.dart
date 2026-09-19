import 'package:flutter/material.dart';
import '../models/block_piece.dart';
import '../config/game_config.dart';

class DragState {
  final BlockPiece piece;
  final int trayIndex;
  Offset currentTouchPosition;
  Offset startTouchPosition;
  int? targetRow;
  int? targetCol;
  bool isValidTarget;

  DragState({
    required this.piece,
    required this.trayIndex,
    required this.currentTouchPosition,
    required this.startTouchPosition,
    this.targetRow,
    this.targetCol,
    this.isValidTarget = false,
  });

  Offset get displayPosition => Offset(
        currentTouchPosition.dx,
        currentTouchPosition.dy - GameConfig.dragVerticalFingerOffset,
      );
}
