import 'package:flutter/material.dart';

main() {
  runApp(StackApp());
}

class StackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "stack demo",
      home: Scaffold(
          appBar: new AppBar(title: new Text("stack demo")),
          body: new Column(
            children: <Widget>[
              new Center(
                  child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: 200.0,
                height: 200.0,
                color: Colors.lightBlue,
                child: new Stack(
                  alignment: AlignmentDirectional(1, 1),
                  children: <Widget>[
                    Opacity(
                      opacity: 0.9,
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        width: 150.0,
                        height: 150.0,
                        color: Colors.redAccent,
                      ),
                    ),
                    Opacity(
                      opacity: 0.8,
                      child: new Container(
                        width: 100,
                        height: 100,
                        color: Colors.lightGreen,
                      ),
                    )
                  ],
                ),
              )),
              new Center(
                child: new Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  width: double.infinity,
                  height: 200,
                  color: Colors.lightBlue,
                  child: new Stack(
                    children: <Widget>[
                      new Positioned(
                        child: new Opacity(
                            opacity: 0.9,
                            child: new Align(
                              alignment: Alignment.bottomCenter,
                              child: new Container(
                                  width: 150,
                                  height: 150,
                                  color: Colors.redAccent),
                            )),
                      ),
                      new Positioned(
                          right: 10,
                          bottom: 10,
                          child: new Opacity(
                            opacity: 0.8,
                            child: new Container(
                                width: 100,
                                height: 100,
                                color: Colors.lightGreen),
                          ))
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
