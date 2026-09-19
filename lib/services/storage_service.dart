import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class GameSettings {
  final bool soundEnabled;
  final bool musicEnabled;
  final bool vibrationEnabled;

  const GameSettings({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.vibrationEnabled = true,
  });

  GameSettings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? vibrationEnabled,
  }) {
    return GameSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}

class GameStatistics {
  final int totalGamesPlayed;
  final int totalLinesCleared;
  final int highestCombo;

  const GameStatistics({
    this.totalGamesPlayed = 0,
    this.totalLinesCleared = 0,
    this.highestCombo = 0,
  });
}

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveHighScore(int score) async {
    await init();
    await _prefs?.setInt(AppConstants.keyHighScore, score);
  }

  static Future<int> loadHighScore() async {
    await init();
    return _prefs?.getInt(AppConstants.keyHighScore) ?? 0;
  }

  static Future<void> saveSettings(GameSettings settings) async {
    await init();
    await _prefs?.setBool(AppConstants.keySoundEnabled, settings.soundEnabled);
    await _prefs?.setBool(AppConstants.keyMusicEnabled, settings.musicEnabled);
    await _prefs?.setBool(AppConstants.keyVibrationEnabled, settings.vibrationEnabled);
  }

  static Future<GameSettings> loadSettings() async {
    await init();
    return GameSettings(
      soundEnabled: _prefs?.getBool(AppConstants.keySoundEnabled) ?? true,
      musicEnabled: _prefs?.getBool(AppConstants.keyMusicEnabled) ?? true,
      vibrationEnabled: _prefs?.getBool(AppConstants.keyVibrationEnabled) ?? true,
    );
  }

  static Future<void> recordGameSession({
    required int linesCleared,
    required int combo,
  }) async {
    await init();
    final played = (_prefs?.getInt(AppConstants.keyTotalGamesPlayed) ?? 0) + 1;
    final lines = (_prefs?.getInt(AppConstants.keyTotalLinesCleared) ?? 0) + linesCleared;
    final currentMaxCombo = _prefs?.getInt(AppConstants.keyHighestCombo) ?? 0;
    final newMaxCombo = combo > currentMaxCombo ? combo : currentMaxCombo;

    await _prefs?.setInt(AppConstants.keyTotalGamesPlayed, played);
    await _prefs?.setInt(AppConstants.keyTotalLinesCleared, lines);
    await _prefs?.setInt(AppConstants.keyHighestCombo, newMaxCombo);
  }

  static Future<GameStatistics> loadStatistics() async {
    await init();
    return GameStatistics(
      totalGamesPlayed: _prefs?.getInt(AppConstants.keyTotalGamesPlayed) ?? 0,
      totalLinesCleared: _prefs?.getInt(AppConstants.keyTotalLinesCleared) ?? 0,
      highestCombo: _prefs?.getInt(AppConstants.keyHighestCombo) ?? 0,
    );
  }

  static Future<void> resetAllData() async {
    await init();
    await _prefs?.clear();
  }
}
