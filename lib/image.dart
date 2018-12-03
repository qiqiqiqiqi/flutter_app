import 'package:flutter/material.dart';

main() {
  runApp(new MyImage());
}

class MyImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    return new MaterialApp(
//        title: "image demo",
//        home: new Scaffold(
//            appBar: new AppBar(title: new Text("image demo")),
//            body: new Scaffold(
//                body: new Image.asset('images/ic_img_default.jpg',
//                    width: 200.0, height: 200.0, fit: BoxFit.cover))));

//    return new MaterialApp(
//        title: "image demo",
//        home: new Scaffold(
//            appBar: new AppBar(title: new Text("image demo")),
//            body: new Center(
//                child: new Image.network(
//                    "http://b4-q.mafengwo.net/s10/M00/71/C2/wKgBZ1nzSGCATKvzAAnDbPoNe5Y64.jpeg",
//                    width: 200.0,
//                    height: 200.0,fit: BoxFit.fitWidth,))));
//    return new MaterialApp(
//        title: "image demo",
//        home: new Scaffold(
//            appBar: new AppBar(title: new Text("image demo")),
//            body: new Scaffold(
//                body: new Container(
//              constraints: BoxConstraints.expand(
//                height:
//                    Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
//              ),
//              padding: const EdgeInsets.all(8.0),
//              color: Colors.teal.shade700,
//              alignment: Alignment.center,
//              child: Text('Hello World',
//                  style: Theme.of(context)
//                      .textTheme
//                      .display1
//                      .copyWith(color: Colors.white)),
//              foregroundDecoration: BoxDecoration(
//                image: DecorationImage(
//                  image: NetworkImage(
//                      "http://b4-q.mafengwo.net/s10/M00/71/C2/wKgBZ1nzSGCATKvzAAnDbPoNe5Y64.jpeg"),
//                  centerSlice: Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
//                ),
//              ),
//              transform: Matrix4.rotationZ(0.0),
//            ))));
    return new MaterialApp(
        title: "image demo",
        home: new Scaffold(
          appBar: new AppBar(title: new Text("image demo")),
          body: new Center(
            child: new Container(
              constraints: new BoxConstraints.expand(//添加到child上额外的约束条件。
                height:
                    Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
              ),
              decoration: new BoxDecoration(//绘制在child后面的装饰，设置了decoration的话，就不能设置color属性，否则会报错，此时应该在decoration中进行颜色的设置。
                border: new Border.all(width: 2.0, color: Colors.red),
                color: Colors.grey,
                borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                image: new DecorationImage(
                  image: new NetworkImage(
                      'http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg'),
                  centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                ),
              ),
              padding: const EdgeInsets.all(8.0),//decoration内部的空白区域，如果有child的话，child位于padding内部。padding与margin的不同之处在于，padding是包含在content内，而margin则是外部边界，设置点击事件的话，padding区域会响应，而margin区域不会响应
              alignment: Alignment.center,//控制child的对齐方式，如果container或者container父节点尺寸大于child的尺寸，这个属性设置会起作用，有很多种对齐方式。
              child: new Text('Hello World',
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .copyWith(color: Colors.black)),
              transform: new Matrix4.rotationZ(0.0),//设置container的变换矩阵，类型为Matrix4。
              margin: EdgeInsets.all(16.0),
            ),
          ),
        ));
  }
}
