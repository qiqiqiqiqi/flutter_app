import 'package:flutter/material.dart';

main() => runApp(
    new ListviewApp(items: new List<String>.generate(100, (i) => "Item $i")));

class ListviewApp extends StatelessWidget {
  List<String> items;
  ListviewApp({Key key, @required this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ScrollController scrollController=ScrollController();
    return new MaterialApp(
        title: "listview demo",
        home: Scaffold(
          appBar: new AppBar(
            title: new Text("listview demo"),
          ),
          body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                print("ListviewApp():index=$index");
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: new Text("${items[index]}"),
                      leading: new Icon(Icons.add_box),
                      subtitle: new Text("${items[index]}"),
                      isThreeLine: false,
                      trailing: new Icon(Icons.arrow_right),
                      onTap: () {},
                    ),
                    new Divider(
                      height: 1,
                      color: Colors.orangeAccent,
                    )
                  ],
                );
              }),
        ));
  }
}
