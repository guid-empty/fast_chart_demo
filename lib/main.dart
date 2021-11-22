import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math' as math;

import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:fast_chart/chart/fast_chart.dart';
import 'package:fast_chart/custom_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

List<CustomData> fetchData(int taskId) {
  final task = developer.TimelineTask.withTaskId(taskId);

  task.start('construction the data');
  sleep(const Duration(seconds: 3));
  task.finish();
  return <CustomData>[
    CustomData(dayInMonth: 1, closedPrice: 10, color: Colors.red),
    CustomData(dayInMonth: 2, closedPrice: 15, color: Colors.orange),
    CustomData(dayInMonth: 3, closedPrice: 20, color: Colors.redAccent),
    CustomData(dayInMonth: 4, closedPrice: 25, color: Colors.orangeAccent),
    CustomData(dayInMonth: 5, closedPrice: 30, color: Colors.deepOrange),
    CustomData(dayInMonth: 6, closedPrice: 25, color: Colors.amberAccent),
    CustomData(dayInMonth: 7, closedPrice: 20, color: Colors.brown),
    CustomData(dayInMonth: 8, closedPrice: 15, color: Colors.yellow),
    CustomData(dayInMonth: 9, closedPrice: 20, color: Colors.amber),
    CustomData(dayInMonth: 10, closedPrice: 50, color: Colors.deepOrangeAccent),
  ];
}

class MyApp extends StatelessWidget {
  static developer.TimelineTask parentTask = developer.TimelineTask();

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
  final List<CustomData> _dataSource = <CustomData>[
    CustomData(dayInMonth: 1, closedPrice: 10, color: Colors.red),
    CustomData(dayInMonth: 2, closedPrice: 15, color: Colors.orange),
    CustomData(dayInMonth: 3, closedPrice: 20, color: Colors.redAccent),
    CustomData(dayInMonth: 4, closedPrice: 25, color: Colors.orangeAccent),
    CustomData(dayInMonth: 5, closedPrice: 30, color: Colors.deepOrange),
    CustomData(dayInMonth: 6, closedPrice: 25, color: Colors.amberAccent),
    CustomData(dayInMonth: 7, closedPrice: 20, color: Colors.brown),
    CustomData(dayInMonth: 8, closedPrice: 15, color: Colors.yellow),
    CustomData(dayInMonth: 9, closedPrice: 20, color: Colors.amber),
    CustomData(dayInMonth: 10, closedPrice: 50, color: Colors.deepOrangeAccent),
  ];

  late ValueNotifier<int> _total = ValueNotifier<int>(_dataSource.length);

  @override
  Widget build(BuildContext context) {
    developer.Timeline.startSync('fetching1');
    developer.Timeline.finishSync();

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(10.0),
        constraints: BoxConstraints.expand(),
        alignment: Alignment.center,
        child: FutureBuilder(
            // future: _getDataSourceAsync(),
            future: _getDataSourceFromIsolate(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }

              final dataSource =
                  ChartSeriesDataSource(snapshot.data as List<CustomData>);

              return Stack(
                fit: StackFit.expand,
                children: [
                  FastChart<CustomData>(
                    series: ColumnSeries<CustomData>(
                      animationDuration: Duration(milliseconds: 500),
                      dataSource: dataSource,
                      xValueMapper: (CustomData data, int index) =>
                          dataSource[index].dayInMonth,
                      yValueMapper: (CustomData data, int index) =>
                          dataSource[index].closedPrice,
                      pointColorMapper: (CustomData data, int index) =>
                          dataSource[index].color,
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
              );
            }),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Do Nothing',
            child: Text('N'),
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

  @override
  void initState() {
    super.initState();
    MyApp.parentTask.start('home page rendering');
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

  Future<List<CustomData>> _getDataSourceAsync() async {
    final task = developer.TimelineTask(parent: MyApp.parentTask);
    task.start('fetching async the data source');

    await _innerAsyncOperation(task);
    await _innerAsyncOperation(task);
    await _innerAsyncOperation(task);

    task.finish();

    return _dataSource;
  }

  Future<List<CustomData>> _getDataSourceFromIsolate() {
    final task = developer.TimelineTask(parent: MyApp.parentTask);

    final taskId = task.pass();
    task.start('fetching the data source');

    final result = compute<int, List<CustomData>>(
      fetchData,
      taskId,
    );

    task.finish();

    return result;
  }

  Future<void> _innerAsyncOperation(developer.TimelineTask parent) async {
    final task = developer.TimelineTask(parent: parent);
    task.start('inner async operation');
    await Future.delayed(const Duration(seconds: 1));
    task.finish();
  }
}
