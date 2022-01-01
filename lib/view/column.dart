// import 'package:baidumapplugin/widgets/native/baidu_map_platform_view.dart';
// import 'package:baidumapplugin/widgets/native/base_platfrom_view.dart';
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
