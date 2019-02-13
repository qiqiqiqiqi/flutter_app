import 'package:flutter/material.dart';

main() {
  runApp(new RowApp());
}

class RowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "row demo",
      home: Scaffold(
        appBar: AppBar(
          title: new Text("row demo"),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(//能够灵活的布局，相当android的权重
                child: RaisedButton(
              onPressed: () {},
              child: new Text("row 1"),
              color: Colors.lightBlue,
            )),
            RaisedButton(
              onPressed: () {},
              child: new Text("row 2"),
              color: Colors.lightGreen,
            ),
            RaisedButton(
              onPressed: () {},
              child: new Text("row 3"),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
