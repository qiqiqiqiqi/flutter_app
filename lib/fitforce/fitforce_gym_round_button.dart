import 'package:flutter/material.dart';

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
  double raduis;
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
      this.raduis,
      this.borderColor,
      this.margin,
      this.normalBackgroundColor = defaultNormalBackgroundColor,
      this.pressBackgroundColor = defaultPressBackgroundColor,
      this.disableBackgroundColor = defaultDisableBackgroundColor,
      this.disable,
      this.onPress})
      : background = normalBackgroundColor;
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
                width: 0.5,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(widget.raduis))),
        child: widget.child,
      ),
    );
  }
}
