import '../models/board_cell.dart';
import '../models/block.dart';
import '../models/block_piece.dart';
import '../config/game_config.dart';

class CompletedLines {
  final List<int> rows;
  final List<int> cols;

  const CompletedLines({required this.rows, required this.cols});

  int get totalLines => rows.length + cols.length;
  bool get hasClears => totalLines > 0;
}

class BoardSystem {
  static const int dim = GameConfig.boardDimension;
  late List<List<BoardCell>> grid;

  BoardSystem() {
    initGrid();
  }

  void initGrid() {
    grid = List.generate(
      dim,
      (r) => List.generate(
        dim,
        (c) => BoardCell(row: r, col: c),
      ),
    );
  }

  void reset() {
    for (int r = 0; r < dim; r++) {
      for (int c = 0; c < dim; c++) {
        grid[r][c].clear();
      }
    }
  }

  bool canPlacePiece(BlockPiece piece, int startRow, int startCol) {
    for (final coord in piece.coordinates) {
      final r = startRow + coord.y;
      final c = startCol + coord.x;
      if (r < 0 || r >= dim || c < 0 || c >= dim) {
        return false;
      }
      if (grid[r][c].isOccupied) {
        return false;
      }
    }
    return true;
  }

  bool canPieceFitAnywhere(BlockPiece piece) {
    for (int r = 0; r <= dim - piece.height; r++) {
      for (int c = 0; c <= dim - piece.width; c++) {
        if (canPlacePiece(piece, r, c)) {
          return true;
        }
      }
    }
    return false;
  }

  bool placePiece(BlockPiece piece, int startRow, int startCol) {
    if (!canPlacePiece(piece, startRow, startCol)) {
      return false;
    }
    for (final coord in piece.coordinates) {
      final r = startRow + coord.y;
      final c = startCol + coord.x;
      grid[r][c].block = Block(
        colorIndex: piece.colorIndex,
        theme: piece.theme,
      );
    }
    return true;
  }

  CompletedLines checkCompletedLines() {
    final completedRows = <int>[];
    final completedCols = <int>[];

    for (int r = 0; r < dim; r++) {
      bool full = true;
      for (int c = 0; c < dim; c++) {
        if (grid[r][c].isEmpty) {
          full = false;
          break;
        }
      }
      if (full) completedRows.add(r);
    }

    for (int c = 0; c < dim; c++) {
      bool full = true;
      for (int r = 0; r < dim; r++) {
        if (grid[r][c].isEmpty) {
          full = false;
          break;
        }
      }
      if (full) completedCols.add(c);
    }

    return CompletedLines(rows: completedRows, cols: completedCols);
  }

  void markLinesClearing(CompletedLines lines) {
    for (final r in lines.rows) {
      for (int c = 0; c < dim; c++) {
        grid[r][c].isClearing = true;
      }
    }
    for (final c in lines.cols) {
      for (int r = 0; r < dim; r++) {
        grid[r][c].isClearing = true;
      }
    }
  }

  void executeClear(CompletedLines lines) {
    for (final r in lines.rows) {
      for (int c = 0; c < dim; c++) {
        grid[r][c].clear();
      }
    }
    for (final c in lines.cols) {
      for (int r = 0; r < dim; r++) {
        grid[r][c].clear();
      }
    }
  }

  int get occupiedCellCount {
    int count = 0;
    for (int r = 0; r < dim; r++) {
      for (int c = 0; c < dim; c++) {
        if (grid[r][c].isOccupied) count++;
      }
    }
    return count;
  }
}
