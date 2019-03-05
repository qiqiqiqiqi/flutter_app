import 'package:flutter/material.dart';
import 'fitforce_gym_info.dart';
import 'fitforce_gym_user_info.dart';
import 'fitforce_gym_time_info.dart';

main() {
  runApp(MaterialApp(
    title: "fitforce",
    home: FitforceGym(),
  ));
}

class FitforceGym extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FitforceGymState();
  }
}

class FitforceGymState extends State<FitforceGym> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XFFEBEDF0),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading:
              IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {}),
          title: Text("我的健身房"),
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  top: 74,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Column(
                      children: <Widget>[
                        FitforceGymInfo(),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 16, bottom: 0),
                            child: Divider(color: Color(0XFFDFDFDF))),
                        Expanded(child: FitforceGymUserInfo()),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 0, right: 0, top: 6, bottom: 0),
                            child: Divider(color: Color(0XFFDFDFDF))),
                        FitforceGymTimeInfo()
                      ],
                    ))
              ],
            )));
  }
}
