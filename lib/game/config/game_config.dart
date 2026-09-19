class GameConfig {
  static const int boardDimension = 8;
  static const int pointsPerBlock = 10;
  static const int pointsPerLine = 100;
  static const int multiLineBonusMultiplier = 50;
  static const int comboBaseBonus = 80;
  static const double dragVerticalFingerOffset = 80.0;
  static const double draggedPieceScale = 1.05;
  static const double trayPieceScale = 0.65;
  static const double boardCornerRadius = 16.0;
  static const double blockCornerRadius = 4.0;
  static const double cellSpacing = 3.0;

  static int calculatePlacementScore({
    required int blockCount,
    required int linesCleared,
    required int comboCount,
  }) {
    int score = blockCount * pointsPerBlock;
    if (linesCleared > 0) {
      score += linesCleared * pointsPerLine;
      if (linesCleared > 1) {
        score += (linesCleared - 1) * linesCleared * multiLineBonusMultiplier;
      }
      if (comboCount > 1) {
        score += (comboCount - 1) * comboBaseBonus;
      }
    }
    return score;
  }
}
