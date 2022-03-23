import 'package:flutter/material.dart';

import 'ruler.dart';

main() {
  runApp(MaterialApp(
    title: 'ruler demo',
    home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        appBar: AppBar(title: Text('ruler demo')),
        body: Center(
          child: new RulerWidget(),
        ),
      );
    }),
  ));
}

class RulerWidget extends StatelessWidget {
  const RulerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Ruler(
        height: 80,
        minValue: 20,
        middleValue: 50,
        unit: 'kg',
        showScaleNum: 41,
        unitScale: 0.1,
        showHL: true,
        maxValue: 200,
        onSelectedValue: (BuildContext context, double value) {},
      ),
    );
  }
}
