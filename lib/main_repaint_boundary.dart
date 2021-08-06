import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

bool debugShowRepaintBoundaries = true;
void main() {
  ///
  /// Causes each Layer to paint a box around its bounds.
  ///
  debugPaintLayerBordersEnabled = true;
  debugRepaintRainbowEnabled = true;

  runApp(MyApp());
}

class RepaintBoundaryInfo extends StatelessWidget {
  final Widget child;
  final String description;
  const RepaintBoundaryInfo({Key? key, required this.child, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context is StatelessElement && debugShowRepaintBoundaries) {
      RenderObject? target = context.renderObject?.parent as RenderObject?;
      if (target != null) {
        while (!(target?.isRepaintBoundary ?? false)) {
          target = target?.parent as RenderObject?;
          if (target == null) break;
        }
      }
      return target != null
          ? Stack(
              children: [
                child,
                Container(
                  color: Colors.black,
                  child: Text(
                    target.hashCode.toString(),
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ],
            )
          : child;
    }

    return child;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RepaintBoundaryInfo(
          description: 'Center',
          child: Center(
            child: RepaintBoundaryInfo(
              description: 'Column',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RepaintBoundaryInfo(
                    description: 'Container',
                    child: Container(
                      width: 200,
                      height: 100,
                      color: Colors.green,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Simple Container',
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ),
                  RepaintBoundaryInfo(
                    description: 'PhysicalModel',
                    child: PhysicalModel(
                      color: Colors.transparent,
                      child: RepaintBoundaryInfo(
                        description: 'Physical Simple Text',
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Physical Simple Text',
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                    ),
                  ),
                  RepaintBoundaryInfo(
                    description: 'Simple Text',
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Simple Text',
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ),
                  Chip(
                    label: RepaintBoundaryInfo(
                      description: 'Chip',
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Chip',
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ),

                  ///
                  /// trigger to repaint all painting layer
                  ///
                  RepaintBoundaryInfo(
                    description: 'OutlinedButton',
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Press me',
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ),
                  // CircularProgressIndicator(),

                  //// uncomment this
                  ///
                  /// CircularProgressIndicator(),
                  ///
                  RepaintBoundaryInfo(
                    description: 'RepaintBoundary',
                    child: RepaintBoundary(
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
                              child: RepaintBoundaryInfo(
                                description: 'Painting  0',
                                child: SizedBox(
                                  width: 120,
                                  height: 40,
                                  child: CustomPaint(
                                    painter: MyCustomPainter(0),
                                    child: Center(
                                      child: Text(
                                        'Painting  0',
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.orangeAccent,
                              width: 200,
                              height: 100,
                              alignment: Alignment.center,
                              child: RepaintBoundaryInfo(
                                description: 'Painting  1',
                                child: SizedBox(
                                  width: 120,
                                  height: 40,
                                  child: CustomPaint(
                                    painter: MyCustomPainter(1),
                                    child: Center(
                                      child: Text(
                                        'Painting  1',
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ///
                  /// custom painter without repaint boundary
                  ///
                  PhysicalModel(
                    color: Colors.transparent,
                    child: Container(
                      color: Colors.transparent,
                      width: 200,
                      height: 100,
                      alignment: Alignment.center,
                      child: RepaintBoundaryInfo(
                        description: 'Painting  2',
                        child: SizedBox(
                          width: 120,
                          height: 40,
                          child: CustomPaint(
                            painter: MyCustomPainter(2),
                            child: Center(
                              child: Text(
                                'Painting  2',
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 200,
                    height: 100,
                    alignment: Alignment.center,
                    child: RepaintBoundaryInfo(
                      description: 'Painting  3',
                      child: SizedBox(
                        width: 120,
                        height: 40,
                        child: CustomPaint(
                          painter: MyCustomPainter(3),
                          child: Center(
                            child: Text(
                              'Painting  3',
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  final int index;

  MyCustomPainter(this.index);

  @override
  void paint(Canvas canvas, Size size) {
    print('painting logic $index');
    canvas.clipRect(Offset.zero & size);
    canvas.drawColor(Colors.blueAccent, BlendMode.srcOver);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
