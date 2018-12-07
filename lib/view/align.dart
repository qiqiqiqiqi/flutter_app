import 'package:flutter/material.dart';

///https://www.jianshu.com/p/06259a762c8b
main() {
  runApp(new AlignApp());
}

class AlignApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "align demo",
      home: new Scaffold(
        appBar: new AppBar(title: new Text("align demo")),
        body: new Container(
          color: Colors.red,
          child: new Align(
            alignment:const Alignment(1, 1/3),
            widthFactor: 3.0,
            heightFactor:4.0,
            child: new Container(
                color: Colors.blue, child: new Text("align text")),
          ),
        ),
      ),
    );
  }
}
