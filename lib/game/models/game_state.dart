enum GameStatus {
  idle,
  playing,
  dragging,
  placing,
  clearing,
  combo,
  gameOver,
  paused,
}

class GameSessionState {
  int currentScore;
  int highScore;
  int linesCleared;
  int comboCount;
  int highestCombo;
  int movesCount;
  bool isNewHighScore;
  GameStatus status;

  GameSessionState({
    this.currentScore = 0,
    this.highScore = 0,
    this.linesCleared = 0,
    this.comboCount = 0,
    this.highestCombo = 0,
    this.movesCount = 0,
    this.isNewHighScore = false,
    this.status = GameStatus.playing,
  });

  void reset(int preservedHighScore) {
    currentScore = 0;
    highScore = preservedHighScore;
    linesCleared = 0;
    comboCount = 0;
    highestCombo = 0;
    movesCount = 0;
    isNewHighScore = false;
    status = GameStatus.playing;
  }
}
