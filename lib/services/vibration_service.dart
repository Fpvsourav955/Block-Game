import 'package:flutter/services.dart';

class VibrationService {
  static bool vibrationEnabled = true;

  static void init({bool enabled = true}) {
    vibrationEnabled = enabled;
  }

  static void light() {
    if (!vibrationEnabled) return;
    HapticFeedback.lightImpact();
  }

  static void medium() {
    if (!vibrationEnabled) return;
    HapticFeedback.mediumImpact();
  }

  static void heavy() {
    if (!vibrationEnabled) return;
    HapticFeedback.heavyImpact();
  }

  static void recordCelebration() {
    if (!vibrationEnabled) return;
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 150), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      HapticFeedback.heavyImpact();
    });
  }

  static void setVibrationEnabled(bool value) {
    vibrationEnabled = value;
  }
}
