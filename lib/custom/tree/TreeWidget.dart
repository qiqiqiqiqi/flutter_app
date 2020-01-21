import 'package:flutter/material.dart';
import 'TreePainter.dart';

main() {
  runApp(MaterialApp(
    title: "TreeWidget Demo",
    home: Scaffold(
      appBar: AppBar(
        title: Text("TreeWidget Demo"),
      ),
      body: TreeWidget(),
    ),
  ));
}

class TreeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TreeWidgetState();
  }
}

class TreeWidgetState extends State {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        width: constraints.biggest.width,
        height: constraints.biggest.height,
        color: Colors.black,
        child: CustomPaint(
          painter: TreePainter(color: Colors.white),
        ),
      );
    });
  }
}
