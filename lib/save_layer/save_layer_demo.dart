import 'dart:math' as math;

import 'package:fast_chart/chart/chart_series_data_source.dart';
import 'package:fast_chart/chart/column_series.dart';
import 'package:fast_chart/chart/fast_chart.dart';
import 'package:fast_chart/custom_data.dart';
import 'package:fast_chart/save_layer/transparent_items_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      home: MyHomePage(title: 'Flutter Save Layer Demo'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: double.infinity,
          minWidth: double.infinity,
        ),
        child: CustomPaint(
          painter: TransparentItemsPainter(),
        ),
      ),
    );
  }
}
