import 'package:flutter/material.dart';
import 'address_select_page.dart';

// ignore: must_be_immutable
class AddressDialog extends Dialog {
  AddressDialog({Key key}) : super(key: key);

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
            child: Transform(
              transform: Matrix4.translationValues(0.0, tanslationY, 0.0),
              child: ClipRRect(
                key: globalKey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                child: AddressSelectPage(),
              ),
            ),
            height: 560,
          )
        ],
      ),
    );
  }
}
