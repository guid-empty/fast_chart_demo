import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:fast_chart/chart/fast_chart.dart';
import 'package:fast_chart/custom_data.dart';
import 'package:flutter/material.dart';

void main() {
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
          dayInMonth: 9, closedPrice: 20, color: Colors.deepOrangeAccent),
    ],
  );

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
                dataSource: _dataSource,
                xValueMapper: (CustomData data, int index) =>
                    _dataSource[index].dayInMonth,
                yValueMapper: (CustomData data, int index) =>
                    _dataSource[index].closedPrice,
                pointColorMapper: (CustomData data, int index) =>
                    _dataSource[index].color,
              ),
              backgroundColor: Colors.black87,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
