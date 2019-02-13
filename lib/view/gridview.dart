import 'package:flutter/material.dart';

main() {

  runApp(new GridViewApp(items: <String>['http://img5.mtime.cn/mt/2018/10/22/104316.77318635_180X260X4.jpg',
  'http://img5.mtime.cn/mt/2018/10/22/104316.77318635_180X260X4.jpg',
  'http://img5.mtime.cn/mt/2018/10/22/104316.77318635_180X260X4.jpg',
  'http://img5.mtime.cn/mt/2018/10/22/104316.77318635_180X260X4.jpg',
  'http://img5.mtime.cn/mt/2018/10/22/104316.77318635_180X260X4.jpg',
 ]));
}

class GridViewApp extends StatelessWidget {
  List<String> items;
  GridViewApp({Key key, @required this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        title: "gridview demo",
        home: Scaffold(
            appBar: new AppBar(title: new Text("gridview demo")),
            body: GridView.builder(
              itemCount: items.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 2.0,
                  crossAxisCount: 3,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7),
              itemBuilder: (BuildContext context, int index) {
                return new Image.network("${items[index]}",fit: BoxFit.cover,);
              },
            )));
  }
}
