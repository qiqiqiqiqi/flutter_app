import 'package:flutter/material.dart';
import 'single_selector_container.dart';

main() {
  runApp(MaterialApp(title: "citypicker demo", home: CityPickerDemo()));
}

class CityPickerDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CityPickerState();
  }
}

class CityPickerState extends State<CityPickerDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("citypicker demo"),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return RaisedButton(
            onPressed: () {
              _showModalBottomSheet(context);
              // _showBottomSheet(context);
            },
            child: Text('点击选择城市'),
          );
        }));
  }

  _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 200,
            child: Column(
              children: <Widget>[
                SingleSelectorContainer(),
                Expanded(child: ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                        child: Container(
                            alignment: Alignment.center,
                            height: 60.0,
                            child: Text('Item ${index + 1}')),
                        onTap: () {
                          print('tapped item ${index + 1}');
                       //   Navigator.pop(context);
                        });
                  },
                  itemCount: 10,
                ))
              ],
            ),
          ),
    );
  }

  _showBottomSheet(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) => Container(
            child: ListView(
                // 生成一个列表选择器
                children: List.generate(
              10,
              (index) => InkWell(
                  child: Container(
                      alignment: Alignment.center,
                      height: 60.0,
                      child: Text('Item ${index + 1}')),
                  onTap: () {
                    print('tapped item ${index + 1}');
                    //Navigator.pop(context);
                  }),
            )),
            height: 500,
          ),
    );
  }
}
