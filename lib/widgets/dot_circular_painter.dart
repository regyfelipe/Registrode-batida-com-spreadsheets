import 'package:flutter/material.dart';
import 'dart:math';

class DottedCircularPainter extends CustomPainter {
  final int currentIndex;

  DottedCircularPainter({required this.currentIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint = Paint()..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final double dotRadius = 8.0;
    final int dotCount = 30;

    for (int i = 0; i < dotCount; i++) {
      double angle = (2 * pi / dotCount) * i;
      double x = radius + radius * cos(angle);
      double y = radius + radius * sin(angle);

      dotPaint.color = (i == currentIndex) ? Colors.greenAccent : Colors.grey[800]!;
      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
