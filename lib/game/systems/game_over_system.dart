import '../models/block_piece.dart';
import 'board_system.dart';

class GameOverSystem {
  static bool checkGameOver({
    required List<BlockPiece?> trayPieces,
    required BoardSystem boardSystem,
  }) {
    final availablePieces = trayPieces.whereType<BlockPiece>().toList();
    if (availablePieces.isEmpty) {
      return false;
    }

    for (final piece in availablePieces) {
      if (boardSystem.canPieceFitAnywhere(piece)) {
        return false;
      }
    }
    return true;
  }
}
