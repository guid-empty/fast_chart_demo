import 'package:fast_chart/chart/axis_painter.dart';
import 'package:fast_chart/chart/chart_series.dart';
import 'package:fast_chart/chart/column_painter.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:fast_chart/chart/updated_column_clipper.dart';
import 'package:fast_chart/chart/updated_column_painter.dart';
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
  static GlobalKey _columnsPainterGlobalKey =
      GlobalKey(debugLabel: 'columns painter');

  static GlobalKey _columnsUpdatedColumnsPainterGlobalKey =
      GlobalKey(debugLabel: 'updated columns painter');

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

      // ..addListener(() {
      //   print(_seriesAnimationController!.value);
      // });

      _seriesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _seriesAnimationController!,
          curve: Curves.easeInOut,
        ),
      );

      _seriesAnimationController!.forward();

      ///
      /// todo: start animation
      ///
      // widget._series.dataSource.onUpdated.listen((event) {
      //   _seriesAnimationController!
      //     ..reset()
      //     ..forward();
      // });
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
                ///
                /// TODO: try to remove RepaintBoundary and Tap on Update button twise
                ///
                RepaintBoundary(
                  child: CustomPaint(
                    isComplex: true,
                    painter: _getAxisPainter<TData>(
                      series: widget._series as ChartSeries<TData>,
                      animation: _seriesAnimation,
                    ),
                  ),
                ),

                ///
                /// TODO: try to remove RepaintBoundary and Tap on Update button twise
                ///
                RepaintBoundary(
                  child: CustomPaint(
                    key: _columnsPainterGlobalKey,
                    isComplex: true,
                    painter: _getSeriesPainter<TData>(
                      series: widget._series as ChartSeries<TData>,
                      animation: _seriesAnimation,
                    ),
                  ),
                ),

                RepaintBoundary(
                  child: ClipPath(
                    clipper: UpdatedColumnsClipper<TData>(
                      series: widget._series as ColumnSeries<TData>,
                    ),
                    child: CustomPaint(
                      key: _columnsUpdatedColumnsPainterGlobalKey,
                      isComplex: true,
                      painter: _getAxisPainter<TData>(
                        series: widget._series as ChartSeries<TData>,
                        animation: _seriesAnimation,
                      ),
                      foregroundPainter: _getUpdatedSeriesPainter<TData>(
                        series: widget._series as ChartSeries<TData>,
                      ),
                    ),
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

  CustomPainter? _getUpdatedSeriesPainter<TData>({
    required ChartSeries<TData> series,
  }) {
    if (series is ColumnSeries<TData>) {
      return UpdatedColumnsPainter(
        series: series,
      );
    }

    return null;
  }
}
