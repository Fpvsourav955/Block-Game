import 'dart:math';
import '../models/block_piece.dart';
import '../config/color_config.dart';
import 'board_system.dart';

class PieceGenerator {
  final Random _random = Random();
  final List<BlockPiece> _templates = BlockPiece.getTemplates();

  List<BlockPiece> generateTray(BoardSystem boardSystem) {
    final List<BlockPiece> tray = [];
    final List<int> usedColors = [];

    final smallTemplates = _templates.where((p) => p.blockCount <= 3).toList();
    final mediumTemplates = _templates.where((p) => p.blockCount == 4).toList();
    final largeTemplates = _templates.where((p) => p.blockCount >= 5).toList();

    int nextColor() {
      final availableColors = List.generate(ColorConfig.allThemes.length, (i) => i)
        ..removeWhere((c) => usedColors.contains(c));
      final color = availableColors.isNotEmpty
          ? availableColors[_random.nextInt(availableColors.length)]
          : _random.nextInt(ColorConfig.allThemes.length);
      usedColors.add(color);
      return color;
    }

    BlockPiece pickAndColorize(List<BlockPiece> pool) {
      final base = pool[_random.nextInt(pool.length)];
      final color = nextColor();
      return BlockPiece(
        id: '${base.id}_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(1000)}',
        name: base.name,
        coordinates: base.coordinates,
        colorIndex: color,
        theme: ColorConfig.getThemeByIndex(color),
      );
    }

    final occupied = boardSystem.occupiedCellCount;

    if (occupied > 40) {
      tray.add(pickAndColorize(smallTemplates));
      tray.add(pickAndColorize(smallTemplates));
      tray.add(pickAndColorize(mediumTemplates));
    } else if (occupied > 24) {
      tray.add(pickAndColorize(smallTemplates));
      tray.add(pickAndColorize(mediumTemplates));
      tray.add(pickAndColorize(_templates));
    } else {
      tray.add(pickAndColorize(smallTemplates));
      tray.add(pickAndColorize(mediumTemplates));
      tray.add(pickAndColorize(largeTemplates));
    }

    bool atLeastOneFits = tray.any((piece) => boardSystem.canPieceFitAnywhere(piece));
    if (!atLeastOneFits) {
      final fittingSmall = smallTemplates.where((p) => boardSystem.canPieceFitAnywhere(p)).toList();
      if (fittingSmall.isNotEmpty) {
        final replacementBase = fittingSmall[_random.nextInt(fittingSmall.length)];
        final color = nextColor();
        tray[0] = BlockPiece(
          id: '${replacementBase.id}_fit_${DateTime.now().microsecondsSinceEpoch}',
          name: replacementBase.name,
          coordinates: replacementBase.coordinates,
          colorIndex: color,
          theme: ColorConfig.getThemeByIndex(color),
        );
      }
    }

    tray.shuffle(_random);
    return tray;
  }
}
