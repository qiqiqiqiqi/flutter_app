import 'package:flutter/material.dart';
import 'ruler.dart';

main() {
  runApp(MaterialApp(
    title: 'ruler demo',
    home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        appBar: AppBar(title: Text('ruler demo')),
        body: Ruler(
          width: constraints.maxWidth,
          minValue: 3,
          maxValue: 300,
          height: 80,
        ),
      );
    }),
  ));
}
