import 'dart:math' as math;

import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:fast_chart/chart/fast_chart.dart';
import 'package:fast_chart/custom_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  debugRepaintRainbowEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Fast Chart Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ChartSeriesDataSource<CustomData> _dataSource = ChartSeriesDataSource(
    <CustomData>[
      CustomData(dayInMonth: 1, closedPrice: 10, color: Colors.red),
      CustomData(dayInMonth: 2, closedPrice: 15, color: Colors.orange),
      CustomData(dayInMonth: 3, closedPrice: 20, color: Colors.redAccent),
      CustomData(dayInMonth: 4, closedPrice: 25, color: Colors.orangeAccent),
      CustomData(dayInMonth: 5, closedPrice: 30, color: Colors.deepOrange),
      CustomData(dayInMonth: 6, closedPrice: 25, color: Colors.amberAccent),
      CustomData(dayInMonth: 7, closedPrice: 20, color: Colors.brown),
      CustomData(dayInMonth: 8, closedPrice: 15, color: Colors.yellow),
      CustomData(dayInMonth: 9, closedPrice: 20, color: Colors.amber),
      CustomData(
          dayInMonth: 10, closedPrice: 50, color: Colors.deepOrangeAccent),
    ],
  );

  late ValueNotifier<int> _total = ValueNotifier<int>(_dataSource.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FastChart<CustomData>(
              series: ColumnSeries<CustomData>(
                animationDuration: Duration(milliseconds: 500),
                dataSource: _dataSource,
                xValueMapper: (CustomData data, int index) =>
                    _dataSource[index].dayInMonth,
                yValueMapper: (CustomData data, int index) =>
                    _dataSource[index].closedPrice,
                pointColorMapper: (CustomData data, int index) =>
                    _dataSource[index].color,
              ),
              backgroundColor: Colors.black,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 20,
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                color: Colors.black.withAlpha(70),
                constraints: BoxConstraints(
                  maxWidth: double.infinity,
                  minWidth: double.infinity,
                  minHeight: 20,
                ),
                height: 20,
                child: ValueListenableBuilder(
                  builder: (context, total, widget) => Text(
                    'total: ${_total.value}',
                    style: TextStyle(color: Colors.white),
                  ),
                  valueListenable: _total,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 160,
              child: PerformanceOverlay.allEnabled(),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 10),
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _add100(),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => setState(() {}),
            tooltip: 'Refresh State',
            child: Icon(Icons.refresh_outlined),
          ),
          SizedBox(height: 160),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _add100() {
    setState(() {
      int dayInMonth = 11;
      for (int i = 0; i < 100; i++) {
        _dataSource.add(
          _generateCustomData(dayInMonth, 50),
        );

        dayInMonth++;
        if (dayInMonth > 30) {
          dayInMonth = 1;
        }
      }

      _total.value = _dataSource.length;
    });
  }

  CustomData _generateCustomData(
    int dayInMonth,
    int maxClosedPrice, [
    bool orangeRange = true,
  ]) {
    final closedPrice = math.Random().nextInt(maxClosedPrice);
    final color = orangeRange
        ? ColorTween(begin: Colors.red, end: Colors.amber).lerp(
            math.Random().nextDouble(),
          )
        : Color(
            (Colors.white.value * math.Random().nextDouble()).toInt(),
          );

    return CustomData(
      dayInMonth: dayInMonth,
      closedPrice: closedPrice,
      color: color!,
    );
  }
}
