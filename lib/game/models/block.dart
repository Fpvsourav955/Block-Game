import 'package:flutter/material.dart';
import '../config/color_config.dart';

class Block {
  final int colorIndex;
  final BlockColorTheme theme;

  const Block({
    required this.colorIndex,
    required this.theme,
  });

  factory Block.fromIndex(int index) {
    return Block(
      colorIndex: index,
      theme: ColorConfig.getThemeByIndex(index),
    );
  }
}
