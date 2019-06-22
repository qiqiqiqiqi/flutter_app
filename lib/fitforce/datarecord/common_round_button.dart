import 'package:flutter/material.dart';

class StatefulRoundButton extends StatefulWidget {
  static const Color defaultNormalBackgroundColor = Colors.transparent;
  static const Color defaultPressBackgroundColor = Colors.transparent;
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
  EdgeInsets padding;

  @override
  State<StatefulWidget> createState() {
    //StatefulWidget在createState()创建一个State后会把StatefulWidget的引用赋值给State的_widget私有变量
    return new StatefulRoundButtonState();
  }

  StatefulRoundButton(
      {Key key,
      this.width,
      this.height,
      this.child,
      this.raduis = 0.0,
      this.borderColor = Colors.transparent,
      this.margin = const EdgeInsets.all(0.0),
      this.padding = const EdgeInsets.all(0.0),
      this.normalBackgroundColor = defaultNormalBackgroundColor,
      this.pressBackgroundColor = defaultPressBackgroundColor,
      this.disableBackgroundColor = defaultDisableBackgroundColor,
      this.disable = false,
      this.onPress})
      : background = normalBackgroundColor,
        super(key: key);
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
        padding: widget.padding,
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
