import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TransparentItemsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final itemsCount = 5;
    final itemsWidth = size.width / 3;
    final itemsHeight = itemsWidth;

    Iterable<int>.generate(itemsCount).forEach((index) {
      final left = math.Random().nextDouble() * (size.width - itemsWidth);
      final top = math.Random().nextDouble() * (size.height - itemsHeight);
      final rect = Rect.fromLTWH(left, top, itemsWidth, itemsHeight);

      Paint rectPaint;

      if (index.isEven) {
        rectPaint = Paint()
          ..color = Colors.red.withAlpha(255 - (index * 10))
          ..style = PaintingStyle.fill;
      } else {
        rectPaint = Paint()
          ..color = Colors.green.withAlpha(255 - (index * 10))
          ..style = PaintingStyle.fill;
      }

      canvas.saveLayer(Offset.zero & size, Paint());
      if (index.isEven) {
        var positive = math.Random().nextBool();
        canvas.translate(size.width / 2, size.height / 2);
        canvas
            .rotate((positive ? 2 : -2) * math.pi * math.Random().nextDouble());
        canvas.translate(-size.width / 2, -size.height / 2);

        // canvas.scale(.5, .5);
        // canvas.skew(.5, .5);
      }

      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(4)), rectPaint);

      canvas.restore();
    });
  }

  @override
  bool shouldRepaint(TransparentItemsPainter oldDelegate) => true;
}
