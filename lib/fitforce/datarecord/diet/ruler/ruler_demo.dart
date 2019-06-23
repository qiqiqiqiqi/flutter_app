import 'package:flutter/material.dart';
import 'ruler_text.dart';

main() {
  runApp(MaterialApp(
    title: 'ruler demo',
    home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        appBar: AppBar(title: Text('ruler demo')),
        body: Center(
          child: Container(
            color: Colors.blueAccent,
            child: RulerText(
              width: constraints.maxWidth,
              minValue: 0,
              middleValue: 0,
              maxValue: 6,
              height: 80,
            ),
          ),
        ),
      );
    }),
  ));
}
