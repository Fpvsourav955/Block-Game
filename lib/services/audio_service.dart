import 'package:flame_audio/flame_audio.dart';

class AudioService {
  static bool soundEnabled = true;
  static bool musicEnabled = true;
  static bool _initialized = false;

  static Future<void> init({bool sound = true, bool music = true}) async {
    soundEnabled = sound;
    musicEnabled = music;
    if (_initialized) return;

    try {
      _initialized = true;
    } catch (_) {
      // Audio system failsafe
    }
  }

  static void playPickup() {
    if (!soundEnabled) return;
    _playSfx('pickup.mp3');
  }

  static void playPlace() {
    if (!soundEnabled) return;
    _playSfx('place.mp3');
  }

  static void playClear() {
    if (!soundEnabled) return;
    _playSfx('clear.mp3');
  }

  static void playCombo() {
    if (!soundEnabled) return;
    _playSfx('combo.mp3');
  }

  static void playCancel() {
    if (!soundEnabled) return;
    _playSfx('cancel.mp3');
  }

  static void playRecord() {
    if (!soundEnabled) return;
    _playSfx('record.mp3');
  }

  static void playGameOver() {
    if (!soundEnabled) return;
    _playSfx('gameover.mp3');
  }

  static void playButtonClick() {
    if (!soundEnabled) return;
    _playSfx('click.mp3');
  }

  static void _playSfx(String fileName) {
    try {
      FlameAudio.play(fileName, volume: 0.8);
    } catch (_) {
      // Asset optional fallback
    }
  }

  static void setSoundEnabled(bool value) {
    soundEnabled = value;
  }

  static void setMusicEnabled(bool value) {
    musicEnabled = value;
    if (!musicEnabled) {
      FlameAudio.bgm.stop();
    }
  }
}
