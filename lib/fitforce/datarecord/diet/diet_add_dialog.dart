import 'package:flutter/material.dart';
import 'package:flutter_app/fitforce/datarecord/diet/ruler/ruler_text.dart';
import 'package:flutter_app/fitforce/datarecord/ruler/ruler.dart';
import 'package:flutter_app/fitforce/datarecord/common_round_button.dart';

// ignore: must_be_immutable
class DietAddDialog extends Dialog {
  DietAddDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogContainer();
  }
}

class DialogContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DialogContainerState();
  }
}

class DialogContainerState extends State<DialogContainer>
    with TickerProviderStateMixin {
  AnimationController animationController;
  double tanslationY = 0.0;
  GlobalKey globalKey;
  double value = 0.0;

  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Animation curvedAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((Duration duration) {
      print('DialogContainerState--initState()');
      animationController.forward(from: 0.0);
      RenderBox renderBox = globalKey.currentContext.findRenderObject();
      double contentHeight = renderBox.size.height;
      curvedAnimation.addListener(() {
        setState(() {
          value = curvedAnimation.value;
          tanslationY = contentHeight - contentHeight * curvedAnimation.value;
        });
        print(
            'DialogContainerState--initState():animationController.value=${animationController.value},contentHeight=$contentHeight');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
//      type: MaterialType.transparency,
      color: Color.fromRGBO(0, 0, 0, value * 0.3), //透明类型

      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Container(
            color: Colors.white,
            key: globalKey,
            child: Transform(
              transform: Matrix4.translationValues(0.0, tanslationY, 0.0),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 30, top: 26, right: 26),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '摄入的量',
                              style: TextStyle(
                                  color: Color(0xFF374147), fontSize: 14),
                            ),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.clear,
                              size: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      /*decoration: BoxDecoration(
                          gradient: LinearGradient(colors: <Color>[
                        Color(0xFFEEEEEE),
                        Color(0xFFE3E3E3),
                        Color(0xFFEEEEEE),
                      ],begin: Alignment.centerLeft,end: Alignment.centerRight)),*/
                      margin: EdgeInsets.only(top: 28, bottom: 10),
                      child: Ruler(minValue: 30, maxValue: 300,showHL:false),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 14),
                      child: RulerText(
                        minValue: 0,
                        middleValue: 0,
                        maxValue: 6,
                        height: 80,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 81, right: 81, bottom: 46, top: 30),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: StatefulRoundButton(
                            margin: EdgeInsets.only(right: 14),
                            pressBackgroundColor: Colors.grey[200],
                            normalBackgroundColor: Colors.white,
                            height: 45,
                            raduis: 4,
                            borderColor: Color(0xFFCCD1D4),
                            child: Text(
                              '取消',
                              style: TextStyle(
                                  color: Color(0xFFAAB2B7),
                                  fontSize: 16,
                                  decoration: TextDecoration.none),
                            ),
                            onPress: () {},
                          )),
                          Expanded(
                              child: StatefulRoundButton(
                            disableBackgroundColor: Color(0xFFE8E9EB),
                            pressBackgroundColor: Color(0x9F1AD9CA),
                            normalBackgroundColor: Color(0xFF1AD9CA),
                            height: 45,
                            raduis: 4,
                            child: Text(
                              '完成',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.none),
                            ),
                            onPress: () {},
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
