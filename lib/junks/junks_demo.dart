import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(JunksDemoApp());

class JunksDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Junks Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<int> _intAnimation;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Visibility(visible: _intAnimation.value == 1, child: _getText(1)),
            Visibility(visible: _intAnimation.value == 2, child: _getText(2)),
            Visibility(visible: _intAnimation.value == 3, child: _getText(3)),
            Visibility(visible: _intAnimation.value == 4, child: _getText(4)),
            Visibility(visible: _intAnimation.value == 5, child: _getText(5)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => sleep(Duration(milliseconds: 3000)),
        child: Icon(Icons.refresh_outlined),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
    )..addListener(() {
        setState(() {});
      });

    _intAnimation = IntTween(begin: 1, end: 5).animate(_animationController);
    _animationController.repeat();
  }

  Widget _getText(int value) => Container(
      color: Colors.yellow,
      padding: EdgeInsets.all(6),
      child: Text(
        value.toString(),
        style: TextStyle(fontSize: 20),
      ));
}
