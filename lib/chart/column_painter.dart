import 'dart:math' as math;
import 'dart:ui';

import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ColumnsPainter<TData> extends CustomPainter {
  final ColumnSeries<TData> _series;
  final ChartSeriesDataSource<TData> _dataSource;

  ColumnsPainter({
    required ColumnSeries<TData> series,
  })  : _series = series,
        _dataSource = series.dataSource;

  @override
  void paint(Canvas canvas, Size size) {
    late double margin;
    late double radius;

    final maxAvailableColumnWidth = size.width / _dataSource.length;
    if (maxAvailableColumnWidth < 8 && maxAvailableColumnWidth >= 2) {
      margin = 1;
      radius = 1;
    } else if (maxAvailableColumnWidth < 2) {
      margin = 0;
      radius = 0;
    } else {
      margin = 10;
      radius = 4;
    }

    final columnWidth = (size.width - (margin * _dataSource.length + margin)) /
        _dataSource.length;
    double left = margin;

    for (var i = 0; i < _dataSource.length; i++) {
      final TData data = _dataSource[i];
      Paint columnFillPaint = Paint()
        ..color = _series.pointColorMapper(data, i)
        ..style = PaintingStyle.fill;

    final yAxisMaxValue = _getMaxYAxisValue();                              ///  ! O(N^2)
      final yAxisValue = _series.yValueMapper(data, i);
      final columnHeight =
          ((yAxisValue / yAxisMaxValue) * size.height - margin);

      final top = size.height - columnHeight;
      final columnRRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, top, columnWidth, columnHeight),
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );
      canvas.drawRRect(columnRRect, columnFillPaint);

      left += columnWidth + margin;
    }
  }

  @override
  bool shouldRepaint(ColumnsPainter oldDelegate) => false;

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
