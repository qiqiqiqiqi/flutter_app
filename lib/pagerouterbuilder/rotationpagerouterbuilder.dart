import 'package:flutter/material.dart';
import 'package:flutter_app/view/route.dart';

class RotationPageRouterBuilder extends PageRouteBuilder<Product> {
  RotationPageRouterBuilder(Widget widget)
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return widget;
            },
            transitionDuration: Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation1,
                Animation<double> animation2,
                Widget widget) {
              return new RotationTransition(
                turns: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animation1, curve: Curves.fastOutSlowIn)),
                child: ScaleTransition(
                  scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animation1, curve: Curves.fastOutSlowIn)),
                  child: widget,
                ),
              );
            });
}
