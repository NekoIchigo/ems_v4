import 'dart:math';

import 'package:flutter/material.dart';

class CircularLoader extends StatefulWidget {
  final double radius;
  final Color color;
  final double thickness;
  const CircularLoader({
    super.key,
    required this.radius,
    required this.color,
    required this.thickness,
  });

  @override
  State<CircularLoader> createState() => _CircularLoaderState();
}

class _CircularLoaderState extends State<CircularLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.radius * 2, widget.radius * 2),
            painter: CircularPainter(
              color: widget.color,
              thickness: widget.thickness,
              animationValue: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class CircularPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double animationValue;

  CircularPainter({
    required this.color,
    required this.thickness,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double circleRadius = min(centerX, centerY) - (thickness / 2);

    const double startAngle = -pi / 2;
    final double sweepAngle = 2 * pi * animationValue;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: circleRadius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularPainter oldDelegate) {
    return false;
  }
}
