import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  ///
  /// Causes each Layer to paint a box around its bounds.
  ///
  debugPaintLayerBordersEnabled = true;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///
            /// trigger to repaint all painting layer
            ///
            OutlinedButton(
              onPressed: () {},
              child: Text(
                'Press me',
                textDirection: TextDirection.ltr,
              ),
            ),

            //// uncomment this
            ///
            /// CircularProgressIndicator(),
            ///
            RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.redAccent,
                      width: 200,
                      height: 100,
                      alignment: Alignment.center,
                      child: CustomPaint(
                        painter: MyCustomPainter(),
                        child: Text(
                          'Center',
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.orangeAccent,
                      width: 200,
                      height: 100,
                      alignment: Alignment.center,
                      child: CustomPaint(
                        painter: MyCustomPainter(),
                        child: Text(
                          'Center',
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///
            /// custom painter without repaint boundary
            ///
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.transparent,
                width: 200,
                height: 100,
                alignment: Alignment.center,
                child: CustomPaint(
                  painter: MyOutOfRepaintBoundaryCustomPainter(),
                  child: Text(
                    'Center',
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print('painting logic');
    canvas.clipRect(Offset.zero & size);
    canvas.drawColor(Colors.blueAccent, BlendMode.srcOver);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MyOutOfRepaintBoundaryCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print('out of repaint boundary painting logic');
    canvas.clipRect(Offset.zero & size);
    canvas.drawColor(Colors.blueAccent, BlendMode.srcOver);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
