import 'dart:math' as math;

import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:fast_chart/chart/fast_chart.dart';
import 'package:fast_chart/custom_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  debugProfilePaintsEnabled = true;
  debugProfileBuildsEnabled = true;
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  Set<int> _updatedItemsCache = <int>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
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
                isDirtyMapper: (CustomData data, index) =>
                    _updatedItemsCache.contains(index),
              ),
              backgroundColor: Colors.black87,
            ),
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              height: 20,
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                color: Colors.black.withAlpha(90),
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
              bottom: 10,
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
          FloatingActionButton(
            onPressed: () => _update5(),
            tooltip: 'Update',
            child: Icon(Icons.update_outlined),
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
            child: Icon(Icons.refresh_outlined),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _add100() {
    setState(() {
      int dayInMonth = 11;
      for (int i = 0; i < 100; i++) {
        _dataSource.add(
          _generateCustomData(dayInMonth, 60),
        );

        dayInMonth++;
        if (dayInMonth > 30) {
          dayInMonth = 1;
        }
      }

      _total.value = _dataSource.length;
    });
  }

  CustomData _generateCustomData(int dayInMonth, int maxClosedPrice) {
    final closedPrice = math.Random().nextInt(maxClosedPrice);
    final a = 255 - math.Random().nextInt(30);
    final r = math.Random().nextInt(255);
    final g = math.Random().nextInt(255);
    final b = math.Random().nextInt(255);

    return CustomData(
      dayInMonth: dayInMonth,
      closedPrice: closedPrice,
      color: Color.fromARGB(a, r, g, b),
    );
  }

  void _update5() {
    var updatedIndex = 4;

    _updatedItemsCache.add(updatedIndex);
    _dataSource[updatedIndex] = _generateCustomData(updatedIndex, 50);

    updatedIndex = 8;

    _updatedItemsCache.add(updatedIndex);
    _dataSource[updatedIndex] = _generateCustomData(updatedIndex, 50);
  }
}
