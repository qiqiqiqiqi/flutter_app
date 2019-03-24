import 'package:flutter/material.dart';
import 'PullContainer.dart';
import 'DragCardContentContainer.dart';
import 'pullHeadContainer.dart';

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
          //todo 把refresh...方法移出
          headWidget: PullHeadContainer(),
          contentWidget: PullContentContainer(),
        ));
  }
}
