import 'package:fast_chart/chart/axis_painter.dart';
import 'package:fast_chart/chart/chart_series.dart';
import 'package:fast_chart/chart/column_painter.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:fast_chart/chart/updated_column_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FastChart<TData> extends StatefulWidget {
  final Color? backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final bool showLabels;
  final ChartSeries<TData> _series;

  const FastChart({
    Key? key,
    required ChartSeries<TData> series,
    this.backgroundColor,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.showLabels = false,
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
    final size = MediaQuery.of(context).size;
    final chartHeight = size.height - 270;
    return Container(
      color: widget.backgroundColor,
      child: Center(
        child: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: size.width,
                  height: chartHeight,
                  child: RepaintBoundary(
                    child: CustomPaint(
                      isComplex: true,
                      painter: _getAxisPainter<TData>(
                        series: widget._series as ChartSeries<TData>,
                        animation: _seriesAnimation,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: size.width,
                  height: chartHeight,
                  child: RepaintBoundary(
                    child: CustomPaint(
                      isComplex: true,
                      painter: _getSeriesPainter<TData>(
                        series: widget._series as ChartSeries<TData>,
                        animation: _seriesAnimation,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.showLabels)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    color: Colors.black,
                    width: 30,
                    height: chartHeight,
                  ),
                ),
              if (widget.showLabels)
                ..._buildLabels(
                  series: widget._series as ChartSeries<TData>,
                  maxHeight: chartHeight,
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
  }) {
    if (series is ColumnSeries<TData>) {
      return ColumnsPainter(
        series: series,
        animation: animation,
      );
    }

    return null;
  }

  Iterable<Widget> _buildLabels({
    required ChartSeries<TData> series,
    required double maxHeight,
  }) {
    final dataSource = series.dataSource;
    final children = <Widget>[];

    final perAxisYIncrement = maxHeight / 50;
    for (int i = 0; i < dataSource.length; i++) {
      final data = dataSource[i];
      final axisYValue = series.yValueMapper(data, i);
      final top = maxHeight - perAxisYIncrement * axisYValue;

      children.add(
        Positioned(
          top: top,
          left: 10,
          child: SizedBox(
            width: 14,
            height: 20,
            child: RichText(
              textAlign: TextAlign.end,
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
              text: TextSpan(
                text: axisYValue.toString().padLeft(3, '0'),
                style: DefaultTextStyle.of(context).style.copyWith(
                      color: Colors.white,
                      fontSize: 8, //  try to increase fontSize to 10.0
                    ),
              ),
            ),
          ),
        ),
      );
    }

    return children;
  }

  Iterable<Widget> _buildLabelsWithFix({
    required ChartSeries<TData> series,
    required double maxHeight,
  }) {
    final dataSource = series.dataSource;
    final children = <Widget>[];

    final perAxisYIncrement = maxHeight / 50;
    for (int i = 0; i < dataSource.length; i++) {
      final data = dataSource[i];
      final axisYValue = series.yValueMapper(data, i);
      final top = maxHeight - perAxisYIncrement * axisYValue;

      children.add(
        Positioned(
          top: top,
          left: 10,
          child: SizedBox(
            width: 20, //  try to decrease the value to 10px
            height: 20,
            child: RichText(
              maxLines: 1,
              text: TextSpan(
                text: axisYValue.toString().padLeft(3, '0'),
                style: DefaultTextStyle.of(context).style.copyWith(
                      color: Colors.white,
                      fontSize: 8,
                    ),
              ),
            ),
          ),
        ),
      );
    }

    children.add(
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          constraints: BoxConstraints.tightFor(width: 30, height: maxHeight),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [
              0,
              0.9,
              0.9,
            ],
            colors: [
              Colors.black.withOpacity(0),
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.9),
            ],
          )),
        ),
      ),
    );

    return children;
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
