import 'package:flutter/material.dart';

class PullDragContiner extends StatefulWidget {
  Widget headWidget, contentWidget;
  double offsetY;

  PullDragContiner({this.headWidget, this.contentWidget});

  @override
  State<StatefulWidget> createState() {
    return PullDragState();
  }
}

class PullDragState extends State<PullDragContiner> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            top: null,
            height: 200,
            bottom: widget.offsetY,
            left: 0,
            right: 0,
            child: widget.headWidget),
        Positioned(
            bottom: -widget.offsetY,
            top: widget.offsetY,
            left: 0,
            right: 0,
            child: widget.contentWidget)
      ],
    );
  }
}
