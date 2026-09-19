import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'services/storage_service.dart';
import 'services/audio_service.dart';
import 'services/vibration_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F1E4A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await StorageService.init();
  final settings = await StorageService.loadSettings();

  await AudioService.init(
    sound: settings.soundEnabled,
    music: settings.musicEnabled,
  );
  VibrationService.init(enabled: settings.vibrationEnabled);

  runApp(const BlockSurgeApp());
}
