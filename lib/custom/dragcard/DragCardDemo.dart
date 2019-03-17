import 'package:flutter/material.dart';
import 'PullDragContainer.dart';
import 'DragCardContentContainer.dart';
import 'package:flutter_app/view/listview.dart';
main() {
  runApp(MaterialApp(
    home: DragCardDemo(),
  ));
}

class DragCardDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DragCardState();
  }
}

class DragCardState extends State<DragCardDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("DragCard Demo"),
        ),
        body: PullDragContiner(
          headWidget: Container(
            color: Colors.cyan,
            child: Center(
              child: Text("head"),
            ),
          ),
          contentWidget: PullContentContainer(),
        ));
  }
}
