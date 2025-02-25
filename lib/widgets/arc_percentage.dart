import 'dart:math';

import 'package:flutter/material.dart';

class ArcPercentage extends StatelessWidget {
  final String title;
  final num maxValue;
  final double usageValue;
  final bool isPercentage;
  final String? displayValue;
  final String? unit;
  final Color? progressColor;
  final bool showBackground;

  const ArcPercentage({
    super.key,
    required this.title,
    required this.maxValue,
    required this.usageValue,
    this.isPercentage = false,
    this.displayValue,
    this.unit,
    this.progressColor,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    double percentage =
        isPercentage ? usageValue : (usageValue / maxValue).clamp(0.0, 1.0);
    String percentageText = isPercentage
        ? "$displayValue%"
        : "${(percentage * 100).toStringAsFixed(2)}%";

    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(100, 100),
            painter: ProgressArc(
              Colors.black54,
              1.0,
              true,
            ),
          ),
          CustomPaint(
            size: const Size(100, 100),
            painter: ProgressArc(
              progressColor!,
              percentage,
              false,
            ),
          ),
          Center(
            child: Text(
              percentageText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressArc extends CustomPainter {
  final Color progressColor;
  final double percentage;
  bool isBackground;

  ProgressArc(this.progressColor, this.percentage, this.isBackground);

  @override
  void paint(Canvas canvas, Size size) {
    const rect = Rect.fromLTRB(0, 0, 100, 100);
    const startAngle = -pi;
    final sweepAngle = pi * percentage * (isBackground ? -1 : -1);
    const userCenter = false;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final Gradient gradient = LinearGradient(
      colors: <Color>[
        Colors.greenAccent.withOpacity(1.0),
        Colors.yellowAccent.withOpacity(1.0),
        Colors.redAccent.withOpacity(1.0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );
    paint.shader = gradient.createShader(rect);

    if (isBackground) {
      final backgroundPaint = Paint()
        ..strokeCap = StrokeCap.round
        ..color = Colors.black54
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10;

      canvas.drawArc(rect, startAngle, pi, userCenter, backgroundPaint);
    }

    // Draw the progress arc
    canvas.drawArc(rect, startAngle, -sweepAngle, userCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
