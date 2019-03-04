import 'package:flutter/material.dart';
import 'fitforce_gym_round_button.dart';

class FitforceGymUserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: Row(
            children: <Widget>[
              Text(
                "基本信息",
                style: TextStyle(color: Color(0XFF263238), fontSize: 12),
              ),
              Expanded(
                  child: Text(
                "待审核",
                textAlign: TextAlign.right,
                style: TextStyle(color: Color(0XFF909399), fontSize: 13),
              ))
            ],
          )),
          Expanded(
              child: Row(
            children: <Widget>[
              Text(
                "学历信息",
                style: TextStyle(color: Color(0XFF263238), fontSize: 12),
              ),
              Expanded(
                  child: Text(
                "待审核",
                textAlign: TextAlign.right,
                style: TextStyle(color: Color(0XFF909399), fontSize: 13),
              ))
            ],
          )),
          Expanded(
              child: Row(
            children: <Widget>[
              Text(
                "职业资质",
                style: TextStyle(color: Color(0XFF263238), fontSize: 12),
              ),
              Expanded(
                  child: Text(
                "待审核",
                textAlign: TextAlign.right,
                style: TextStyle(color: Color(0XFF909399), fontSize: 13),
              ))
            ],
          )),
          new StatefulRoundButton(
              width: 108,
              height: 29,
              raduis: 3,
              child: Text(
                "更新认证信息",
                style: TextStyle(color: Color(0XFF20C6BA), fontSize: 13),
              ),
              disable: false,
              margin: EdgeInsets.only(bottom: 8),
              normalBackgroundColor: Colors.white,
              pressBackgroundColor: Color(0X1A20C6BA),
              borderColor: Color(0XFF20C6BA),
              onPress: () {
                final snackBar = new SnackBar(content: new Text("更新认证信息"));
                Scaffold.of(context).showSnackBar(snackBar);
              }),
          Text(
            "更新信息将重新提交申请",
            style: TextStyle(color: Color(0XFFC0C4CC), fontSize: 10),
          )
        ],
      ),
    );
  }
}
