import 'package:flutter/material.dart';

typedef ValueMapper<TChartPointData, TAxisValue> = TAxisValue Function(
  TChartPointData data,
  int index,
);

abstract class ChartSeries<TData> {
  final ValueMapper<TData, dynamic> xValueMapper;
  final ValueMapper<TData, num> yValueMapper;
  final ValueMapper<TData, Color> pointColorMapper;

  final String? name;
  final double? animationDuration;
  final Color? borderColor;
  final double? borderWidth;

  const ChartSeries({
    required this.xValueMapper,
    required this.yValueMapper,
    required this.pointColorMapper,
    this.name,
    this.animationDuration,
    this.borderColor,
    this.borderWidth,
  });
}
