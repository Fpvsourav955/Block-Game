import 'package:flutter/material.dart';

class BlockColorTheme {
  final Color base;
  final Color highlight;
  final Color shadow;
  final Color glow;

  const BlockColorTheme({
    required this.base,
    required this.highlight,
    required this.shadow,
    required this.glow,
  });
}

class ColorConfig {
  static const Color background = Color(0xFF0F1E4A);
  static const Color backgroundRadialCenter = Color(0xFF1E3A8A);
  static const Color boardBackground = Color(0xFF0A1329);
  static const Color cellEmpty = Color(0xFF111E3D);
  static const Color cellEmptyBorder = Color(0xFF172952);
  static const Color gridLine = Color(0xFF16254A);
  static const Color previewValid = Color(0x7738BDF8);
  static const Color previewInvalid = Color(0x66EF4444);

  static const BlockColorTheme blue = BlockColorTheme(
    base: Color(0xFF2563EB),
    highlight: Color(0xFF60A5FA),
    shadow: Color(0xFF1D4ED8),
    glow: Color(0xFF93C5FD),
  );

  static const BlockColorTheme cyan = BlockColorTheme(
    base: Color(0xFF06B6D4),
    highlight: Color(0xFF67E8F9),
    shadow: Color(0xFF0891B2),
    glow: Color(0xFFA5F3FC),
  );

  static const BlockColorTheme green = BlockColorTheme(
    base: Color(0xFF16A34A),
    highlight: Color(0xFF4ADE80),
    shadow: Color(0xFF15803D),
    glow: Color(0xFF86EFAC),
  );

  static const BlockColorTheme yellow = BlockColorTheme(
    base: Color(0xFFEAB308),
    highlight: Color(0xFFFDE047),
    shadow: Color(0xFFCA8A04),
    glow: Color(0xFFFEF08A),
  );

  static const BlockColorTheme orange = BlockColorTheme(
    base: Color(0xFFEA580C),
    highlight: Color(0xFFFB923C),
    shadow: Color(0xFFC2410C),
    glow: Color(0xFFFDBA74),
  );

  static const BlockColorTheme red = BlockColorTheme(
    base: Color(0xFFDC2626),
    highlight: Color(0xFFF87171),
    shadow: Color(0xFFB91C1C),
    glow: Color(0xFFFCA5A5),
  );

  static const BlockColorTheme pink = BlockColorTheme(
    base: Color(0xFFDB2777),
    highlight: Color(0xFFF472B6),
    shadow: Color(0xFFBE185D),
    glow: Color(0xFFFBCFE8),
  );

  static const BlockColorTheme purple = BlockColorTheme(
    base: Color(0xFF9333EA),
    highlight: Color(0xFFC084FC),
    shadow: Color(0xFF7E22CE),
    glow: Color(0xFFE9D5FF),
  );

  static const List<BlockColorTheme> allThemes = [
    blue,
    cyan,
    green,
    yellow,
    orange,
    red,
    pink,
    purple,
  ];

  static BlockColorTheme getThemeByIndex(int index) {
    return allThemes[index % allThemes.length];
  }
}
