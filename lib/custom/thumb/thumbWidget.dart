import 'dart:async';

import 'package:flutter/material.dart';
import 'thumbPainter.dart';
import 'thumbMixin.dart';

typedef OnAnimationEnd = void Function();
typedef OnAnimationCancle = void Function();

class ThumbController with ThumbMixin {
  Map<int, ThumbMixin> thumbMixins = Map();

  void add(int index, ThumbMixin thumbMixin) {
    thumbMixins[index] = thumbMixin;
  }

  bool remove(int index, ThumbMixin thumbMixin) {
    if (thumbMixins.containsValue(thumbMixin)) {
      return thumbMixins.remove(index) != null;
    }
    return false;
  }

  bool contains(ThumbMixin thumbMixin) {
    return thumbMixins.containsValue(thumbMixin);
  }

  @override
  void startAnima({int index}) {
    if (thumbMixins[index] != null) {
      thumbMixins[index].startAnima();
    }
  }
}

class ThumbWidget extends StatefulWidget {
  String imagePath;
  String thumText;
  double width;
  double height;
  ThumbController thumbController;
  int index;
  Widget child;
  OnAnimationEnd onAnimationEnd;
  OnAnimationCancle onAnimationCancle;

  ThumbWidget(
      {@required this.imagePath,
      this.thumText = '真棒，任务完成了!',
      this.width = 60,
      this.height = 60,
      this.thumbController,
      this.index,
      @required this.child,
      this.onAnimationEnd,
      this.onAnimationCancle});

  @override
  State<StatefulWidget> createState() {
    return ThumbState();
  }
}

class ThumbState extends State<ThumbWidget>
    with TickerProviderStateMixin, ThumbMixin {
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
    widget.thumbController.add(widget.index, this);
    print("ThumbState--initState():widget.index=${widget.index}");
  }

  @override
  void dispose() {
    super.dispose();
    widget?.onAnimationCancle?.call();
    _circleAnimationController?.stop(canceled: true);
    _pathAnimationController?.stop(canceled: true);
    bool remove = widget.thumbController?.remove(widget.index, this);
    _circleAnimationController?.dispose();
    _pathAnimationController?.dispose();
    print("ThumbState--dispose():widget.index=${widget.index},remove=$remove");
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
      print(
          "ThumbState--circleAnimateValue():animationStatus=$animationStatus");
      if (animationStatus == AnimationStatus.completed) {
        if (circleAnimateValue == 1 && !reverse) {
          _pathAnimationController.forward();
        }
      } else if (animationStatus == AnimationStatus.dismissed) {
        if (circleAnimateValue == 0 && reverse) {
          widget?.onAnimationEnd?.call();
        }
      }
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
          if (widget.thumbController.contains(this)) {
            Timer(Duration(milliseconds: 1000), () {
              if (widget.thumbController.contains(this)) {
                _pathAnimationController?.reverse();
              }
            });
          }
        }
      } else if (animationStatus == AnimationStatus.dismissed) {
        if (reverse) {
          _circleAnimationController?.reverse();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.width / 2)),
                  image: DecorationImage(
                    image: AssetImage(widget
                        .imagePath) /*new NetworkImage(
                    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec'
                        '=1560423242259&di=bf4fc3b98a6500724576c03591dc0c34&imgtype=0&src'
                        '=http%3A%2F%2Fpro.user.img41.51sole.com%2FproductImages3%2F20150731%2Fb_1636865_20150731152744.jpg')*/
                    ,
                  )),
              child: GestureDetector(
                onTap: () {
                  startAnima();
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
            Offstage(
              offstage: circleAnimateValue != 0,
              child: widget.child,
            )
          ],
        ),
      );
    });
  }

  @override
  void startAnima({int index}) {
    if (!_pathAnimationController.isAnimating &&
        !_circleAnimationController.isAnimating) {
      reverse = false;
      _circleAnimationController.reset();
      _pathAnimationController.reset();
      _circleAnimationController.forward();
    }
  }
}
