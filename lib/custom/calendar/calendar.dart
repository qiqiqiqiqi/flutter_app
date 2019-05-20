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
  static DateTime selectedDateTime;
  List<List<int>> days;
  int monthDays;
  int weekDay;
  int startDay;

  @override
  void initState() {
    super.initState();
    days = List(6);
    for (int i = 0; i < 6; i++) {
      List<int> childList = List(7);
      days[i] = childList;
    }
    monthDays =
        DateUtils.getMonthDays(widget._dateTime.year, widget._dateTime.month);
    weekDay = DateUtils.getFirstDayWeek(
        widget._dateTime.year, widget._dateTime.month);
    startDay = 0;
    if (widget._dateTime.year == DateTime.now().year &&
        widget._dateTime.month == DateTime.now().month) {
      weekDay = DateTime.now().weekday;
      startDay = DateTime.now().day - 1;
    }
    weekDay = weekDay == 7 ? 1 : weekDay + 1;

    for (int day = startDay; day < monthDays; day++) {
      int column = (day - startDay + weekDay - 1) % 7; //(0~6列共7列)
      int row = (day - startDay + weekDay - 1) ~/ 7; //(0~5共6行)
      days[row][column] = day + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GestureDetector(
        onTapUp: (TapUpDetails details) {
          RenderBox renderBox = globalKey.currentContext.findRenderObject();
          Offset offset = renderBox.globalToLocal(details.globalPosition);
          double dayItemSize = constraints.maxWidth / 7;
          int row = offset.dy ~/ dayItemSize;
          int column = offset.dx ~/ dayItemSize;
          selectedDateTime = DateTime(
              widget._dateTime.year, widget._dateTime.month, days[row][column]);
          print(
              'paint():column=$column,row=$row,selectedDateTime=${selectedDateTime.toString()}');
          widget.onSelectedDateTime?.call(selectedDateTime);
        },
        child: CustomPaint(
          key: globalKey,
          size: Size(constraints.maxWidth,
              calculateHeight(constraints.maxWidth, widget._dateTime)),
          painter: CalendarPainter(
              dateTime: widget._dateTime,
              selectedDateTime: selectedDateTime,
              days: days,
              monthDays: monthDays,
              weekDay: weekDay,
              startDay: startDay),
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
