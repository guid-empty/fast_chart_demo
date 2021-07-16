import 'dart:math' as math;
import 'dart:ui';

import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ColumnsPainter<TData> extends CustomPainter {
  final AnimationController? animationController;
  final ColumnSeries<TData> _series;
  final ChartSeriesDataSource<TData> _dataSource;

  ColumnsPainter({
    required ColumnSeries<TData> series,
    this.animationController,
  })  : _series = series,
        _dataSource = series.dataSource,
        super(repaint: animationController);

  @override
  void paint(Canvas canvas, Size size) {
    final double margin = 10;
    final double radius = 4;

    final columnWidth = (size.width - (margin * _dataSource.length + margin)) / _dataSource.length;
    double left = margin;

    for (var i = 0; i < _dataSource.length; i++) {
      final TData data = _dataSource[i];

      Paint columnFillPaint = Paint()
        ..color = _series.pointColorMapper(data, i)
        ..style = PaintingStyle.fill;

      final yAxisMaxValue = _getMaxYAxisValue();
      final yAxisValue = _series.yValueMapper(data, i);
      final columnHeight = (yAxisValue / yAxisMaxValue) * size.height - margin;

      final columnRRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
            left, size.height - columnHeight, columnWidth, columnHeight),
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );

      left += columnWidth + margin;
      canvas.drawRRect(columnRRect, columnFillPaint);
    }
  }

  @override
  bool shouldRepaint(ColumnsPainter oldDelegate) => true;

  num _getMaxYAxisValue() {
    num max = 0;
    for (var i = 0; i < _dataSource.length; i++) {
      final data = _dataSource[i];
      final yAxisValue = _series.yValueMapper(data, i);
      max = math.max(max, yAxisValue);
    }

    return max;
  }
}
