import 'package:flutter/material.dart';

class FitforceGymTimeInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/btn_gym_work_time.png',
                    width: 30,
                    height: 19,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "工作时间",
                      style: TextStyle(color: Color(0XFF8597A1), fontSize: 12),
                    ),
                  )
                ],
              ),
            )),
            Expanded(
                child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/btn_gym_leave.png',
                    width: 30,
                    height: 19,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "请假",
                      style: TextStyle(color: Color(0XFF8597A1), fontSize: 12),
                    ),
                  )
                ],
              ),
            )),
            Expanded(
                child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/btn_gym_holiday.png',
                    width: 30,
                    height: 19,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "休假",
                      style: TextStyle(color: Color(0XFF8597A1), fontSize: 12),
                    ),
                  )
                ],
              ),
            ))
          ],
        ));
  }
}
