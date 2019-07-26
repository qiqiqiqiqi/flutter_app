import 'dart:async';

import 'package:flutter/material.dart';
import 'ThumbPainter.dart';

class ThumbWidget extends StatefulWidget {
  String imagePath;
  String thumText;
  double width;
  double height;

  ThumbWidget(
      {this.imagePath,
      this.thumText = '真棒，任务完成了!',
      this.width = 60,
      this.height = 60});

  @override
  State<StatefulWidget> createState() {
    return ThumbState();
  }
}

class ThumbState extends State<ThumbWidget> with TickerProviderStateMixin {
  AnimationController _circleAnimationController;
  double circleAnimateValue = 0;
  AnimationController _pathAnimationController;
  double pathAnimateValue = 0;
  double textSizeAnimateValue = 0;
  bool reverse = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    //circle
    _circleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: _circleAnimationController, curve: Curves.easeOutBack);
    curvedAnimation.addListener(() {
      setState(() {
        circleAnimateValue = _circleAnimationController.value;
        textSizeAnimateValue = curvedAnimation.value;
        print(
            "ThumbState--init():circleAnimateValue=$circleAnimateValue,textAnimateValue=$textSizeAnimateValue");
      });
    });
    curvedAnimation.addStatusListener((AnimationStatus animationStatus) {
      if (animationStatus == AnimationStatus.completed) {
        if (circleAnimateValue == 1 && !reverse) {
          _pathAnimationController.forward();
        }
      } else if (animationStatus == AnimationStatus.forward) {}
    });

    //path
    _pathAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _pathAnimationController.addListener(() {
      setState(() {
        pathAnimateValue = _pathAnimationController.value;
      });
    });
    _pathAnimationController
        .addStatusListener((AnimationStatus animationStatus) {
      if (animationStatus == AnimationStatus.completed) {
        if (pathAnimateValue == 1 && !reverse) {
          reverse = true;
          Timer(Duration(milliseconds: 1000), () {
            _pathAnimationController.reverse();
          });
        }
      } else if (animationStatus == AnimationStatus.dismissed) {
        if (reverse) {
          _circleAnimationController.reverse();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        alignment: Alignment.center,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(widget.width / 2)),
              image: new DecorationImage(
                image: new NetworkImage(
                    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec'
                        '=1560423242259&di=bf4fc3b98a6500724576c03591dc0c34&imgtype=0&src'
                        '=http%3A%2F%2Fpro.user.img41.51sole.com%2FproductImages3%2F20150731%2Fb_1636865_20150731152744.jpg'),
              )),
          child: GestureDetector(
            onTap: () {
              if (!_pathAnimationController.isAnimating &&
                  !_circleAnimationController.isAnimating) {
                reverse = false;
                _circleAnimationController.reset();
                _pathAnimationController.reset();
                _circleAnimationController.forward();
              }
            },
            child: CustomPaint(
              size: Size(widget.width, widget.height),
              painter: ThumbPainter(
                  circleAnimateValue: circleAnimateValue,
                  pathAnimateValue: pathAnimateValue,
                  textSizeAnimateValue: textSizeAnimateValue,
                  reverse: reverse,
                  text: widget.thumText),
            ),
          ),
        ),
      );
    });
  }
}
