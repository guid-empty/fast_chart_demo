import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:flutter/material.dart';

typedef ValueMapper<TChartPointData, TAxisValue> = TAxisValue Function(
  TChartPointData data,
  int index,
);

class ColumnSeries<TData> {
  final ChartSeriesDataSource<TData> dataSource;
  final ValueMapper<TData, dynamic> xValueMapper;
  final ValueMapper<TData, num> yValueMapper;
  final ValueMapper<TData, Color> pointColorMapper;

  ColumnSeries({
    required this.dataSource,
    required this.xValueMapper,
    required this.yValueMapper,
    required this.pointColorMapper,
    String? name,
    Color? borderColor,
    double? borderWidth,
  });
}
