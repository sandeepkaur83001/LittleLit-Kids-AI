import 'dart:math' as math;
import 'package:flutter/material.dart';

class PlayfulCircleLoader extends StatefulWidget {
  final double size;
  final Color dotColor;
  final String? text;

  const PlayfulCircleLoader({
    super.key,
    this.size = 110.0,
    this.dotColor = const Color(0xFFFF9F1C), // Vibrant golden-orange
    this.text,
  });

  @override
  State<PlayfulCircleLoader> createState() => _PlayfulCircleLoaderState();
}

class _PlayfulCircleLoaderState extends State<PlayfulCircleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _PlayfulCircleLoaderPainter(
                  progress: _controller.value,
                  dotColor: widget.dotColor,
                ),
              );
            },
          ),
        ),
        if (widget.text != null && widget.text!.isNotEmpty) ...[
          const SizedBox(height: 14),
          Material(
            color: Colors.transparent,
            child: Text(
              widget.text!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PlayfulCircleLoaderPainter extends CustomPainter {
  final double progress;
  final Color dotColor;

  static const int numDots = 10;
  static const double baseRadius = 6.0;
  static const double maxRadius = 17.0;

  _PlayfulCircleLoaderPainter({
    required this.progress,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final circleRadius = (size.width / 2) - maxRadius - 4;

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final leadAngle = progress * 2 * math.pi;

    // Draw 10 Circular Dots with dynamic wave scaling
    for (int i = 0; i < numDots; i++) {
      final dotAngle = (i * 2 * math.pi / numDots) - (math.pi / 2);

      // Distance behind the lead angle (0 to 2*pi)
      double diff = (leadAngle - dotAngle) % (2 * math.pi);
      if (diff < 0) diff += 2 * math.pi;

      // Scale wave over 1.2 radians behind the lead
      double currentDotRadius = baseRadius;
      if (diff <= 1.3) {
        // Wave curve peaking near lead angle
        double wave = 1.0 - (diff / 1.3);
        currentDotRadius = baseRadius + (maxRadius - baseRadius) * math.pow(wave, 1.5);
      } else if (diff >= (2 * math.pi - 0.4)) {
        // Smooth transition at the wrap-around point
        double wave = (diff - (2 * math.pi - 0.4)) / 0.4;
        currentDotRadius = baseRadius + (maxRadius - baseRadius) * 0.15 * wave;
      }

      final x = center.dx + circleRadius * math.cos(dotAngle);
      final y = center.dy + circleRadius * math.sin(dotAngle);

      canvas.drawCircle(Offset(x, y), currentDotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlayfulCircleLoaderPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.dotColor != dotColor;
  }
}
