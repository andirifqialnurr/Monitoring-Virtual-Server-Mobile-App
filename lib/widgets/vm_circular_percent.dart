import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResourceIndicator extends StatelessWidget {
  final String title;
  final num maxValue;
  final double usageValue;
  final bool isPercentage;
  final String? displayValue;
  final String? unit;
  final Color? progressColor;

  const ResourceIndicator({
    super.key,
    required this.title,
    required this.maxValue,
    required this.usageValue,
    this.isPercentage = false,
    this.displayValue,
    this.unit,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    double percentage =
        isPercentage ? usageValue : (usageValue / maxValue).clamp(0.0, 1.0);

    return Column(
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 8.0,
          percent: percentage,
          center: Text(
            isPercentage
                ? "$displayValue%"
                : "${(percentage * 100).toStringAsFixed(2)}%",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: progressColor,
          backgroundColor: Colors.black.withOpacity(0.15),
        ),
        const SizedBox(height: 8.0),
        Text(
          title,
          style: const TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          isPercentage
              ? "$displayValue% of ${maxValue.toStringAsFixed(0)} $unit"
              : "${usageValue.toStringAsFixed(2)} $unit of ${maxValue.toStringAsFixed(2)} $unit",
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
      ],
    );
  }
}

class GradientCircularPainter extends CustomPainter {
  final double percent;
  final Color startColor;
  final Color endColor;
  final double width;

  GradientCircularPainter({
    required this.percent,
    required this.startColor,
    required this.endColor,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [startColor, endColor],
        stops: [percent, percent],
      ).createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - width) / 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
