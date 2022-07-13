import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/custom/calendar2/calendar_enum.dart';

import '../utils/calendar_date_utils.dart';

class CalendarWeekPainter extends CustomPainter {
  DateTime dateTime;
  Offset offset;
  List<int> days;
  int monthDays;
  int weekDay;
  int startDay;
  DateTimeRange selectedDateTimeRange;
  DateTime selectedDateTime;
  SelectMode selectMode;
  ViewMode viewMode;

  CalendarWeekPainter({
    this.dateTime,
    this.days,
    this.monthDays,
    this.weekDay,
    this.startDay,
    this.selectedDateTimeRange,
    this.selectedDateTime,
    this.selectMode,
    this.viewMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    print("CalendarPainter--paint():size=$size");
    days.forEach((element) {
      drawDay(
        canvas,
        element,
        size,
        0,
        days.indexOf(element),
        dateTime.add(Duration(days: days.indexOf(element))),
      );
    });
  }

  void drawDay(Canvas canvas, int day, Size size, int row, int column,
      DateTime dateTime) {
    canvas.save();
    double dayItemWidth = size.width / 7;
    double dayItemHeight = size.height;

    print(
        "CalendarPainter--drawDay():dayItemWidth=$dayItemWidth,dayItemHeight=$dayItemHeight");
    canvas.translate(column * dayItemWidth + dayItemWidth / 2,
        row * dayItemHeight + dayItemHeight / 2);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Color(0x520459FD);
    double radius = min(dayItemWidth, dayItemHeight) / 2;
    if (selectMode == SelectMode.multiple && selectedDateTimeRange != null) {
      if (selectedDateTimeRange.end.year == selectedDateTimeRange.start.year &&
          selectedDateTimeRange.end.month ==
              selectedDateTimeRange.start.month &&
          selectedDateTimeRange.end.day == selectedDateTimeRange.start.day &&
          selectedDateTimeRange.start.year == dateTime.year &&
          selectedDateTimeRange.start.month == dateTime.month &&
          selectedDateTimeRange.start.day == day) {
        //同一天
        paint.color = Color(0xFF0459FD);
        canvas.drawCircle(Offset.zero, radius, paint);
        paint.color = Color(0x520459FD);
      } else if (selectedDateTimeRange.start.year == dateTime.year &&
          selectedDateTimeRange.start.month == dateTime.month &&
          selectedDateTimeRange.start.day == day) {
        //开始点
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            -radius,
            -radius,
            dayItemWidth / 2,
            radius,
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
          ),
          paint,
        );
        paint.color = Color(0xFF0459FD);
        canvas.drawCircle(Offset.zero, radius, paint);
        paint.color = Color(0x520459FD);
      } else if (selectedDateTimeRange.end.year == dateTime.year &&
          selectedDateTimeRange.end.month == dateTime.month &&
          selectedDateTimeRange.end.day == day) {
        //结束点
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            -dayItemWidth / 2,
            -radius,
            radius,
            radius,
            topRight: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
          paint,
        );
        paint.color = Color(0xFF0459FD);
        canvas.drawCircle(Offset.zero, radius, paint);
        paint.color = Color(0x520459FD);
      } else if (DateTime(dateTime.year, dateTime.month, day)
              .isAfter(selectedDateTimeRange.start) &&
          DateTime(dateTime.year, dateTime.month, day)
              .isBefore(selectedDateTimeRange.end)) {
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            -dayItemWidth / 2,
            -radius,
            dayItemWidth / 2,
            radius,
          ),
          paint,
        );
      }
    } else if (selectedDateTime != null) {
      if (selectedDateTime.year == dateTime.year &&
          selectedDateTime.month == dateTime.month &&
          selectedDateTime.day == day) {
        canvas.drawCircle(
          Offset.zero,
          radius,
          paint,
        );
      }
    }

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: '$day',
        style: TextStyle(
          color: isSelected(dateTime) ? Colors.white : Color(0xFF5D5D5D),
          fontSize: 16.0,
        ),
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        -textPainter.size.width / 2,
        -textPainter.size.height / 2,
      ),
    );
    canvas.restore();
  }

  bool isSelected(DateTime time) {
    if ((selectMode == SelectMode.multiple &&
            selectedDateTimeRange != null &&
            (time.isAfter(selectedDateTimeRange.start) &&
                    time.isBefore(selectedDateTimeRange.end) ||
                CalendarDateUtils.isSameDay(
                    time, selectedDateTimeRange.start) ||
                CalendarDateUtils.isSameDay(
                    time, selectedDateTimeRange.end))) ||
        (selectMode == SelectMode.single &&
            selectedDateTime != null &&
            CalendarDateUtils.isSameDay(time, selectedDateTime))) {
      return true;
    }
    return false;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
