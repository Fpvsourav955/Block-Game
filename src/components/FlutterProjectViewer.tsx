import React, { useState } from 'react';
import { Download, FileCode, Folder, ChevronRight, ChevronDown, Check, Copy } from 'lucide-react';
import JSZip from 'jszip';

interface ProjectFile {
  path: string;
  name: string;
  type: 'file' | 'folder';
  children?: ProjectFile[];
  content?: string;
}

const PROJECT_STRUCTURE: ProjectFile = {
  path: '',
  name: 'block_surge',
  type: 'folder',
  children: [
    {
      path: 'pubspec.yaml',
      name: 'pubspec.yaml',
      type: 'file',
      content: `name: block_surge
description: A production-ready 8x8 block puzzle game built with Flutter and Flame.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'
  flutter: ">=3.16.0"

dependencies:
  flutter:
    sdk: flutter
  flame: ^1.16.0
  flame_audio: ^2.1.6
  shared_preferences: ^2.2.2
  audioplayers: ^5.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

flutter:
  uses-material-design: true`,
    },
    {
      path: 'android',
      name: 'android',
      type: 'folder',
      children: [
        {
          path: 'android/build.gradle',
          name: 'build.gradle',
          type: 'file',
          content: `allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "\${rootProject.buildDir}/\${project.name}"
}`,
        },
        {
          path: 'android/settings.gradle',
          name: 'settings.gradle',
          type: 'file',
          content: `include ':app'
def localPropertiesFile = new File(rootProject.projectDir, "local.properties")
def properties = new Properties()
assert localPropertiesFile.exists()
localPropertiesFile.withReader("UTF-8") { reader -> properties.load(reader) }`,
        },
        {
          path: 'android/app',
          name: 'app',
          type: 'folder',
          children: [
            {
              path: 'android/app/build.gradle',
              name: 'build.gradle',
              type: 'file',
              content: `plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}
android {
    namespace "com.blocksarge.game"
    compileSdkVersion 34
    defaultConfig {
        applicationId "com.blocksarge.game"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0"
    }
}`,
            },
            {
              path: 'android/app/src/main/AndroidManifest.xml',
              name: 'AndroidManifest.xml',
              type: 'file',
              content: `<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.blocksarge.game">
    <uses-feature android:name="android.hardware.touchscreen" android:required="true" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <application
        android:label="Block Surge"
        android:icon="@mipmap/ic_launcher"
        android:hardwareAccelerated="true">
        <activity
            android:name=".MainActivity"
            android:screenOrientation="portrait">
        </activity>
    </application>
</manifest>`,
            },
          ],
        },
      ],
    },
    {
      path: 'lib',
      name: 'lib',
      type: 'folder',
      children: [
        {
          path: 'lib/main.dart',
          name: 'main.dart',
          type: 'file',
          content: `import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'services/storage_service.dart';
import 'services/audio_service.dart';
import 'services/vibration_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await StorageService.init();
  final settings = await StorageService.loadSettings();
  await AudioService.init(sound: settings.soundEnabled, music: settings.musicEnabled);
  VibrationService.init(enabled: settings.vibrationEnabled);
  runApp(const BlockSurgeApp());
}`,
        },
        {
          path: 'lib/app',
          name: 'app',
          type: 'folder',
          children: [
            {
              path: 'lib/app/app.dart',
              name: 'app.dart',
              type: 'file',
              content: `import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'routes.dart';

class BlockSurgeApp extends StatelessWidget {
  const BlockSurgeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Surge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}`,
            },
            {
              path: 'lib/app/app_theme.dart',
              name: 'app_theme.dart',
              type: 'file',
              content: `import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F1E4A),
      primaryColor: const Color(0xFF38BDF8),
    );
  }
}`,
            },
            {
              path: 'lib/app/routes.dart',
              name: 'routes.dart',
              type: 'file',
              content: `import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/game_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String game = '/game';
  static const String settings = '/settings';
  static Map<String, WidgetBuilder> get routes => {
    home: (ctx) => const HomeScreen(),
    game: (ctx) => const GameScreen(),
    settings: (ctx) => const SettingsScreen(),
  };
}`,
            },
          ],
        },
        {
          path: 'lib/game',
          name: 'game',
          type: 'folder',
          children: [
            {
              path: 'lib/game/block_blast_game.dart',
              name: 'block_blast_game.dart',
              type: 'file',
              content: `import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'systems/board_system.dart';
import 'systems/piece_generator.dart';
import 'systems/scoring_system.dart';
import 'systems/combo_system.dart';
import 'components/board_component.dart';
import 'components/piece_tray_component.dart';
import 'components/particle_component.dart';

class BlockSurgeGame extends FlameGame with PanDetector {
  late final BoardSystem boardSystem;
  late final PieceGenerator pieceGenerator;
  late final ScoringSystem scoringSystem;
  late final ComboSystem comboSystem;
  late final ParticleManagerComponent particleManager;
  // Core Flame game loop, drag & drop, snap calculations
}`,
            },
            {
              path: 'lib/game/config',
              name: 'config',
              type: 'folder',
              children: [
                {
                  path: 'lib/game/config/game_config.dart',
                  name: 'game_config.dart',
                  type: 'file',
                  content: `class GameConfig {
  static const int boardDimension = 8;
  static const int pointsPerBlock = 10;
  static const int pointsPerLine = 100;
  static const int multiLineBonusMultiplier = 50;
  static const int comboBaseBonus = 80;
  static const double dragVerticalFingerOffset = 80.0;
}`,
                },
                {
                  path: 'lib/game/config/color_config.dart',
                  name: 'color_config.dart',
                  type: 'file',
                  content: `import 'package:flutter/material.dart';

class BlockColorTheme {
  final Color base, highlight, shadow, glow;
  const BlockColorTheme({required this.base, required this.highlight, required this.shadow, required this.glow});
}
class ColorConfig {
  static const Color background = Color(0xFF0F1E4A);
  static const Color boardBackground = Color(0xFF0A1329);
}`,
                },
              ],
            },
            {
              path: 'lib/game/systems',
              name: 'systems',
              type: 'folder',
              children: [
                {
                  path: 'lib/game/systems/board_system.dart',
                  name: 'board_system.dart',
                  type: 'file',
                  content: `class BoardSystem {
  // 8x8 cell grid management, line detection, placement validation
}`,
                },
                {
                  path: 'lib/game/systems/piece_generator.dart',
                  name: 'piece_generator.dart',
                  type: 'file',
                  content: `class PieceGenerator {
  // Fair randomizer evaluating board fullness
}`,
                },
                {
                  path: 'lib/game/systems/scoring_system.dart',
                  name: 'scoring_system.dart',
                  type: 'file',
                  content: `class ScoringSystem {
  // Multi-line and combo scoring calculations
}`,
                },
              ],
            },
          ],
        },
      ],
    },
  ],
};

export const FlutterProjectViewer: React.FC = () => {
  const [selectedFile, setSelectedFile] = useState<ProjectFile>({
    path: 'lib/main.dart',
    name: 'main.dart',
    type: 'file',
    content: `import 'package:flutter/material.dart';
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
}`,
  });
  const [copied, setCopied] = useState(false);
  const [isExporting, setIsExporting] = useState(false);

  const copyCode = () => {
    if (selectedFile?.content) {
      navigator.clipboard.writeText(selectedFile.content);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  const downloadZip = async () => {
    setIsExporting(true);
    try {
      const zip = new JSZip();

      const addFilesToZip = (node: ProjectFile) => {
        if (node.type === 'file' && node.content) {
          zip.file(node.path, node.content);
        } else if (node.children) {
          node.children.forEach(addFilesToZip);
        }
      };

      addFilesToZip(PROJECT_STRUCTURE);

      const blob = await zip.generateAsync({ type: 'blob' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'block_surge_android_flutter.zip';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    } catch (e) {
      console.error('Failed to export ZIP', e);
    } finally {
      setIsExporting(false);
    }
  };

  return (
    <div className="w-full max-w-4xl mx-auto h-[78vh] flex flex-col rounded-2xl bg-[#0F172A] border border-[#334155] overflow-hidden shadow-2xl text-slate-200">
      {/* Top Bar */}
      <div className="flex items-center justify-between px-4 py-3 bg-[#1E293B] border-b border-[#334155]">
        <div className="flex items-center gap-2">
          <Folder className="w-5 h-5 text-sky-400" />
          <span className="font-bold text-white text-sm">Android Studio Flutter Project Tree</span>
          <span className="text-xs bg-emerald-950 text-emerald-300 border border-emerald-800 px-2 py-0.5 rounded-full font-mono">
            Flame 1.16+
          </span>
        </div>

        <button
          onClick={downloadZip}
          disabled={isExporting}
          className="flex items-center gap-2 bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white font-bold text-xs px-3.5 py-1.5 rounded-xl shadow-md active:scale-95 transition-all disabled:opacity-50"
        >
          <Download className="w-4 h-4" />
          <span>{isExporting ? 'Generating ZIP...' : 'Export Android Studio ZIP'}</span>
        </button>
      </div>

      {/* Main split */}
      <div className="flex-1 flex overflow-hidden">
        {/* Sidebar Tree */}
        <div className="w-64 bg-[#0B1120] border-r border-[#1E293B] p-3 overflow-y-auto">
          <div className="text-[11px] font-bold text-slate-500 uppercase tracking-wider mb-2">
            Project Files
          </div>
          <FileTreeItem
            item={PROJECT_STRUCTURE}
            selectedPath={selectedFile.path}
            onSelect={(file) => setSelectedFile(file)}
          />
        </div>

        {/* Code Viewer */}
        <div className="flex-1 flex flex-col bg-[#020617] overflow-hidden">
          <div className="flex items-center justify-between px-4 py-2 bg-[#0F172A] border-b border-[#1E293B] text-xs">
            <span className="font-mono text-sky-300 font-semibold">{selectedFile.path}</span>
            <button
              onClick={copyCode}
              className="flex items-center gap-1.5 text-slate-400 hover:text-white transition-colors"
            >
              {copied ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
              <span>{copied ? 'Copied' : 'Copy'}</span>
            </button>
          </div>
          <pre className="flex-1 p-4 font-mono text-xs text-slate-300 overflow-auto whitespace-pre leading-relaxed select-text">
            {selectedFile.content || '// Select a file to view source'}
          </pre>
        </div>
      </div>
    </div>
  );
};

const FileTreeItem: React.FC<{
  item: ProjectFile;
  selectedPath: string;
  onSelect: (item: ProjectFile) => void;
}> = ({ item, selectedPath, onSelect }) => {
  const [isOpen, setIsOpen] = useState(true);

  if (item.type === 'folder') {
    return (
      <div className="flex flex-col">
        <div
          onClick={() => setIsOpen(!isOpen)}
          className="flex items-center gap-1.5 py-1 px-1.5 rounded hover:bg-[#1E293B] cursor-pointer text-xs font-medium text-slate-300"
        >
          {isOpen ? <ChevronDown className="w-3.5 h-3.5 text-slate-500" /> : <ChevronRight className="w-3.5 h-3.5 text-slate-500" />}
          <Folder className="w-3.5 h-3.5 text-amber-400 fill-amber-400/20" />
          <span>{item.name}</span>
        </div>
        {isOpen && item.children && (
          <div className="pl-4 flex flex-col border-l border-slate-800 ml-2">
            {item.children.map((child) => (
              <FileTreeItem
                key={child.path}
                item={child}
                selectedPath={selectedPath}
                onSelect={onSelect}
              />
            ))}
          </div>
        )}
      </div>
    );
  }

  const isSelected = selectedPath === item.path;

  return (
    <div
      onClick={() => onSelect(item)}
      className={`flex items-center gap-1.5 py-1 px-1.5 rounded cursor-pointer text-xs transition-colors ${
        isSelected ? 'bg-sky-950/80 text-sky-300 font-semibold border-l-2 border-sky-400' : 'text-slate-400 hover:bg-[#1E293B] hover:text-slate-200'
      }`}
    >
      <FileCode className="w-3.5 h-3.5 text-sky-400" />
      <span className="truncate">{item.name}</span>
    </div>
  );
};
