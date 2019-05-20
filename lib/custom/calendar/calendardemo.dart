import 'package:flutter/material.dart';
import 'calendar.dart';
import 'date_utils.dart';
import 'calendar_week_day.dart';

main() {
  runApp(CalendarDemo());
}

class CalendarDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalendarDemoState();
  }
}

class CalendarDemoState extends State {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "calendar demo",
      home: Scaffold(
        appBar: AppBar(title: Text("calendar demo")),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            WeekDay(),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '${DateUtils.getNextMonth(DateTime.now(), index).year}-${DateUtils.getNextMonth(DateTime.now(), index).month}',
                            style: TextStyle(fontSize: 16),
                          )),
                      Calendar(DateUtils.getNextMonth(DateTime.now(), index),
                          (DateTime dateTime) {
                        setState(() {
                          print(
                              'CalendarDemoState:dateTime=${dateTime.toString()}');
                        });
                      })
                    ],
                  ),
                );
              },
              itemCount: 100,
            ))
          ],
        ),
      ),
    );
  }
}
