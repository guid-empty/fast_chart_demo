import 'dart:math' as math;

import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';

class ColumnSeriesCalculationService<TData> {
  final ColumnSeries<TData> series;
  final ChartSeriesDataSource<TData> dataSource;

  ColumnSeriesCalculationService({
    required this.series,
    required this.dataSource,
  });

  num getMaxYAxisValue() {
    num max = 0;
    for (var i = 0; i < dataSource.length; i++) {
      final data = dataSource[i];
      final yAxisValue = series.yValueMapper(data, i);
      max = math.max(max, yAxisValue);
    }

    return max;
  }
}
