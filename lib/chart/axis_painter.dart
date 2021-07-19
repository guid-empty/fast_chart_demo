import 'dart:ui';

import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AxisPainter<TData> extends CustomPainter {
  final Animation<double>? animation;
  final ChartSeriesDataSource<TData> _dataSource;

  AxisPainter({
    required ColumnSeries<TData> series,
    this.animation,
  })  : _dataSource = series.dataSource,
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint())
      ..drawColor(Colors.black87, BlendMode.src);

    late double margin;

    final maxAvailableColumnWidth = size.width / _dataSource.length;
    if (maxAvailableColumnWidth < 8 && maxAvailableColumnWidth >= 2) {
      margin = 1;
    } else if (maxAvailableColumnWidth < 2) {
      margin = 0;
    } else {
      margin = 10;
    }

    final columnWidth = (size.width - (margin * _dataSource.length + margin)) /
        _dataSource.length;
    double left = margin;

    final yAxisMaxValue = size.height;
    final yAxisMajorLinesStep = yAxisMaxValue / 10;

    Paint axisLinePaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < _dataSource.length; i++) {
      left += columnWidth + margin;
      final xAxisPosition = left - margin - columnWidth / 2;

      //  vertical
      canvas.drawLine(Offset(xAxisPosition, 0),
          Offset(xAxisPosition, size.height), axisLinePaint);
    }

    var yAxisOffset = yAxisMajorLinesStep;
    for (var i = 0; i < 10; i++) {
      //  horizontal
      canvas.drawLine(Offset(0, yAxisOffset), Offset(size.width, yAxisOffset),
          axisLinePaint);

      yAxisOffset += yAxisMajorLinesStep;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(AxisPainter oldDelegate) => false;
}
