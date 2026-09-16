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

  // Tiny sparkle confetti offsets and colors around the lead dot
  static final List<_SparkleSpec> sparkles = [
    _SparkleSpec(angleOffset: -0.45, distOffset: 24.0, radius: 2.5, color: const Color(0xFF4ADE80)), // Green
    _SparkleSpec(angleOffset: -0.25, distOffset: 27.0, radius: 3.0, color: const Color(0xFF38BDF8)), // Blue
    _SparkleSpec(angleOffset: 0.0, distOffset: 29.0, radius: 3.2, color: const Color(0xFFFACC15)),  // Yellow
    _SparkleSpec(angleOffset: 0.28, distOffset: 26.0, radius: 2.8, color: const Color(0xFF22C55E)), // Green
    _SparkleSpec(angleOffset: 0.48, distOffset: 23.0, radius: 2.2, color: const Color(0xFF60A5FA)), // Blue
    _SparkleSpec(angleOffset: -0.15, distOffset: -22.0, radius: 2.0, color: const Color(0xFFFB923C)),// Orange
    _SparkleSpec(angleOffset: 0.20, distOffset: -24.0, radius: 2.2, color: const Color(0xFFFDE047)), // Yellow
    _SparkleSpec(angleOffset: 0.50, distOffset: -20.0, radius: 1.8, color: const Color(0xFF34D399)), // Green
  ];

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

    // 1. Draw 10 Circular Dots with dynamic wave scaling
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

    // 2. Draw surrounding sparkle particles around the active lead dot
    final leadX = center.dx + circleRadius * math.cos(leadAngle - (math.pi / 2));
    final leadY = center.dy + circleRadius * math.sin(leadAngle - (math.pi / 2));
    final leadPos = Offset(leadX, leadY);

    for (final sparkle in sparkles) {
      final sparkleAngle = (leadAngle - (math.pi / 2)) + sparkle.angleOffset;
      final sx = leadPos.dx + sparkle.distOffset * math.cos(sparkleAngle);
      final sy = leadPos.dy + sparkle.distOffset * math.sin(sparkleAngle);

      final sparklePaint = Paint()
        ..color = sparkle.color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawCircle(Offset(sx, sy), sparkle.radius, sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlayfulCircleLoaderPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.dotColor != dotColor;
  }
}

class _SparkleSpec {
  final double angleOffset;
  final double distOffset;
  final double radius;
  final Color color;

  _SparkleSpec({
    required this.angleOffset,
    required this.distOffset,
    required this.radius,
    required this.color,
  });
}
