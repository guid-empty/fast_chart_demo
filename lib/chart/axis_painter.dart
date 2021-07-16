import 'dart:math' as math;
import 'dart:ui';

import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AxisPainter<TData> extends CustomPainter {
  final AnimationController? animationController;
  final ColumnSeries<TData> _series;
  final ChartSeriesDataSource<TData> _dataSource;

  AxisPainter({
    required ColumnSeries<TData> series,
    this.animationController,
  })  : _series = series,
        _dataSource = series.dataSource,
        super(repaint: animationController);

  @override
  void paint(Canvas canvas, Size size) {
    final double margin = 10;
    final double radius = 4;

    final columnWidth = (size.width - (margin * _dataSource.length + margin)) /
        _dataSource.length;
    double left = margin;

    final yAxisMaxValue = size.height;
    final yAxisMajorLinesStep = yAxisMaxValue / 10;

    Paint axisLinePaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < _dataSource.length; i++) {
      final TData data = _dataSource[i];

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
