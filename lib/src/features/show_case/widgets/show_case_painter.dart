import 'package:flutter/material.dart';

class ShowCasePainter extends CustomPainter {
  final Offset centerPosition;
  final Size widgetSize;
  final Animation<double> openingAnimation;
  final Animation<double> bouncingAnimation;
  final double ringWidth;
  final double widgetSizeMultiplier;
  final double bouncingAnimationSizeMuliplier;

  ShowCasePainter(
      {required this.centerPosition,
      required this.widgetSize,
      required this.openingAnimation,
      required this.bouncingAnimation,
      this.widgetSizeMultiplier = 1.0,
      this.bouncingAnimationSizeMuliplier = 10.0,
      this.ringWidth = 10.0})
      : super(repaint: Listenable.merge([openingAnimation, bouncingAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    // Radius of circles on opening, this will be added on normal radius
    final double animatedOpeningFactorRadius =
        (1 - openingAnimation.value) * size.shortestSide;

    // Radius of circles on bouncing animation
    final double animatedBouncingFactorRadius =
        bouncingAnimation.value * bouncingAnimationSizeMuliplier;

    Paint outerCirclePaint = Paint();
    outerCirclePaint.color = Colors.black.withOpacity(0.6);
    outerCirclePaint.style = PaintingStyle.fill;
    Rect outerCircleShape = Rect.fromCircle(
        center: centerPosition,
        radius: widgetSize.width * widgetSizeMultiplier +
            animatedOpeningFactorRadius +
            animatedBouncingFactorRadius);
    Path outerCircle = Path();
    outerCircle.addOval(outerCircleShape);
    outerCircle.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    outerCircle.fillType = PathFillType.evenOdd;

    Paint innerCirclePaint = Paint();
    innerCirclePaint.color = Colors.black.withOpacity(0.3);
    innerCirclePaint.style = PaintingStyle.fill;
    Path innerCircle = Path();
    innerCircle.addOval(Rect.fromCircle(
        center: centerPosition,
        radius: widgetSize.width * widgetSizeMultiplier -
            ringWidth +
            animatedOpeningFactorRadius +
            animatedBouncingFactorRadius));
    innerCircle.addOval(outerCircleShape);
    innerCircle.fillType = PathFillType.evenOdd;

    canvas.drawPath(outerCircle, outerCirclePaint);
    canvas.drawPath(innerCircle, innerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
