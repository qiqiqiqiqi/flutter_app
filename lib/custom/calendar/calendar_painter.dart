import 'package:flutter/material.dart';
import 'date_utils.dart';


class CalendarPainter extends CustomPainter {
  DateTime dateTime;
  Offset offset;
  List<List<int>> days;
  static DateTime sSelectedDateTime;
  int monthDays;
  int weekDay;
  int startDay;

  CalendarPainter(this.dateTime, this.offset) {
    days = List(6);
    for (int i = 0; i < 6; i++) {
      List<int> childList = List(7);
      days[i] = childList;
    }
    monthDays = DateUtils.getMonthDays(dateTime.year, dateTime.month);
    weekDay = DateUtils.getFirstDayWeek(dateTime.year, dateTime.month);
    startDay = 0;
    if (dateTime.year == DateTime.now().year &&
        dateTime.month == DateTime.now().month) {
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
  void paint(Canvas canvas, Size size) {
    if (offset != null) {
      double dayItemSize = size.width / 7;
      int row = offset.dy ~/ dayItemSize;
      int column = offset.dx ~/ dayItemSize;
      sSelectedDateTime =
          DateTime(dateTime.year, dateTime.month, days[row][column]);
      print(
          'paint():column=$column,row=$row,selectedDateTime=${sSelectedDateTime.toString()}');
    }
    for (int day = startDay; day < monthDays; day++) {
      int column = (day - startDay + weekDay - 1) % 7; //(0~6列共7列)
      int row = (day - startDay + weekDay - 1) ~/ 7; //(0~5共6行)
      drawDay(canvas, day + 1, size, row, column);
    }
  }

  void drawDay(Canvas canvas, int day, Size size, int row, int column) {
    canvas.save();
    double dayItemSize = size.width / 7;
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: '$day',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic)));
    textPainter.layout();
    canvas.translate(column * dayItemSize, row * dayItemSize);
    if (sSelectedDateTime != null &&
        sSelectedDateTime.year == dateTime.year &&
        sSelectedDateTime.month == dateTime.month &&
        sSelectedDateTime.day == day) {
      Paint paint = Paint()
        ..isAntiAlias = true
        ..color = Colors.green;
      canvas.drawCircle(
          Offset(dayItemSize / 2, dayItemSize / 2), dayItemSize / 3, paint);
    }
    textPainter.paint(
        canvas,
        Offset(dayItemSize / 2 - textPainter.size.width / 2,
            dayItemSize / 2 - textPainter.size.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
