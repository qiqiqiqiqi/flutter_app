import 'package:flutter/material.dart';
import 'ruler_painter.dart';

class Ruler extends StatefulWidget {
  double width;
  double height;

  Ruler({this.width, this.height});

  @override
  State<StatefulWidget> createState() {
    return RulerState();
  }
}

class RulerState extends State<Ruler> with TickerProviderStateMixin {
  Offset velocity;
  AnimationController _animationController;
  double translationX = 0.0;
  int minValue = 0;
  int middleValue = 12;
  int maxValue = 20;
  double unitScale = 0.5;
  double unitScaleLength;
  int scaleNum;
  double sumLength;
  double emptyLenth;
  int showScaleNum = 9;
  double offsetX = 0.0;

  @override
  void initState() {
    super.initState();

    scaleNum = (maxValue - minValue) ~/ unitScale;
    if (middleValue == null) {
      middleValue = (minValue + maxValue) ~/ 2;
    }
    unitScaleLength = (widget.width / (showScaleNum - 1));
    emptyLenth = widget.width / 2;
    sumLength = unitScaleLength * ((maxValue - minValue) / unitScale) +
        (showScaleNum - 1) * unitScaleLength; //另外加上一屏的空白宽度使两端能滑到中点
    offsetX = translationX +
        emptyLenth -
        (middleValue - minValue) * unitScaleLength * 2;

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    Animation curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    curvedAnimation.addListener(() {
      setState(() {
        translationX = velocity.dx * curvedAnimation.value;
        offsetX = translationX +
            emptyLenth -
            (middleValue - minValue) * unitScaleLength * 2;
        if (offsetX > emptyLenth) {
          offsetX = emptyLenth;
        }
        if (offsetX <=
            -(unitScaleLength * ((maxValue - minValue) / unitScale) -
                emptyLenth)) {
          offsetX = -(unitScaleLength * ((maxValue - minValue) / unitScale) -
              emptyLenth);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            translationX += details.delta.dx;
            offsetX = translationX +
                emptyLenth -
                (middleValue - minValue) * unitScaleLength * 2;
            if (offsetX > emptyLenth) {
              offsetX = emptyLenth;
            }
            if (offsetX <=
                -(unitScaleLength * ((maxValue - minValue) / unitScale) -
                    emptyLenth)) {
              offsetX =
                  -(unitScaleLength * ((maxValue - minValue) / unitScale) -
                      emptyLenth);
            }

            print('RulerState--build()--onPanUpdate():offsetX=$offsetX,details.delta=${details.delta}');
          });
        },
        onPanEnd: (DragEndDetails details) {
          velocity = details.velocity.pixelsPerSecond;
          if (velocity.dx.abs() > 0 &&
              offsetX >
                  -(unitScaleLength * ((maxValue - minValue) / unitScale) -
                      emptyLenth) &&
              offsetX < emptyLenth) {
            _animationController.forward(from: 0);
          }
          print(
              'RulerState--build()--onPanEnd():details.velocity.pixelsPerSecond=${details.velocity.pixelsPerSecond}');
        },
        child: CustomPaint(
          size: Size(widget.width, 80),
          painter: RulerPainter(
              unitScaleLength: unitScaleLength,
              offsetX: offsetX,
              scaleNum: scaleNum),
        ),
      ),
    );
  }
}
