import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';
import '../services/vibration_service.dart';
import '../widgets/game_button.dart';
import '../widgets/animated_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final score = await StorageService.loadHighScore();
    setState(() => _highScore = score);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1E4A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.2,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF0F1E4A),
              Color(0xFF070E24),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white70, size: 28),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings').then((_) => _loadData());
                    },
                  ),
                ),
                const Spacer(flex: 2),
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFF38BDF8), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF38BDF8).withOpacity(0.3),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLogoBlock(const Color(0xFF38BDF8)),
                            const SizedBox(width: 6),
                            _buildLogoBlock(const Color(0xFFEAB308)),
                            const SizedBox(width: 6),
                            _buildLogoBlock(const Color(0xFF22C55E)),
                            const SizedBox(width: 6),
                            _buildLogoBlock(const Color(0xFFDC2626)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const PulsingText(
                        text: 'BLOCK SURGE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(color: Color(0xFF38BDF8), blurRadius: 16),
                            Shadow(color: Colors.black87, offset: Offset(2, 4), blurRadius: 6),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '8x8 Color Puzzle Challenge',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events, color: Color(0xFFFACC15), size: 28),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BEST SCORE',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            '$_highScore',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                GameButton(
                  text: 'PLAY GAME',
                  icon: Icons.play_arrow_rounded,
                  height: 60,
                  fontSize: 22,
                  primaryColor: const Color(0xFF22C55E),
                  shadowColor: const Color(0xFF15803D),
                  onPressed: () {
                    Navigator.pushNamed(context, '/game').then((_) => _loadData());
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: GameButton(
                        text: 'DAILY',
                        icon: Icons.calendar_today_rounded,
                        height: 48,
                        fontSize: 15,
                        primaryColor: const Color(0xFF3B82F6),
                        shadowColor: const Color(0xFF1D4ED8),
                        onPressed: () {
                          AudioService.playButtonClick();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Daily challenge unlocked! Classic mode recommended first.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GameButton(
                        text: 'STATS',
                        icon: Icons.bar_chart_rounded,
                        height: 48,
                        fontSize: 15,
                        primaryColor: const Color(0xFF8B5CF6),
                        shadowColor: const Color(0xFF6D28D9),
                        onPressed: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoBlock(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: const Offset(1, 2),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}
