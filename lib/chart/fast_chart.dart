import 'package:fast_chart/chart/axis_painter.dart';
import 'package:fast_chart/chart/column_painter.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FastChart<TData> extends StatefulWidget {
  final Color? backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final ColumnSeries<TData> _series;

  const FastChart({
    Key? key,
    required ColumnSeries<TData> series,
    this.backgroundColor,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    EdgeInsets? margin,
  })  : _series = series,
        super(key: key);

  @override
  _FastChartState<TData> createState() => _FastChartState<TData>();
}

class _FastChartState<TData> extends State<FastChart<TData>>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: renderChartElements(context),
    );
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
                  child: CustomPaint(
                    isComplex: true,
                    painter: AxisPainter(
                      series: widget._series,
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
                  child: CustomPaint(
                    painter: ColumnsPainter<TData>(
                      series: widget._series,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
