import 'dart:ui' as ui;

import 'package:fast_chart/chart/axis_painter.dart';
import 'package:fast_chart/chart/chart_series.dart';
import 'package:fast_chart/chart/column_painter.dart';
import 'package:fast_chart/chart/column_series.dart';
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
  AnimationController? _seriesAnimationController;

  Animation<double>? _seriesAnimation;

  ui.Picture? axisBackgroundPicture;

  CustomPainter? axisPainter;

  @override
  Widget build(BuildContext context) => renderChartElements(context);

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
    final currentAxisPainter = _getAxisPainter<TData>(
      series: widget._series as ChartSeries<TData>,
      animation: _seriesAnimation,
    );

    return Container(
      color: widget.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 32),
        child: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  axisPainter = currentAxisPainter;
                  final size =
                      Size(constraints.maxWidth, constraints.maxHeight);
                  var recorder = ui.PictureRecorder();
                  var canvas = Canvas(
                    recorder,
                    Rect.fromLTWH(0, 0, size.width, size.height),
                  );
                  currentAxisPainter?.paint(canvas, size);
                  axisBackgroundPicture = recorder.endRecording();

                  return RepaintBoundary(
                    child: CustomPaint(
                      isComplex: true,
                      painter: _getSeriesPainter<TData>(
                        series: widget._series as ChartSeries<TData>,
                        animation: _seriesAnimation,
                        axisBackgroundPicture: axisBackgroundPicture,
                      ),
                    ),
                  );
                },
              ),
            ],
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
    ui.Picture? axisBackgroundPicture,
  }) {
    if (series is ColumnSeries<TData>) {
      return ColumnsPainter(
        series: series,
        animation: animation,
        axisBackgroundPicture: axisBackgroundPicture,
      );
    }

    return null;
  }
}
