import 'package:flutter/material.dart';
import 'package:flutter_app/custom/tree/treeWidget.dart';
import 'custom/bezier/bezierwavedemo.dart';
import 'custom/calendar/calendardemo.dart';
import 'custom/chart/chartdemo.dart';
import 'package:flutter_app/custom/citypicker/address_select_page.dart';
import 'package:flutter_app/custom/citypicker/address_dialog.dart';
import 'package:flutter_app/custom/citypicker/address_add_page.dart';

import 'custom/circularseekbar/circularseekbardemo.dart';
import 'custom/ruler/ruler/ruler.dart';

//main() => runApp(new MainApp());
main() {
  return runApp(MaterialApp(
    title: 'ruler demo',
    home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        /* appBar: AppBar(title: Text('ruler demo')),*/
        body: Center(
          child: MyStatefulWidget(),
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
  Map<String, Widget> itemWidgets = {
    'bezier': BezierWaveDemo(),
    '日历': CalendarDemo(),
    '图表': ChartDemo(),
    'seekBar': CircularSeekBarApp(),
    '地址选择器': AddresAddPage(),
    '梦幻树': TreeWidget(),
  };

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
        body: Container(
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return itemWidgets.values.toList()[index];
                    }));
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${itemWidgets.keys.toList()[index]}',
                      style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 1,
                  color: Colors.grey,
                );
              },
              itemCount: itemWidgets.keys.length),
        ),
      ),
    );
  }
}
