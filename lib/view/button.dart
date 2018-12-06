import 'package:flutter/material.dart';

///Flutter提供了几种类型的按钮组件：RaisedButton FloatingActionButton FlatButton IconButton PopupMenuButton
main() {
  runApp(new ButtonApp());
}

class ButtonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "button demo",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("buttons demo"),
        ),
        body: new Column(
          children: <Widget>[
            new RaisedButton(
                child: new Text("RaisedButton Demo"),
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) =>
                      new AlertDialog(
                        title: new Text("title"),
                        content: new Text("content"),
                      ));
                }),
            new FloatingActionButton(
              onPressed: () {},
              child: new Icon(Icons.add),
            ),
            new FlatButton(
                onPressed: () {}, child: new Text("FlatButton Demo")),
            new IconButton(icon: new Icon(Icons.list), onPressed: () {}),
            new PopupMenuButton(
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<int>>[
                  new PopupMenuItem<int>(
                      child: new Text("menu0"), value: 0),
                  new PopupMenuItem<int>(
                      child: new Text("menu1"), value: 1),
                  new PopupMenuItem<int>(
                      child: new Text("menu2"), value: 2),
                  new PopupMenuItem<int>(
                      child: new Text("menu3"), value: 3),
                ],
                onSelected: (int positon) {
                  print("PopupMenuButton selected postion=$positon");
                }),
            new MyAlertDialog(),
            new MySimpleDialog()
          ],
        ),
      ),
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new RaisedButton(
        child: new Text("AlertDialog Demo"),
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) =>
              new AlertDialog(
                title: new Text("title"),
                content: new Text("content"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {}, child: new Text("confirm")),
                  new FlatButton(
                      onPressed: () {}, child: new Text("cancel")),
                  new FlatButton(onPressed: () {}, child: new Text("other"))
                ],
              ));
        });
  }
}

class MySimpleDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new RaisedButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) =>
              new SimpleDialog(
                  title: new Text("simple dialog title"),
                  contentPadding: const EdgeInsets.fromLTRB(
                      16.0, 12.0, 0.0, 16.0),
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new FlatButton(
                            onPressed: () {},
                            child: new Text("confirm",
                              style: new TextStyle(color: Colors.red))),
                        new FlatButton(
                            onPressed: () {},
                            child: new Text("cancel",
                              style: new TextStyle(color: Colors.blue)))
                      ],
                    )
                  ]));
        },
        child: new Text("SimpleDialog Demo"));
  }
}
