import 'package:flutter/material.dart';
import 'dart:math' as Math;

class DragCard extends StatefulWidget {
  int position;
  Offset offset = Offset(0, 0);

  DragCard({this.position, this.offset});

  @override
  State<StatefulWidget> createState() {
    return DragCardState();
  }
}

class DragCardState extends State<DragCard> {
  static double max_offsetY = 16;
  double baseScale = 0.05;
  double offsetY = max_offsetY;
  double offsetX = 0;
  double scale = 1;
  double rotate = 0;

  @override
  void initState() {
    super.initState();
  }

  void caculate(double radio) {
    if (widget.position > 0) {
      if (widget.position == 3) {
        scale = 1 - (widget.position - 1) * baseScale;
        offsetY = max_offsetY * (widget.position - 1);
      } else {
        scale = 1 - widget.position * baseScale + baseScale * (radio.abs());
        offsetY = max_offsetY * widget.position - max_offsetY * (radio.abs());
      }
    } else {
      offsetY = widget.offset.dy;
      offsetX = widget.offset.dx;
    }

    print(
        "caculate:offsetY =${offsetY},offsetX=$offsetX,widget.position=${widget.position},"
        "widget.offset=${widget.offset},radio=$radio");
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      print("LayoutBuilder:constrains.maxWidth=${constrains.maxWidth},"
          "constrains..constrainWidth()=${constrains..constrainWidth()}");
      double radio = 0;
      if (widget.offset.dy.abs() > widget.offset.dx.abs()) {
        radio = (widget.offset.dy.abs() > constrains.maxHeight / 2
                ? (widget.offset.dy > 0
                    ? constrains.maxHeight / 2
                    : -constrains.maxHeight / 2)
                : widget.offset.dy) /
            (constrains.maxHeight / 2);
        //todo
        double radioX = (widget.offset.dx.abs() > constrains.maxWidth / 2
                ? (widget.offset.dx > 0
                    ? constrains.maxWidth / 2
                    : -constrains.maxWidth / 2)
                : widget.offset.dx) /
            (constrains.maxWidth / 2);
        rotate = (widget.position != 0 ? 0.0 : Math.pi / 6 * radioX);
      } else {
        radio = (widget.offset.dx.abs() > constrains.maxWidth / 2
                ? (widget.offset.dx > 0
                    ? constrains.maxWidth / 2
                    : -constrains.maxWidth / 2)
                : widget.offset.dx) /
            (constrains.maxWidth / 2);
        rotate = (widget.position != 0 ? 0.0 : Math.pi / 6 * radio);
      }
      caculate(radio);
      return Transform(
          transform: Matrix4.translationValues(offsetX, offsetY, 0),
          child: Transform.scale(
            scale: scale,
            child: Transform.rotate(
              alignment: Alignment.center,
              angle: rotate,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      left: 20,
                      right: 20,
                      top: 20,
                      child: Card(
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        color: Colors.cyanAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: AspectRatio(
                          aspectRatio: 0.75,
                          child: Image.network(
                            'http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ));
    });
  }
}
