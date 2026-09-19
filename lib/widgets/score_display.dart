import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final int currentScore;
  final int highScore;
  final VoidCallback onSettingsPressed;

  const ScoreDisplay({
    super.key,
    required this.currentScore,
    required this.highScore,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAB308).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFFACC15),
                  size: 26,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$highScore',
                style: const TextStyle(
                  color: Color(0xFFFDE047),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 2),
                  ],
                ),
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '$currentScore',
              key: ValueKey<int>(currentScore),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                shadows: [
                  Shadow(color: Colors.black45, offset: Offset(2, 3), blurRadius: 4),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onSettingsPressed,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155), width: 1.5),
              ),
              child: const Icon(
                Icons.settings,
                color: Color(0xFF94A3B8),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
