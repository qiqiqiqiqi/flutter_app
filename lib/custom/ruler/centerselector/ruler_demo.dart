import 'package:flutter/material.dart';
import 'center_selector_widget.dart';
import 'ruler.dart';

main() {
  runApp(MaterialApp(
    title: 'ruler demo',
    home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        appBar: AppBar(title: Text('ruler demo')),
        body: Center(
          child: RulerWidget(),
        ),
      );
    }),
  ));
}

class RulerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RulerWidgetState();
  }
}

class RulerWidgetState extends State<RulerWidget> {
  int minValue = 20;
  double middleValue = 50;
  int maxValue = 200;
  double unitScale = 1;
  int showScaleNum = 9;
  List<String> contents = [
    '克',
    '只',
    '只只',
    '只只只',
    '只只',
    '只只只',
    '只只',
    '克',
    '只',
    '只只',
    '只只只',
    '只只',
    '只只只',
    '只只'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Ruler(
            height: 80,
            minValue: minValue,
            middleValue: middleValue,
            unit: 'kg',
            showScaleNum: showScaleNum,
            unitScale: unitScale,
            showHL: false,
            maxValue: maxValue,
            onSelectedValue: (BuildContext context, double value) {
              print('onSelectedValue():vlaue=$value');
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      if (showScaleNum != 9) {
                        unitScale = 1;
                        showScaleNum = 9;
                        minValue = 20;
                        maxValue = 200;
                        middleValue = 50;
                      } else {
                        unitScale = 0.1;
                        showScaleNum = 61;
                        minValue = 20;
                        maxValue = 200;
                        middleValue = 50;
                      }
                    });
                  },
                  child: Text('showScaleNum'),
                )),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      if (middleValue != 50) {
                        unitScale = 1;
                        showScaleNum = 9;
                        minValue = 20;
                        maxValue = 200;
                        middleValue = 50;
                      } else {
                        unitScale = 0.1;
                        showScaleNum = 61;
                        minValue = 20;
                        maxValue = 200;
                        middleValue = 21.4;
                      }
                    });
                  },
                  child: Text('middleValue'),
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      if (minValue != 9) {
                        unitScale = 1;
                        showScaleNum = 9;
                        minValue = 9;
                        maxValue = 200;
                        middleValue = 50;
                      } else {
                        unitScale = 1;
                        showScaleNum = 9;
                        minValue = 50;
                        maxValue = 200;
                        middleValue = 50;
                      }
                    });
                  },
                  child: Text('minValue'),
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      if (unitScale != 0.1) {
                        unitScale = 0.1;
                        showScaleNum = 61;
                        minValue = 20;
                        maxValue = 200;
                        middleValue = 50;
                      } else {
                        unitScale = 1;
                        showScaleNum = 9;
                        minValue = 20;
                        maxValue = 200;
                        middleValue = 50;
                      }
                    });
                  },
                  child: Text('unitScale'),
                ),
              ],
            ),
          ),
          CenterSelectorWidget(
            height: 80,
            minValue: 0,
            middleValue: 0,
            unit: '克',
            showScaleNum: 7,
            unitScale: 1,
            contents: contents,
            maxValue: contents.length - 1,
            onSelectedValue: (BuildContext context, double value) {
              print('onSelectedValue():vlaue=$value');
              setState(() {
                if (contents[value.toInt()] == '克') {
                  unitScale = 0.1;
                  showScaleNum = 61;
                  minValue = 0;
                  maxValue = 1000;
                  middleValue = 100;
                }else{
                  unitScale = 1;
                  showScaleNum = 9;
                  minValue = 0;
                  maxValue = 100;
                  middleValue = 1;
                }
              });

            },
          ),
        ],
      ),
    );
  }
}
