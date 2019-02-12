import 'package:flutter/material.dart';

/**
 * fit属性可以控制图片的拉伸和挤压，这些都是根据图片的父级容器来的，我们先来看看这些属性（建议此部分组好看视频理解）。
 *
    BoxFit.fill:全图显示，图片会被拉伸，并充满父容器。

    BoxFit.contain:全图显示，显示原比例，尽可能大，同时仍将源完全包含在目标框中,可小可大。

    BoxFit.cover：显示可能拉伸，可能裁切，充满（图片要充满整个容器，还不变形）。

    BoxFit.fitWidth：宽度充满（横向充满），显示可能拉伸，可能裁切。

    BoxFit.fitHeight ：高度充满（竖向充满）,显示可能拉伸，可能裁切。

    BoxFit.scaleDown：效果和contain差不多，但是此属性不允许显示超过源图片大小，可小不可大。
 */
main() => runApp(new ImageApp());

class ImageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "image demo",
      home: Scaffold(
        appBar: new AppBar(title: new Text("image demo")),
        body: new Center(
            child: new Container(
          //alignment: Alignment.center,//该属性导致child中的fit设置无效
          child: new Image.network(
            "http://jspang.com/static/myimg/blogtouxiang.jpg",
            fit: BoxFit.scaleDown,
            repeat: ImageRepeat.repeat,
          ),
          width: 300.0,
          height: 200.0,
          color: Colors.lightBlue,
        )),
      ),
    );
  }
}
