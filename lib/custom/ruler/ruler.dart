import 'package:flutter/material.dart';
import 'ruler_painter.dart';

class Ruler extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RulerState();
  }
}

class RulerState extends State<Ruler> with TickerProviderStateMixin {
  Offset velocity;
  AnimationController _animationController;
  double translationX = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    Animation curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    curvedAnimation.addListener(() {
      setState(() {
        translationX = velocity.dx * curvedAnimation.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        color: Colors.redAccent,
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              translationX += details.delta.dx;
              print('RulerState--build()--onPanUpdate():offsetX=$translationX');
            });
          },
          onPanEnd: (DragEndDetails details) {
            velocity = details.velocity.pixelsPerSecond;
            if (velocity.dx > 0) {
              _animationController.forward(from: 0);
            }
            print(
                'RulerState--build()--onPanEnd():details.velocity.pixelsPerSecond=${details.velocity.pixelsPerSecond}');
          },
          child: CustomPaint(
            size: Size(constraints.maxWidth, 80),
            painter: RulerPainter(
                minValue: 0,
                middleValue: 12,
                maxValue: 20,
                translationX: translationX),
          ),
        ),
      );
    });
  }
}
