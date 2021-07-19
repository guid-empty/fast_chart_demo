import 'dart:ui';

import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:fast_chart/chart/column_series_calculation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UpdatedColumnsClipper<TData> extends CustomClipper<Path> {
  final ColumnSeries<TData> _series;
  final ChartSeriesDataSource<TData> _dataSource;
  final ColumnSeriesCalculationService<TData> _columnSeriesCalculationService;

  UpdatedColumnsClipper({
    required ColumnSeries<TData> series,
  })  : _series = series,
        _dataSource = series.dataSource,
        _columnSeriesCalculationService = ColumnSeriesCalculationService(
          series: series,
          dataSource: series.dataSource,
        ),
        super(
          reclip: Listenable.merge(
            [
              series.dataSource,
            ],
          ),
        );

  @override
  Path getClip(Size size) {
    final Path resultPath = Path();

    final animationFactor = 1;
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

      if (_series.isDirtyMapper(data, i)) {
        final columnRRect = RRect.fromRectAndCorners(
          Rect.fromLTWH(left, 0, columnWidth, size.height),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        );

        resultPath.addRRect(columnRRect);
      }
      left += columnWidth + margin;
    }

    return resultPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
