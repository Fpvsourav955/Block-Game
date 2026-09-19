import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FloatingScoreComponent extends PositionComponent {
  final int points;
  double life = 0.8;
  final double maxLife = 0.8;
  late final TextPaint _textPaint;

  FloatingScoreComponent({
    required this.points,
    required Vector2 position,
  }) : super(position: position) {
    _textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: Color(0xFFFDE047),
        shadows: [
          Shadow(color: Colors.black54, offset: Offset(2, 2), blurRadius: 4),
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    life -= dt;
    position.y -= 40 * dt;
    if (life <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final alpha = (life / maxLife).clamp(0.0, 1.0);
    _textPaint.render(
      canvas,
      '+$points',
      Vector2.zero(),
      overridePaint: Paint()..color = const Color(0xFFFDE047).withOpacity(alpha),
    );
  }
}
