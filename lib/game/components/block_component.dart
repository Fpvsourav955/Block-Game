import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../config/color_config.dart';

class BlockPainter {
  static void drawBlock({
    required Canvas canvas,
    required Rect rect,
    required BlockColorTheme theme,
    double radius = 4.0,
    double opacity = 1.0,
    bool isGhostPreview = false,
  }) {
    if (rect.width <= 0 || rect.height <= 0) return;

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    if (isGhostPreview) {
      final previewPaint = Paint()
        ..color = theme.base.withOpacity(0.45 * opacity)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, previewPaint);

      final previewBorder = Paint()
        ..color = theme.highlight.withOpacity(0.8 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawRRect(rrect, previewBorder);
      return;
    }

    final double bevel = (rect.width * 0.12).clamp(2.0, 5.0);

    final basePaint = Paint()
      ..shader = ui.Gradient.linear(
        rect.topLeft,
        rect.bottomRight,
        [
          theme.highlight.withOpacity(opacity),
          theme.base.withOpacity(opacity),
          theme.shadow.withOpacity(opacity),
        ],
        [0.0, 0.45, 1.0],
      )
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, basePaint);

    final topBevel = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right - bevel, rect.top + bevel)
      ..lineTo(rect.left + bevel, rect.top + bevel)
      ..close();
    final topHighlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.35 * opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(topBevel, topHighlightPaint);

    final leftBevel = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.left + bevel, rect.top + bevel)
      ..lineTo(rect.left + bevel, rect.bottom - bevel)
      ..lineTo(rect.left, rect.bottom)
      ..close();
    final leftHighlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.18 * opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(leftBevel, leftHighlightPaint);

    final bottomBevel = Path()
      ..moveTo(rect.left, rect.bottom)
      ..lineTo(rect.left + bevel, rect.bottom - bevel)
      ..lineTo(rect.right - bevel, rect.bottom - bevel)
      ..lineTo(rect.right, rect.bottom)
      ..close();
    final bottomShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.35 * opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bottomBevel, bottomShadowPaint);

    final rightBevel = Path()
      ..moveTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.right - bevel, rect.bottom - bevel)
      ..lineTo(rect.right - bevel, rect.top + bevel)
      ..close();
    final rightShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.20 * opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(rightBevel, rightShadowPaint);

    final innerRect = Rect.fromLTWH(
      rect.left + bevel,
      rect.top + bevel,
      rect.width - 2 * bevel,
      rect.height - 2 * bevel,
    );
    if (innerRect.width > 0 && innerRect.height > 0) {
      final innerRRect = RRect.fromRectAndRadius(innerRect, Radius.circular(radius * 0.6));
      final innerPaint = Paint()
        ..shader = ui.Gradient.linear(
          innerRect.topLeft,
          innerRect.bottomRight,
          [
            theme.highlight.withOpacity(0.3 * opacity),
            Colors.transparent,
          ],
        )
        ..style = PaintingStyle.fill;
      canvas.drawRRect(innerRRect, innerPaint);
    }

    final borderPaint = Paint()
      ..color = theme.shadow.withOpacity(0.4 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(rrect, borderPaint);
  }
}
