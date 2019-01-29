import 'package:flutter/material.dart';

///Container的child的宽高设置成大于Container的宽高,最终child的宽高不会超过Container宽高的范围
///AspectRatio child按比例计算好宽高后如果宽高的值超出父控件的的范围后(宽度优先)会根据自身的比例缩放
///
///AspectRatio的宽高如果都不超过父view的宽高，则AspectRatio的宽高的最大值为设置的具体值，AspectRatio的width初始为宽度的最大值，
///然后根据AspectRatio的aspectRatio宽高比例系数初始化AspectRatio的height；然后按照maxWidth<--maxHeight<--minWidth<--minHeight的从高到低的优先级
///与AspectRatio的宽高进行比较再次计算AspectRatio的宽高（最终AspectRatio的宽高之比还是aspectRatio的值）
main() {
  runApp(new AspectRatioApp());
}

class AspectRatioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "aspectratio demo",
      home: new Scaffold(
          appBar: new AppBar(title: new Text("aspectRatio demo")),
          body: new Container(
              alignment: Alignment.center,
              width: 200,
              height: 200,
              color: Colors.indigoAccent,
              child: new Container(
                  alignment: Alignment.center,
                  width: 100, //AspectRatio的maxWidth=100，maxHeight=200
                  child: new AspectRatio(
                      aspectRatio: 0.51, //宽高比0.51的
                      child: Container(
                          color: Colors.redAccent,
                          child: new Image.asset("images/ic_img_default.jpg",
                              fit: BoxFit.fitWidth)))))),
    );
  }
}
