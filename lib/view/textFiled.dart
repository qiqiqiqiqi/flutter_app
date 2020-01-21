import 'package:flutter/material.dart';

main() => runApp(new MaterialApp(
      title: "textFiled demo",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("textFiled demo"),
        ),
        body: new Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: 36,
            child: TextField(
              maxLines: 1,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(0),
                  fillColor: Color(0xFFF2F4F5),
                  filled: true,
                  hintText: "请输入...",
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  )),
            ),
          ),
        ),
      ),
    ));
