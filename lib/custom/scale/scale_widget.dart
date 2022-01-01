import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'draw_image_utils.dart';
import 'scale_painter.dart';

main() {
  runApp(MaterialApp(
    title: "Scale Demo",
    home: Scaffold(
      appBar: AppBar(
        title: Text("Scale Demo"),
      ),
      body: Center(
        child: ScaleWidget(),
      ),
    ),
  ));
}

class ScaleWidget extends StatefulWidget {
  final Widget mapImageProvider;
  final Widget pointImageProvider;

  ScaleWidget({this.mapImageProvider, this.pointImageProvider});

  @override
  State<StatefulWidget> createState() {
    return ScaleWidgetState();
  }
}

class ScaleWidgetState extends State<ScaleWidget> {
  double _zoom = 1;
  Offset _offset = Offset.zero;
  Offset _startingFocalPoint;
  Offset _previousOffset;
  double _previousZoom;

  @override
  void initState() {
    super.initState();
    _offset = Offset(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: FutureBuilder(
          future: DrawImageUtils.drawMergeImage(
              bgImageUrl:
                  'https://cti-device-resource-store-dev.oss-cn-shanghai.aliyuncs.com/RobotMapImages/2d/fefbe3417dfb3edb2dcebdb47a5c37d3.png',
              mergeImageUrl: 'images/icon_abnormal_position.png',
              offset: Offset(0, 0)),
          builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
            return GestureDetector(
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              child: CustomPaint(
                painter: ScalePainter(
                    image: snapshot.data, scale: _zoom, offset: _offset),
                size: Size(MediaQuery.of(context).size.width, 300),
              ),
            );
          }),
    );
  }

  void _handleScaleStart(ScaleStartDetails details) {
    setState(() {
      _startingFocalPoint = details.focalPoint;
      _previousOffset = _offset;
      _previousZoom = _zoom;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    print(
        'ScaleWidgetState--onScaleUpdate():details.scale=${details.scale},details.focalPoint=${details.focalPoint},details.localFocalPoint=${details.localFocalPoint}');
    setState(() {
      if (details.scale != 1) {
        _zoom = _previousZoom * details.scale;
      } else {
        _offset = _previousOffset + (details.focalPoint - _startingFocalPoint);
      }
    });
  }
}
