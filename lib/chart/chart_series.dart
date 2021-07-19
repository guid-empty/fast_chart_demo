import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:flutter/material.dart';

typedef ValueMapper<TChartPointData, TAxisValue> = TAxisValue Function(
  TChartPointData data,
  int index,
);

abstract class ChartSeries<TData> {
  final ChartSeriesDataSource<TData> dataSource;
  final ValueMapper<TData, dynamic> xValueMapper;
  final ValueMapper<TData, num> yValueMapper;
  final ValueMapper<TData, bool> isDirtyMapper;
  final ValueMapper<TData, Color> pointColorMapper;

  final String? name;
  final Color? borderColor;
  final double? borderWidth;
  final Duration? animationDuration;

  const ChartSeries({
    required this.dataSource,
    required this.xValueMapper,
    required this.yValueMapper,
    required this.isDirtyMapper,
    required this.pointColorMapper,
    this.animationDuration,
    this.name,
    this.borderColor,
    this.borderWidth,
  });
}
