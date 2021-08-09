import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' show Colors;
import 'package:flutter/rendering.dart';

class TextPainterInSaveLayerPainter extends CustomPainter {
  final bool useSaveLayer;
  final Image? background;
  final int itemsCount;

  TextPainterInSaveLayerPainter({
    required this.itemsCount,
    required this.useSaveLayer,
    required this.background,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (background != null) {
      canvas.drawImage(
        background!,
        Offset.zero,
        Paint(),
      );
    }
    canvas
      ..drawLine(
        size.centerLeft(Offset.zero),
        size.centerRight(Offset.zero),
        Paint()
          ..color = Colors.black12
          ..strokeWidth = 2,
      )
      ..drawLine(
        size.topCenter(Offset.zero),
        size.bottomCenter(Offset.zero),
        Paint()
          ..color = Colors.black12
          ..strokeWidth = 2,
      );
    final itemsWidth = size.width / 1.5;
    final itemsHeight = itemsWidth;

    Iterable<int>.generate(itemsCount).forEach((index) {
      final left = (size.width / 2 - itemsWidth / 2);
      final top = (size.height / 2 - itemsHeight / 2);
      final rect = Rect.fromLTWH(left, top, itemsWidth, itemsHeight);

      late Paint rectPaint;

      ///
      /// Мы можем в принципе обойтись и без save layer, указав blend mode
      /// при формировании кисти
      ///
      if (useSaveLayer) {
        canvas.saveLayer(
            Offset.zero & size, Paint()..blendMode = BlendMode.multiply);

        rectPaint = Paint()
          ..color = index.isEven
              ? Colors.red.withOpacity(1)
              : Colors.green.withOpacity(.9)
          ..style = PaintingStyle.fill;
      } else {
        rectPaint = Paint()
          ..color = index.isEven ? Colors.red : Colors.green
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.multiply; // try to remove it
      }

      var positive = math.Random().nextBool();
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate((positive ? 2 : -2) * math.pi * math.Random().nextDouble());
      canvas.translate(-size.width / 2, -size.height / 2);

      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(24)), rectPaint);

      final span = TextSpan(
        style: TextStyle(
          color: Colors.white,
          fontSize: itemsWidth / 1.2,
        ),
        text: index.toString(),
      );

      final tp = TextPainter(
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

      if (useSaveLayer) {
        canvas.restore();
      }
    });
  }

  @override
  bool shouldRepaint(TextPainterInSaveLayerPainter oldDelegate) => true;
}
