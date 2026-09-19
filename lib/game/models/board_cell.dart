import 'block.dart';

class BoardCell {
  final int row;
  final int col;
  Block? block;
  bool isClearing;
  bool isPreview;

  BoardCell({
    required this.row,
    required this.col,
    this.block,
    this.isClearing = false,
    this.isPreview = false,
  });

  bool get isEmpty => block == null;
  bool get isOccupied => block != null;

  void clear() {
    block = null;
    isClearing = false;
    isPreview = false;
  }
}
