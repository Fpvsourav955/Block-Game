import 'package:flutter/material.dart';
import '../widgets/game_button.dart';
import '../services/vibration_service.dart';

class GameOverModal extends StatefulWidget {
  final int score;
  final int highScore;
  final int linesCleared;
  final int maxCombo;
  final bool isNewRecord;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  const GameOverModal({
    super.key,
    required this.score,
    required this.highScore,
    required this.linesCleared,
    required this.maxCombo,
    required this.isNewRecord,
    required this.onPlayAgain,
    required this.onHome,
  });

  @override
  State<GameOverModal> createState() => _GameOverModalState();
}

class _GameOverModalState extends State<GameOverModal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<int> _scoreCountAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _scoreCountAnimation = IntTween(
      begin: 0,
      end: widget.score,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.9, curve: Curves.easeOutCubic),
    ));

    _controller.forward();

    if (widget.isNewRecord) {
      VibrationService.recordCelebration();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: widget.isNewRecord ? const Color(0xFFFACC15) : const Color(0xFF38BDF8),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (widget.isNewRecord ? const Color(0xFFFACC15) : const Color(0xFF38BDF8))
                    .withOpacity(0.25),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isNewRecord) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.star_rounded, color: Color(0xFFFACC15), size: 28),
                    SizedBox(width: 6),
                    Text(
                      'NEW RECORD!',
                      style: TextStyle(
                        color: Color(0xFFFACC15),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.star_rounded, color: Color(0xFFFACC15), size: 28),
                  ],
                ),
                const SizedBox(height: 12),
              ] else ...[
                const Text(
                  'GAME OVER',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              AnimatedBuilder(
                animation: _scoreCountAnimation,
                builder: (context, _) {
                  return Text(
                    '${_scoreCountAnimation.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 54,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  );
                },
              ),
              const Text(
                'FINAL SCORE',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('BEST', '${widget.highScore}', Icons.emoji_events, const Color(0xFFFACC15)),
                    _buildDivider(),
                    _buildStatItem('LINES', '${widget.linesCleared}', Icons.grid_view, const Color(0xFF38BDF8)),
                    _buildDivider(),
                    _buildStatItem('COMBO', 'x${widget.maxCombo}', Icons.bolt, const Color(0xFFA855F7)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GameButton(
                text: 'PLAY AGAIN',
                icon: Icons.replay_rounded,
                height: 54,
                fontSize: 18,
                primaryColor: const Color(0xFF22C55E),
                shadowColor: const Color(0xFF15803D),
                onPressed: widget.onPlayAgain,
              ),
              const SizedBox(height: 12),
              GameButton(
                text: 'HOME',
                icon: Icons.home_rounded,
                height: 48,
                fontSize: 16,
                primaryColor: const Color(0xFF3B82F6),
                shadowColor: const Color(0xFF1D4ED8),
                onPressed: widget.onHome,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: const Color(0xFF334155),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
