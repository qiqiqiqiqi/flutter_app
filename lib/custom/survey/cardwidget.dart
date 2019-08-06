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
  static double maxOffsetY = 16;
  double baseScale = 0.05;
  double offsetY = maxOffsetY;
  double offsetX = 0;
  double scale = 1;
  double rotate = 0;

  @override
  void initState() {
    super.initState();
  }

  void caculateOffsetY(double radio) {
    if (widget.position > 0) {
      if (widget.position == 3) {
        scale = 1 - (widget.position - 1) * baseScale;
        offsetY = maxOffsetY * (widget.position - 1);
      } else {
        scale = 1 - widget.position * baseScale + baseScale * (radio.abs());
        offsetY = maxOffsetY * widget.position - maxOffsetY * (radio.abs());
      }
    } else {
      offsetY = widget.offset.dy;
      offsetX = widget.offset.dx;
    }
    print(
        "caculate:offsetY =$offsetY,offsetX=$offsetX,widget.position=${widget.position},"
        "widget.offset=${widget.offset},radio=$radio");
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      print("LayoutBuilder:constrains.maxWidth=${constrains.maxWidth},"
          "constrains..constrainWidth()=${constrains..constrainWidth()}");
      double radioY = 0;
      double radioX = 0;
      if (widget.offset.dy.abs() > widget.offset.dx.abs()) {
        radioY = (widget.offset.dy.abs() > constrains.maxHeight / 2
                ? (widget.offset.dy > 0
                    ? constrains.maxHeight / 2
                    : -constrains.maxHeight / 2)
                : widget.offset.dy) /
            (constrains.maxHeight / 2);
        radioX = caculateRadioX(constrains);
        rotate = (widget.position != 0 ? 0.0 : Math.pi / 6 * radioX);
      } else {
        radioY = radioX = caculateRadioX(constrains);
        rotate = (widget.position != 0 ? 0.0 : Math.pi / 6 * radioX);
      }
      caculateOffsetY(radioY);
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
                      child: AspectRatio(
                        aspectRatio: 0.65,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color(0xFFCCD1D4),
                                    offset: Offset(0, 4),
                                    blurRadius: 15)
                              ]),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text('${widget.position}'),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ));
    });
  }

  double caculateRadioX(BoxConstraints constrains) {
    return (widget.offset.dx.abs() > constrains.maxWidth / 2
              ? (widget.offset.dx > 0
                  ? constrains.maxWidth / 2
                  : -constrains.maxWidth / 2)
              : widget.offset.dx) /
          (constrains.maxWidth / 2);
  }
}
