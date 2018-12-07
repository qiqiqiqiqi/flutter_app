import 'package:flutter/material.dart';

main() {
  runApp(new MaterialApp(title: "Padding Demo", home: new PaddingApp()));
}

class PaddingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(title: new Text("Padding Demo")),
        body: new Card(
            margin: EdgeInsets.all(8),
            color: Colors.green,
            child: new Container(
                constraints: new BoxConstraints.expand(width: double.infinity),
                alignment: Alignment.topCenter,
                color: Colors.red,
                margin: EdgeInsets.all(8),
                child: new Wrap(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.fromLTRB(16, 32, 26, 32),
                      child: new Container(
                          child: new Text(
                            "cardcardcardcardcardcardcardcardcardcardcardcardcar"
                                "dcardcardcardcardcardcardcardcardcardcardcardcar"
                                "dcardcardcardcardcardcardcardcardcardcardcardcar"
                                "dcardcardcardcardcardcardcardcardcardcardcardcard"
                                "cardcardcardcardcardcardcardcardcardcardcardcardca",
                            textDirection: TextDirection.ltr,
                            style: new TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          ),
                          color: Colors.amberAccent),
                    ),
                    new Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 26, 32),
                      child: new Text(
                        "cardcardcardcardcardcardcardcardcardcardcardcardcar"
                            "dcardcardcardcardcardcardcardcardcardcardcardcar"
                            "dcardcardcardcardcardcardcardcardcardcardcardcar"
                            "dcardcardcardcardcardcardcardcardcardcardcardcard"
                            "cardcardcardcardcardcardcardcardcardcardcardcardca",
                        textDirection: TextDirection.ltr,
                        style: new TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 26, 32),
                      child: new Text(
                        "cardcardcardcardcardcardcardcardcardcardcardcardcar"
                            "dcardcardcardcardcardcardcardcardcardcardcardcar"
                            "dcardcardcardcardcardcardcardcardcardcardcardcar"
                            "dcardcardcardcardcardcardcardcardcardcardcardcard"
                            "cardcardcardcardcardcardcardcardcardcardcardcardca",
                        textDirection: TextDirection.ltr,
                        style: new TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ))));
  }
}
