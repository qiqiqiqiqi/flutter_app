import 'package:flutter/material.dart';
import 'date_utils.dart';

class CalendarPainter extends CustomPainter {
  DateTime dateTime;
  Offset offset;
  List<List<int>> days;
  DateTime selectedDateTime;
  int monthDays;
  int weekDay;
  int startDay;

  CalendarPainter(
      {this.dateTime,
      this.selectedDateTime,
      this.days,
      this.monthDays,
      this.weekDay,
      this.startDay});

  @override
  void paint(Canvas canvas, Size size) {
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
    if (selectedDateTime != null &&
        selectedDateTime.year == dateTime.year &&
        selectedDateTime.month == dateTime.month &&
        selectedDateTime.day == day) {
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
