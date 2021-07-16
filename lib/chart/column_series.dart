import 'package:fast_chart/chart/chart_series.dart';
import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:flutter/material.dart';

class ColumnSeries<TData> extends ChartSeries<TData> {
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
    double? animationDuration,
    Color? borderColor,
    double? borderWidth,
  }) : super(
          xValueMapper: xValueMapper,
          yValueMapper: yValueMapper,
          pointColorMapper: pointColorMapper,
          name: name,
          animationDuration: animationDuration,
          borderColor: borderColor,
          borderWidth: borderWidth,
        );
}
