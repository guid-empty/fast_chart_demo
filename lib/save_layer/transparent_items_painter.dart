import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TransparentItemsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final itemsCount = 6;
    final itemsWidth = size.width / 3;
    final itemsHeight = itemsWidth;

    Iterable<int>.generate(itemsCount).forEach((index) {
      final left = math.Random().nextDouble() * (size.width - itemsWidth);
      final top = math.Random().nextDouble() * (size.height - itemsHeight);
      final rect = Rect.fromLTWH(left, top, itemsWidth, itemsHeight);

      Paint rectPaint = Paint()
        ..color = index.isEven ? Colors.red : Colors.green
        ..style = PaintingStyle.fill;

      var positive = math.Random().nextBool();

      canvas.saveLayer(
          Offset.zero & size, Paint()..blendMode = BlendMode.multiply);

      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate((positive ? 2 : -2) * math.pi * math.Random().nextDouble());
      canvas.translate(-size.width / 2, -size.height / 2);

      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(24)), rectPaint);

      TextSpan span = TextSpan(
        style: TextStyle(
          color: Colors.white,
          fontSize: itemsWidth / 2,
        ),
        text: index.toString(),
      );

      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);

      tp.layout();
      final metrics = tp.computeLineMetrics().first;
      tp.paint(
          canvas,
          Offset(
            left + rect.width / 2 - metrics.width / 2,
            top + rect.height / 2 - metrics.height / 2,
          ));
      canvas.restore();
    });
  }

  @override
  bool shouldRepaint(TransparentItemsPainter oldDelegate) => true;
}
