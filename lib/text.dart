import 'package:flutter/material.dart';

main() => runApp(new MaterialApp(
      title: "text demo",
      home: new Scaffold(
        appBar: new AppBar(
            title: Text.rich(
          TextSpan(
            text: 'Hello', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: ' beautiful ',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.green)),
              TextSpan(
                  text: 'world',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
            ],
          ),
        )),
        body: new Center(
          child: new Text("test style,test style,test style,test style",
              style: new TextStyle(
                color: Colors.red,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                //字体加粗
                fontStyle: FontStyle.italic,
                //斜体
                decoration: new TextDecoration.combine([
                  TextDecoration.underline, //文本加下划线
                  TextDecoration.overline, //文本加上划线
                  TextDecoration.lineThrough //文本加中划线
                ]),
              ),
              maxLines: 5,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              overflow: //TextOverflow.ellipsis,//显示不下的内容以...显示
                  //TextOverflow.fade
                  TextOverflow.clip),
        ),
      ),
    ));
