import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/custom/calendar2/calendar_enum.dart';

import '../utils/calendar_date_utils.dart';

const selectedColor = Color(0xFF06AB92);
const innerSelectedColor = Color(0x5206AB92);

class CalendarPainter extends CustomPainter {
  DateTime dateTime;
  Offset offset;
  List<List<int>> days;
  int monthDays;
  int weekDay;
  int startDay;
  DateTimeRange selectedDateTimeRange;
  DateTime selectedDateTime;
  SelectMode selectMode;
  ViewMode viewMode;

  CalendarPainter({
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
    for (int day = startDay; day < monthDays; day++) {
      int column = (day - startDay + weekDay) % 7; //(0~6列共7列)
      int row = (day - startDay + weekDay) ~/ 7; //(0~5共6行)

      drawDay(canvas, day + 1, size, row, column);
    }
  }

  void drawDay(Canvas canvas, int day, Size size, int row, int column) {
    var dayDateTime = DateTime(dateTime.year, dateTime.month, day);
    canvas.save();
    double dayItemWidth = size.width / 7;
    double dayItemHeight = size.height / 6;

    print(
        "CalendarPainter--drawDay():dayItemWidth=$dayItemWidth,dayItemHeight=$dayItemHeight");
    canvas.translate(column * dayItemWidth + dayItemWidth / 2,
        row * dayItemHeight + dayItemHeight / 2);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = selectedColor;
    double radius = min(dayItemWidth, dayItemHeight) / 2 - 10;
    if (selectMode == SelectMode.multiple && selectedDateTimeRange != null) {
      if (selectedDateTimeRange.end.year == selectedDateTimeRange.start.year &&
          selectedDateTimeRange.end.month ==
              selectedDateTimeRange.start.month &&
          selectedDateTimeRange.end.day == selectedDateTimeRange.start.day &&
          selectedDateTimeRange.start.year == dateTime.year &&
          selectedDateTimeRange.start.month == dateTime.month &&
          selectedDateTimeRange.start.day == day) {
        //同一天
        paint.color = selectedColor;
        canvas.drawCircle(Offset.zero, radius, paint);
        paint.color = innerSelectedColor;
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
        paint.color = selectedColor;
        canvas.drawCircle(Offset.zero, radius, paint);
        paint.color = innerSelectedColor;
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
        paint.color = selectedColor;
        canvas.drawCircle(Offset.zero, radius, paint);
        paint.color = innerSelectedColor;
      } else if (dayDateTime.isAfter(selectedDateTimeRange.start) &&
          dayDateTime.isBefore(selectedDateTimeRange.end)) {
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
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '$day',
        style: TextStyle(
          color: isSelected(dayDateTime) ? Colors.white : Color(0xFF5D5D5D),
          fontSize: 20.0,
        ),
        children: [
          TextSpan(
            text: '\n${CalendarDateUtils.dateTimeToLunar(dayDateTime)}',
            style: TextStyle(
              color: isSelected(dayDateTime) ? Colors.white : Color(0xFF5D5D5D),
              fontSize: 12.0,
            ),
          )
        ],
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
