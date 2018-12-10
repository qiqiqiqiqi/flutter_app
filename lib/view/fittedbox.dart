import 'package:flutter/material.dart';

///1."BoxFit.contain是保持着child宽高比的大前提下，尽可能的填满，一般情况下，宽度或者高度达到最大值时，就会停止缩放"
///"(如果子view的宽高比小于父view的宽高比则子view的高度为父view的高度，此时表现为子view高度铺满父view的高度；"
///"同理如果子view的宽高比大于父view的宽高比则子view的长度为父view的长度，此时表现为子view长度铺满父view的长度)"
///2."BoxFit.fill"
main() {
  runApp(new FittedBoxApp());
}

class FittedBoxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "fittedbox demo",
      home: new Scaffold(
        appBar: new AppBar(title: new Text("fittedbox demo")),
        body: new Container(
          alignment: Alignment.center,
          width: 200.0,
          height: 100.0,
          color: Colors.indigoAccent,
          child: new FittedBox(
            alignment: Alignment.center,
            fit: BoxFit.fitHeight,
            child: new Container(
              alignment: Alignment.center,
              width: 400.0,
              height: 100.0,
              color: Colors.redAccent,
              child: new Text(
                "BoxFit.fill",
                style: new TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
