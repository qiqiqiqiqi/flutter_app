
import 'package:flutter/material.dart';

main() => runApp(new MaterialApp(
      title: "textFiled demo",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("textFiled demo"),
        ),
        body: new Padding(padding: EdgeInsets.all(8),
        child: new TextField(
          maxLines: 7,
          maxLength: 30,
          decoration: new InputDecoration(hintText: "请输入...",
          border: new OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),

          )),

        ),),
      ),
    ));
