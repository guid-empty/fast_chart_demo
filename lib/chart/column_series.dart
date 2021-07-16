import 'package:fast_chart/chart/chart_series.dart';
import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:flutter/material.dart';

class ColumnSeries<TData> extends ChartSeries<TData> {
  final ValueMapper<TData, dynamic> xValueMapper;
  final ValueMapper<TData, num> yValueMapper;
  final ValueMapper<TData, Color> pointColorMapper;

  ColumnSeries({
    required ChartSeriesDataSource<TData> dataSource,
    required this.xValueMapper,
    required this.yValueMapper,
    required this.pointColorMapper,
    Duration? animationDuration,
    String? name,
    Color? borderColor,
    double? borderWidth,
  }) : super(
          dataSource: dataSource,
          xValueMapper: xValueMapper,
          yValueMapper: yValueMapper,
          pointColorMapper: pointColorMapper,
          name: name,
          animationDuration: animationDuration,
          borderColor: borderColor,
          borderWidth: borderWidth,
        );
}
