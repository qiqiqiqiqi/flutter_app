import 'package:flutter/material.dart';
import 'calendar.dart';
import 'date_utils.dart';

main() {
  runApp(CalendarDemo());
}

class CalendarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "calendar demo",
      home: Scaffold(
        appBar: AppBar(title: Text("calendar demo")),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: <Widget>[
                  Text('$index'),
                  Calendar(DateUtils.getOneDayNextDate(DateTime.now(), index))
                ],
              ),
            );
          },
          itemCount: 12,
        ),
      ),
    );
  }
}
