import 'package:flutter/material.dart';
import 'calendar_painter.dart';
import 'date_utils.dart';

typedef OnSelectedDateTime = void Function(DateTime dateTime);

class Calendar extends StatefulWidget {
  DateTime _dateTime;
  OnSelectedDateTime onSelectedDateTime;

  Calendar(this._dateTime, this.onSelectedDateTime);

  @override
  State<StatefulWidget> createState() {
    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {
  int NUM_ROWS = 6;
  int offsetHeight = 0;
  GlobalKey globalKey = GlobalKey();
  Offset offset;
  DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GestureDetector(
        onTapUp: (TapUpDetails details) {
          RenderBox renderBox = globalKey.currentContext.findRenderObject();
//          setState(() {
//            offset = renderBox.globalToLocal(details.globalPosition);
//          });
          offset = renderBox.globalToLocal(details.globalPosition);
          widget.onSelectedDateTime?.call(selectedDateTime);
        },
        child: CustomPaint(
          key: globalKey,
          size: Size(constraints.maxWidth,
              calculateHeight(constraints.maxWidth, widget._dateTime)),
          painter: CalendarPainter(widget._dateTime, offset),
        ),
      );
    });
  }

  double calculateHeight(double width, DateTime dateTime) {
    if (dateTime.year == DateTime.now().year &&
        dateTime.month == DateTime.now().month) {
      // 获取当月一共有多少天
      int monthDays = DateUtils.getMonthDays(dateTime.year, dateTime.month);
      // 获取当月今天位于周几
      int dayOfWeek = DateTime.now().weekday;
      dayOfWeek = dayOfWeek == 7 ? 1 : dayOfWeek + 1;
      NUM_ROWS = (monthDays - DateTime.now().day + 1 + dayOfWeek - 1) ~/ 7 +
          ((monthDays - DateTime.now().day + 1 + dayOfWeek - 1) % 7 == 0
              ? 0
              : 1);
      print(
          'calculateHeight():dateTime=${dateTime.toString()},monthDays=$monthDays,dayOfWeek=$dayOfWeek'
          ',NUM_ROWS=$NUM_ROWS,height=${NUM_ROWS * (width / 7) * 5 / 5 + offsetHeight}');
    } else {
      // 获取当月一共有多少天
      int monthDays = DateUtils.getMonthDays(dateTime.year, dateTime.month);
      // 获取当月第一天位于周几
      int firstDayWeek =
          DateUtils.getFirstDayWeek(dateTime.year, dateTime.month);
      firstDayWeek = firstDayWeek == 7 ? 1 : firstDayWeek + 1;
      NUM_ROWS = (monthDays + firstDayWeek - 1) ~/ 7 +
          ((monthDays + firstDayWeek - 1) % 7 == 0 ? 0 : 1);
      print(
          'calculateHeight():dateTime=${dateTime.toString()},monthDays=$monthDays,firstDayWeek=$firstDayWeek'
          ',height=${NUM_ROWS * (width / 7) * 5 / 5 + offsetHeight}');
    }
    return NUM_ROWS * (width / 7) * 5 / 5 + offsetHeight;
  }
}
