import 'package:flutter/material.dart';

class FitforceGymInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
                child: Container(
              margin: EdgeInsets.fromLTRB(15, 5, 30, 25),
              child: Card(
                elevation: 10,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: AspectRatio(
                  aspectRatio: 2,
                  child: Image.network(
                    'http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
            Positioned(
                width: 135,
                height: 65,
                right: 0,
                bottom: 0,
                child: Image.asset("images/bg_gym.png"))
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 4, right: 20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "中航健身房",
                    style: TextStyle(
                        color: Color(0XFF263238),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                    margin: EdgeInsets.only(left: 10),
                    color: Color(0X1A20C6BA),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          "images/icon_waiting.png",
                          width: 9,
                          height: 11,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            "认证待审核",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0XFF20C6BA), fontSize: 10),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(children: <Widget>[
                  Image.asset(
                    "images/icon_ads.png",
                    width: 9,
                    height: 11,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "深圳市南山区沙河街道文昌街C3栋",
                      style: TextStyle(color: Color(0XFF8597A1), fontSize: 12),
                    ),
                  )
                ]),
              ),

            ],
          ),
        ),
      ],
    );
  }
}
