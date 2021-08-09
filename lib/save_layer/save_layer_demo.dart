import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fast_chart/save_layer/text_painter_in_save_layer.dart';
import 'package:fast_chart/save_layer/transparent_items_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

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
        child: FutureBuilder(
          future: loadUiImage('assets/abstract-background-high.jpg'),
          builder: (context, AsyncSnapshot<ui.Image> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return CustomPaint(
                //  simple demo to show save layer rules
                painter: TextPainterInSaveLayerPainter(
                  useSaveLayer: true,
                  background: snapshot.data!,
                ),

                //  simple demo to show several transparent items
                //  painter: TransparentItemsPainter(),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Future<ui.Image> loadUiImage(String imageAssetPath) async {
    await Future.delayed(Duration(seconds: 1));
    final ByteData data = await rootBundle.load(imageAssetPath);
    return decodeImageFromList(Uint8List.view(data.buffer));
  }
}
