import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ComboBannerComponent extends PositionComponent {
  final String label;
  final int multiplier;
  double life = 1.0;
  final double maxLife = 1.0;
  late final TextPaint _textPaint;

  ComboBannerComponent({
    required this.label,
    required this.multiplier,
    required Vector2 position,
  }) : super(position: position) {
    _textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: Color(0xFF67E8F9),
        shadows: [
          Shadow(color: Color(0xFF0284C7), offset: Offset(0, 0), blurRadius: 12),
          Shadow(color: Colors.black87, offset: Offset(2, 3), blurRadius: 6),
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    life -= dt;
    position.y -= 25 * dt;
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
      label,
      Vector2.zero(),
      overridePaint: Paint()..color = const Color(0xFF67E8F9).withOpacity(alpha),
    );
  }
}
