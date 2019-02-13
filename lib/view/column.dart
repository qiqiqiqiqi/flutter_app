import 'package:flutter/material.dart';

main() {
  runApp(new ColumnApp());
}

class ColumnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "column demo",
      home: new Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: new AppBar(title: new Text("column demo")),
        body: new Column(
          //Column同Row都是包裹内容的控件
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: new RaisedButton(
                onPressed: () {},
                color: Colors.redAccent,
                child: new Text("column 1"),
              ),
            ),
            Expanded(
                flex: 2,
                child: new RaisedButton(
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  onPressed: () {},
                  color: Colors.lightGreen,
                  child: new Text("column 2"),
                )),
            new RaisedButton(
              onPressed: () {},
              color: Colors.lightBlue,
              child: new Text("column 3"),
            ),
          ],
        ),
      ),
    );
  }
}
