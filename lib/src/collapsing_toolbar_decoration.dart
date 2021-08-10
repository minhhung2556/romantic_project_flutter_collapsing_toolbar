import 'package:flutter/material.dart';

import 'common.dart';

const double _kDecorationElevation = 8.0;

class CollapsingToolbarDecoration extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final double animationValue;

  const CollapsingToolbarDecoration({
    Key? key,
    required this.child,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.animationValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: animationValue * _kDecorationElevation * 3),
        child: child,
      ),
      painter: _DefaultCollapsingToolbarDecorationPainter(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: _kDecorationElevation,
        animationValue: animationValue,
      ),
    );
  }
}

class _DefaultCollapsingToolbarDecorationPainter extends CustomPainter {
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final double animationValue;

  const _DefaultCollapsingToolbarDecorationPainter({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.elevation,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ovalH = size.height * 2;
    final ovalW = size.width * 2;
    final ellipseX = ovalW * animationValue;
    final ellipseY = ovalW * 0.5 * animationValue;
    final colorLighter = foregroundColor.lighter(0.85);
    final colorDarker = foregroundColor.darker(0.1 * animationValue);
    final colorDarker1 = foregroundColor.darker(0.15 * animationValue);

    canvas.drawRect(Rect.largest, Paint()..color = backgroundColor);

    canvas.drawPath(
        Path()
          ..addRRect(RRect.fromRectAndCorners(
            Rect.fromLTWH(ovalW * -0.25, ovalH * 0.5 * -1, ovalW, ovalH),
            bottomLeft: Radius.elliptical(ellipseX, ellipseY),
            bottomRight: Radius.elliptical(ellipseX, ellipseY),
          )),
        Paint()..color = colorLighter);

    canvas.drawPath(
        Path()
          ..addRRect(RRect.fromRectAndCorners(
            Rect.fromLTWH(ovalW * -0.25,
                ovalH * 0.5 * -1 - elevation * animationValue, ovalW, ovalH),
            bottomLeft: Radius.elliptical(ellipseX, ellipseY),
            bottomRight: Radius.elliptical(ellipseX, ellipseY),
          )),
        Paint()..color = foregroundColor);

    canvas.drawPath(
        Path()
          ..addRRect(RRect.fromRectAndCorners(
            Rect.fromLTWH(ovalW * -0.25 + (-ovalW * 0.25) * animationValue,
                ovalH * 0.5 * -1 - elevation - ovalH * 0.15, ovalW, ovalH),
            bottomRight: Radius.elliptical(ellipseY, ellipseY * 0.5),
          )),
        Paint()..color = colorDarker);

    canvas.drawPath(
        Path()
          ..addRRect(RRect.fromRectAndCorners(
            Rect.fromLTWH(ovalW * -0.25 + (-ovalW * 0.35) * animationValue,
                ovalH * 0.5 * -1 - elevation - ovalH * 0.2, ovalW, ovalH),
            bottomRight: Radius.elliptical(ellipseY, ellipseY * 0.5),
          )),
        Paint()..color = colorDarker1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
