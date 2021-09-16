import 'dart:ui';

import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AxisPainter<TData> extends CustomPainter {
  final ChartSeriesDataSource<TData> _dataSource;

  AxisPainter({
    required ColumnSeries<TData> series,
  }) : _dataSource = series.dataSource;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.black87, BlendMode.src);
    final double margin = 10;

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
  }

  @override
  bool shouldRepaint(AxisPainter oldDelegate) => true;
}
