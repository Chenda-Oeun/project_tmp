import 'package:flutter/material.dart';

enum SocialType { google, apple }

class SocialLoginButton extends StatefulWidget {
  final SocialType type;
  final VoidCallback? onPressed;

  const SocialLoginButton({
    super.key,
    required this.type,
    this.onPressed,
  });

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final label = widget.type == SocialType.google ? 'Google' : 'Apple';

    final bgColor = isDark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
        : Colors.white;

    final borderColor = isDark
        ? theme.colorScheme.outline.withValues(alpha: 0.2)
        : Colors.grey.shade200;

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(widget.type, isDark),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(SocialType type, bool isDark) {
    if (type == SocialType.google) {
      return CustomPaint(
        size: const Size(20, 20),
        painter: _GoogleIconPainter(),
      );
    } else {
      return Icon(
        Icons.apple,
        size: 22,
        color: isDark ? Colors.white : Colors.black,
      );
    }
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Google 'G' official colors painter
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);

    final rect = Rect.fromLTWH(0, 0, w, h);

    // Blue arc & bar
    final bluePath = Path()
      ..moveTo(w * 0.95, h * 0.5)
      ..arcTo(rect, 0, 0.8, false)
      ..lineTo(w * 0.5, h * 0.5)
      ..close();
    canvas.drawPath(bluePath, bluePaint);

    // Red top arc
    final redPath = Path()
      ..moveTo(w * 0.5, h * 0.5)
      ..arcTo(rect, -2.35, 1.55, false)
      ..close();
    canvas.drawPath(redPath, redPaint);

    // Yellow left arc
    final yellowPath = Path()
      ..moveTo(w * 0.5, h * 0.5)
      ..arcTo(rect, -3.9, 1.55, false)
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Green bottom arc
    final greenPath = Path()
      ..moveTo(w * 0.5, h * 0.5)
      ..arcTo(rect, -0.8, 1.55, false)
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // White center circle cutout
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.32, whitePaint);

    // Blue right bar
    final barRect = Rect.fromLTWH(w * 0.45, h * 0.38, w * 0.5, h * 0.24);
    canvas.drawRect(barRect, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
