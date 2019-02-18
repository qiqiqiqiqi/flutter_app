import 'package:flutter/material.dart';
import 'package:flutter_app/view/route.dart';
class CustomRouterBuilder extends PageRouteBuilder<Product> {
  CustomRouterBuilder(Widget widget)
      : super(
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (BuildContext context, Animation<double> animation1,
              Animation<double> animation2) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation1,
              Animation<double> animation2,
              Widget widget) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animation1,
                curve: Curves.fastOutSlowIn,
              )),
              child: widget,
            );
          },
        );
}
