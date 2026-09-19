import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';
import '../services/vibration_service.dart';
import '../widgets/settings_tile.dart';
import '../widgets/game_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  GameSettings _settings = const GameSettings();
  GameStatistics _stats = const GameStatistics();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await StorageService.loadSettings();
    final stats = await StorageService.loadStatistics();
    setState(() {
      _settings = settings;
      _stats = stats;
      _isLoading = false;
    });
  }

  void _updateSettings(GameSettings newSettings) {
    setState(() => _settings = newSettings);
    StorageService.saveSettings(newSettings);
    AudioService.setSoundEnabled(newSettings.soundEnabled);
    AudioService.setMusicEnabled(newSettings.musicEnabled);
    VibrationService.setVibrationEnabled(newSettings.vibrationEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1E4A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)))
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  const Text(
                    'AUDIO & FEEDBACK',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SettingsTile(
                    title: 'Sound Effects',
                    subtitle: 'Placement, line clears, and combo sounds',
                    icon: Icons.volume_up_rounded,
                    value: _settings.soundEnabled,
                    onChanged: (val) {
                      _updateSettings(_settings.copyWith(soundEnabled: val));
                    },
                  ),
                  SettingsTile(
                    title: 'Background Music',
                    subtitle: 'Ambient soundtrack and theme loops',
                    icon: Icons.music_note_rounded,
                    value: _settings.musicEnabled,
                    onChanged: (val) {
                      _updateSettings(_settings.copyWith(musicEnabled: val));
                    },
                  ),
                  SettingsTile(
                    title: 'Haptic Feedback',
                    subtitle: 'Vibrations for block placement & line clears',
                    icon: Icons.vibration_rounded,
                    value: _settings.vibrationEnabled,
                    onChanged: (val) {
                      _updateSettings(_settings.copyWith(vibrationEnabled: val));
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'CAREER STATISTICS',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      children: [
                        _buildStatRow('Total Games Played', '${_stats.totalGamesPlayed}'),
                        const Divider(color: Color(0xFF334155), height: 20),
                        _buildStatRow('Total Lines Cleared', '${_stats.totalLinesCleared}'),
                        const Divider(color: Color(0xFF334155), height: 20),
                        _buildStatRow('Highest Combo Ever', 'x${_stats.highestCombo}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'DATA MANAGEMENT',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GameButton(
                    text: 'RESET ALL SAVED DATA',
                    icon: Icons.delete_outline_rounded,
                    height: 50,
                    fontSize: 15,
                    primaryColor: const Color(0xFFDC2626),
                    shadowColor: const Color(0xFF991B1B),
                    onPressed: () {
                      _confirmReset(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Block Surge v1.0.0 (Production Build)\nFlame Game Engine & Flutter',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Reset All Data?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'This will permanently reset your high score, statistics, and game settings back to defaults.',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await StorageService.resetAllData();
              _loadSettings();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All game data has been reset.')),
                );
              }
            },
            child: const Text('RESET', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
