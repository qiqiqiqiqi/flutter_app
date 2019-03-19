import 'package:flutter/material.dart';

main() {
  runApp(new ConstrainedBoxApp());
}

class ConstrainedBoxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(body: new LayoutBuilder(
          builder: (BuildContext cotext, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: new ConstrainedBox(
            constraints:
                new BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: new IntrinsicHeight(
              child: new Column(
                children: <Widget>[
                  new Container(
                    color: Colors.yellow,
                    height: 120.0,
                  ),
                   new Container(
                    color: Colors.red,
                    height: 1650.0,
                  )
                ],
              ),
            ),
          ),
        );
      })),
    );
  }
}
