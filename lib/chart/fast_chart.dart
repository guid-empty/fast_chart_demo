import 'package:fast_chart/chart/axis_painter.dart';
import 'package:fast_chart/chart/chart_series.dart';
import 'package:fast_chart/chart/column_painter.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:flutter/material.dart';

class FastChart<TData> extends StatefulWidget {
  final Color? backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final ChartSeries<TData> _series;

  const FastChart({
    Key? key,
    required ChartSeries<TData> series,
    this.backgroundColor,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    EdgeInsets? margin,
  })  : _series = series,
        super(key: key);

  @override
  _FastChartState<TData> createState() => _FastChartState<TData>();
}

class _FastChartState<TData> extends State<FastChart> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: renderChartElements(context),
    );
  }

  Widget renderChartElements(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox.expand(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: _getAxisPainter<TData>(
                    series: widget._series as ChartSeries<TData>,
                  ),
                ),
                CustomPaint(
                  painter: _getSeriesPainter<TData>(
                    series: widget._series as ChartSeries<TData>,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomPainter? _getAxisPainter<TData>({
    required ChartSeries<TData> series,
    AnimationController? animationController,
  }) {
    if (series is ColumnSeries<TData>) {
      return AxisPainter(
        series: series,
        animationController: animationController,
      );
    }

    return null;
  }

  CustomPainter? _getSeriesPainter<TData>({
    required ChartSeries<TData> series,
    AnimationController? animationController,
  }) {
    if (series is ColumnSeries<TData>) {
      return ColumnsPainter(
        series: series,
        animationController: animationController,
      );
    }

    return null;
  }
}
