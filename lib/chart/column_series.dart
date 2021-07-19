import 'package:fast_chart/chart/chart_series.dart';
import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:flutter/material.dart';

class ColumnSeries<TData> extends ChartSeries<TData> {
  ColumnSeries({
    required ChartSeriesDataSource<TData> dataSource,
    required ValueMapper<TData, dynamic> xValueMapper,
    required ValueMapper<TData, num> yValueMapper,
    required ValueMapper<TData, bool> isDirtyMapper,
    required ValueMapper<TData, Color> pointColorMapper,
    Duration? animationDuration,
    String? name,
    Color? borderColor,
    double? borderWidth,
  }) : super(
          dataSource: dataSource,
          xValueMapper: xValueMapper,
          yValueMapper: yValueMapper,
          isDirtyMapper: isDirtyMapper,
          pointColorMapper: pointColorMapper,
          name: name,
          animationDuration: animationDuration,
          borderColor: borderColor,
          borderWidth: borderWidth,
        );
}
