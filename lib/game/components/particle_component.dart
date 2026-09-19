import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum ParticleType { placementSpeck, lineSquare, comboStar, confetti }

class SimpleGameParticle {
  Vector2 position;
  Vector2 velocity;
  double size;
  Color color;
  double life;
  double maxLife;
  double rotation;
  double rotationSpeed;
  ParticleType type;

  SimpleGameParticle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.maxLife,
    required this.type,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
  }) : life = maxLife;

  bool update(double dt) {
    life -= dt;
    position += velocity * dt;
    velocity.y += 180 * dt;
    rotation += rotationSpeed * dt;
    return life > 0;
  }
}

class ParticleManagerComponent extends Component {
  final List<SimpleGameParticle> _particles = [];
  final Random _random = Random();

  void spawnPlacementParticles(Vector2 center, Color color) {
    for (int i = 0; i < 8; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 40.0 + _random.nextDouble() * 80.0;
      _particles.add(
        SimpleGameParticle(
          position: Vector2(center.x, center.y),
          velocity: Vector2(cos(angle) * speed, sin(angle) * speed - 20),
          size: 3.0 + _random.nextDouble() * 3.0,
          color: color,
          maxLife: 0.35 + _random.nextDouble() * 0.2,
          type: ParticleType.placementSpeck,
        ),
      );
    }
  }

  void spawnLineClearParticles(Rect cellRect, Color color) {
    for (int i = 0; i < 6; i++) {
      final offsetX = cellRect.left + _random.nextDouble() * cellRect.width;
      final offsetY = cellRect.top + _random.nextDouble() * cellRect.height;
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 60.0 + _random.nextDouble() * 120.0;

      _particles.add(
        SimpleGameParticle(
          position: Vector2(offsetX, offsetY),
          velocity: Vector2(cos(angle) * speed, sin(angle) * speed - 40),
          size: 5.0 + _random.nextDouble() * 6.0,
          color: color,
          maxLife: 0.45 + _random.nextDouble() * 0.3,
          type: ParticleType.lineSquare,
          rotation: _random.nextDouble() * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 8,
        ),
      );
    }
  }

  void spawnComboStars(Vector2 center, Color color) {
    for (int i = 0; i < 16; i++) {
      final angle = (i / 16.0) * 2 * pi + (_random.nextDouble() - 0.5) * 0.2;
      final speed = 100.0 + _random.nextDouble() * 140.0;
      _particles.add(
        SimpleGameParticle(
          position: Vector2(center.x, center.y),
          velocity: Vector2(cos(angle) * speed, sin(angle) * speed - 50),
          size: 6.0 + _random.nextDouble() * 6.0,
          color: color,
          maxLife: 0.6 + _random.nextDouble() * 0.3,
          type: ParticleType.comboStar,
          rotation: _random.nextDouble() * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 6,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _particles.removeWhere((p) => !p.update(dt));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (final p in _particles) {
      final progress = p.life / p.maxLife;
      final alpha = (progress * 255).clamp(0, 255).toInt();
      final particlePaint = Paint()
        ..color = p.color.withAlpha(alpha)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(p.position.x, p.position.y);
      canvas.rotate(p.rotation);

      if (p.type == ParticleType.lineSquare) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size),
          particlePaint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size / 2, particlePaint);
      }

      canvas.restore();
    }
  }
}
