import '../config/game_config.dart';

class ScoreResult {
  final int addedPoints;
  final int newTotalScore;
  final bool isNewHighScore;
  final int linesCleared;
  final int combo;

  const ScoreResult({
    required this.addedPoints,
    required this.newTotalScore,
    required this.isNewHighScore,
    required this.linesCleared,
    required this.combo,
  });
}

class ScoringSystem {
  int currentScore = 0;
  int highScore = 0;

  ScoringSystem({int initialHighScore = 0}) {
    highScore = initialHighScore;
  }

  void reset(int preservedHighScore) {
    currentScore = 0;
    highScore = preservedHighScore;
  }

  ScoreResult registerPlacement({
    required int blockCount,
    required int linesCleared,
    required int comboCount,
  }) {
    final points = GameConfig.calculatePlacementScore(
      blockCount: blockCount,
      linesCleared: linesCleared,
      comboCount: comboCount,
    );

    currentScore += points;
    bool isNewRecord = false;
    if (currentScore > highScore) {
      highScore = currentScore;
      isNewRecord = true;
    }

    return ScoreResult(
      addedPoints: points,
      newTotalScore: currentScore,
      isNewHighScore: isNewRecord,
      linesCleared: linesCleared,
      combo: comboCount,
    );
  }
}
