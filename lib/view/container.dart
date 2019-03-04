import 'package:flutter/material.dart';

///Container的源码本身并不复杂，复杂的是它的各种布局表现。我们谨记住一点，如果内部不设置约束，
/// 则按照父节点尽可能的扩大，如果内部有约束，则按照内部来。
///
/// 如果没有子节点、没有设置width、height以及constraints，并且父节点没有设置unbounded的限制，Container会将自身调整到足够小。
///如果没有子节点、对齐方式（alignment），但是提供了width、height或者constraints，那么Container会根据自身以及父节点的限制，将自身调节到足够小。
///如果没有子节点、width、height、constraints以及alignment，但是父节点提供了bounded限制，那么Container会按照父节点的限制，将自身调整到足够大。
///如果有alignment，父节点提供了unbounded限制，那么Container将会调节自身尺寸来包住child；
///如果有alignment，并且父节点提供了bounded限制，那么Container会将自身调整的足够大（在父节点的范围内），然后将child根据alignment调整位置；
///含有child，但是没有width、height、constraints以及alignment，Container会将父节点的constraints传递给child，并且根据child调整自身。
///链接：https://www.jianshu.com/p/366b2446eaab

main() {
  runApp(new MyImage());
}

class MyImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "image demo",
        home: new Scaffold(
          appBar: new AppBar(title: new Text("image demo")),
          body: new ContainerLayout(),
        ));
  }
}

class ContainerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Wrap(
      children: <Widget>[
        new Container(
          constraints: new BoxConstraints.expand(
            //添加到child上额外的约束条件。
            width: double.infinity,
            height: Theme.of(context).textTheme.display1.fontSize * 1.0 + 200.0,
          ),
          decoration: new BoxDecoration(
            //绘制在child后面的装饰，设置了decoration的话，就不能设置color属性，否则会报错，此时应该在decoration中进行颜色的设置。
            border: new Border.all(width: 2.0, color: Colors.red),
            color: Colors.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
            image: new DecorationImage(
              image: new NetworkImage(
                  'http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign='
                      '0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg'),
              centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
            ),
          ),
          padding: const EdgeInsets.all(8.0),
          //decoration内部的空白区域，如果有child的话，child位于padding内部。padding与margin的不同之处在于，padding是包含在content内，而margin则是外部边界，设置点击事件的话，padding区域会响应，而margin区域不会响应
          alignment: Alignment.center,
          //控制child的对齐方式，如果container或者container父节点尺寸大于child的尺寸，这个属性设置会起作用，有很多种对齐方式。
          child: new Text('Hello World',
              textDirection: TextDirection.ltr,
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(color: Colors.black)),
          transform: new Matrix4.rotationZ(0.0),
          //设置container的变换矩阵，类型为Matrix4。
          margin: EdgeInsets.all(16.0),
        ),
        new StatefulRoundButton(
            width: double.infinity,
            height: 50.0,
            margin: EdgeInsets.all(16),
            child: new Text("click me"),
            disable: false,
            borderColor: Colors.blue,
            onPress: () {
              final snackBar = new SnackBar(content: new Text("click me"));
              Scaffold.of(context).showSnackBar(snackBar);
            }),
        new StatefulRoundButton(
            width: double.infinity,
            height: 50.0,
            child: new Text("click me"),
            disable: true,
            margin: EdgeInsets.all(16),
            borderColor: StatefulRoundButton.defaultDisableBackgroundColor,
            onPress: () {
              final snackBar = new SnackBar(content: new Text("click me"));
              Scaffold.of(context).showSnackBar(snackBar);
            }),
        new StatefulRoundButton(
            width: double.infinity,
            height: 50.0,
            child: new Text("click me"),
            disable: false,
            margin: EdgeInsets.all(16),
            normalBackgroundColor: Colors.blue,
            pressBackgroundColor: Colors.blueAccent,
            borderColor: StatefulRoundButton.defaultDisableBackgroundColor,
            onPress: () {
              final snackBar = new SnackBar(content: new Text("click me"));
              Scaffold.of(context).showSnackBar(snackBar);
            })
      ],
    );
  }
}

class StatefulRoundButton extends StatefulWidget {
  static const Color defaultNormalBackgroundColor = Colors.redAccent;
  static const Color defaultPressBackgroundColor = const Color(0x33FF0000);
  static const Color defaultDisableBackgroundColor = Colors.grey;
  Color background,
      normalBackgroundColor,
      pressBackgroundColor,
      disableBackgroundColor,
      borderColor;
  double width, height;
  bool disable;
  VoidCallback onPress;
  Widget child;
  EdgeInsets margin;

  @override
  State<StatefulWidget> createState() {
    //StatefulWidget在createState()创建一个State后会把StatefulWidget的引用赋值给State的_widget私有变量
    return new StatefulRoundButtonState();
  }

  StatefulRoundButton(
      {this.width,
      this.height,
      this.child,
      this.borderColor,
      this.margin,
      this.normalBackgroundColor = defaultNormalBackgroundColor,
      this.pressBackgroundColor = defaultPressBackgroundColor,
      this.disableBackgroundColor = defaultDisableBackgroundColor,
      this.disable,
      this.onPress})
      : background = defaultNormalBackgroundColor;
}

class StatefulRoundButtonState extends State<StatefulRoundButton> {
  @override
  void initState() {
    super.initState();
    if (widget.disable) {
      widget.background = widget.disableBackgroundColor;
    } else {
      widget.background = widget.normalBackgroundColor;
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.background = widget.normalBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        if (widget.onPress != null && !widget.disable) {
          widget.onPress();
        }
      },
      onTapDown: (TapDownDetails tapDownDetails) {
        if (!widget.disable) {
          setState(() {
            widget.background = widget.pressBackgroundColor;
          });
        }
      },
      onTapUp: (TapUpDetails tapUpDetails) {
        if (!widget.disable) {
          setState(() {
            widget.background = widget.normalBackgroundColor;
          });
        }
      },
      onTapCancel: () {
        if (!widget.disable) {
          setState(() {
            widget.background = widget.normalBackgroundColor;
          });
        }
      },
      child: new Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: widget.background,
            border: new Border.all(
                color: widget.borderColor,
                width: 2.0,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(widget.height / 2))),
        child: widget.child,
      ),
    );
  }
}
