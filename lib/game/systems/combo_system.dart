class ComboStatus {
  final int comboMultiplier;
  final String label;
  final bool isConsecutive;

  const ComboStatus({
    required this.comboMultiplier,
    required this.label,
    required this.isConsecutive,
  });
}

class ComboSystem {
  int currentCombo = 0;
  int maxComboAchieved = 0;

  void reset() {
    currentCombo = 0;
    maxComboAchieved = 0;
  }

  ComboStatus onMoveCompleted({required int linesCleared}) {
    if (linesCleared > 0) {
      currentCombo++;
      if (currentCombo > maxComboAchieved) {
        maxComboAchieved = currentCombo;
      }

      String label = '';
      if (linesCleared == 1) {
        label = currentCombo > 1 ? 'COMBO x$currentCombo' : 'CLEAR';
      } else if (linesCleared == 2) {
        label = currentCombo > 1 ? 'DOUBLE CLEAR x$currentCombo' : 'DOUBLE CLEAR';
      } else if (linesCleared == 3) {
        label = currentCombo > 1 ? 'TRIPLE CLEAR x$currentCombo' : 'TRIPLE CLEAR';
      } else {
        label = currentCombo > 1 ? 'MEGA CLEAR x$currentCombo' : 'MEGA CLEAR';
      }

      return ComboStatus(
        comboMultiplier: currentCombo,
        label: label,
        isConsecutive: currentCombo > 1,
      );
    } else {
      currentCombo = 0;
      return const ComboStatus(
        comboMultiplier: 0,
        label: '',
        isConsecutive: false,
      );
    }
  }
}
