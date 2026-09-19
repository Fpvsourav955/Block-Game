import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/vibration_service.dart';

class GameButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color primaryColor;
  final Color shadowColor;
  final double width;
  final double height;
  final double fontSize;

  const GameButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.primaryColor = const Color(0xFF22C55E),
    this.shadowColor = const Color(0xFF15803D),
    this.width = double.infinity,
    this.height = 54.0,
    this.fontSize = 20.0,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double verticalOffset = _isPressed ? 4.0 : 0.0;
    final double shadowHeight = _isPressed ? 0.0 : 4.0;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        AudioService.playButtonClick();
        VibrationService.light();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        width: widget.width,
        height: widget.height,
        margin: EdgeInsets.only(top: verticalOffset, bottom: 4.0 - verticalOffset),
        decoration: BoxDecoration(
          color: widget.primaryColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor,
              offset: Offset(0, shadowHeight),
              blurRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: Offset(0, shadowHeight + 2),
              blurRadius: 6,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.primaryColor.withOpacity(1.0),
              widget.shadowColor.withOpacity(0.9),
            ],
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: Colors.white, size: widget.fontSize * 1.1),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  shadows: const [
                    Shadow(
                      color: Colors.black38,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
