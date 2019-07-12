import 'package:flutter/material.dart';
import 'custom/chart/chartdemo.dart';
import 'package:flutter_app/custom/citypicker/address_select_page.dart';
import 'package:flutter_app/custom/citypicker/address_dialog.dart';
import 'package:flutter_app/custom/citypicker/address_add_page.dart';

import 'custom/ruler/ruler/ruler.dart';

//main() => runApp(new MainApp());
main() {
  return runApp(MaterialApp(
    title: 'ruler demo',
    home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        appBar: AppBar(title: Text('ruler demo')),
        body: Center(
          child: Ruler(
            minValue: 20,
            maxValue: 20,
            width: constraints.maxWidth,
            height: 80,
          ),
        ),
      );
    }),
  ));
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "first flutter",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("first app"),
        ),
        body: new Center(
          child: new Text("first flutter demo"),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyStatefulWidgetfulState();
  }
}

class MyStatefulWidgetfulState extends State<MyStatefulWidget> {
  String text = "点击切换1";

  changeText() {
    if (text == "点击切换1") {
      setState(() {
        text = "点击切换2";
      });
    } else {
      setState(() {
        text = "点击切换1";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "first stateful flutter",
      theme: new ThemeData(primaryColor: const Color(0xffff0000)),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "first stateful flutter",
            style: new TextStyle(color: Colors.blue, fontSize: 20),
          ),
        ),
        body: new Center(
          child: new InkWell(
            child: new Padding(
              padding: new EdgeInsets.all(10),
              child: new Text(text,
                  style: new TextStyle(
                      color: const Color(0xffff00ff), fontSize: 30)),
            ),
            onTap: () {
              changeText();
            },
          ),
        ),
      ),
    );
  }
}
