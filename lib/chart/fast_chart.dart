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

class _FastChartState<TData> extends State<FastChart>
    with SingleTickerProviderStateMixin {
  AnimationController? _seriesAnimationController;

  Animation<double>? _seriesAnimation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: renderChartElements(context),
    );
  }

  @override
  void didUpdateWidget(FastChart<TData> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget._series != oldWidget._series) {
      if (widget._series.animationDuration != null) {
        _seriesAnimationController!
          ..reset()
          ..forward();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget._series.animationDuration != null) {
      _seriesAnimationController = AnimationController(
        vsync: this,
        duration: widget._series.animationDuration,
      );

      _seriesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _seriesAnimationController!,
          curve: Curves.easeInOut,
        ),
      );

      _seriesAnimationController!.forward();
    }
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
                    animation: _seriesAnimation,
                  ),
                ),
                CustomPaint(
                  painter: _getSeriesPainter<TData>(
                    series: widget._series as ChartSeries<TData>,
                    animation: _seriesAnimation,
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
    Animation<double>? animation,
  }) {
    if (series is ColumnSeries<TData>) {
      return AxisPainter(
        series: series,
        animation: animation,
      );
    }

    return null;
  }

  CustomPainter? _getSeriesPainter<TData>({
    required ChartSeries<TData> series,
    Animation<double>? animation,
  }) {
    if (series is ColumnSeries<TData>) {
      return ColumnsPainter(
        series: series,
        animation: animation,
      );
    }

    return null;
  }
}
