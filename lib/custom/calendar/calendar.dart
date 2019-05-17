import 'package:flutter/material.dart';
import 'calendar_painter.dart';

class Calendar extends StatefulWidget {
  DateTime _dateTime;

  Calendar(this._dateTime);

  @override
  State<StatefulWidget> createState() {
    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GestureDetector(
        child: CustomPaint(
          size: Size(constraints.maxWidth,
              calculateHeight(constraints.maxWidth, widget._dateTime)),
          painter: CalendarPainter(),
        ),
      );
    });
  }

  double calculateHeight(double width, DateTime dateTime) {
//    if (mItemYear == mCurYear && mItemMonth == mCurMonth) {
//      // 获取当月一共有多少天
//      int monthDays = DateUtils.getMonthDays(mItemYear, mItemMonth);
//      // 获取当月今天位于周几
//      int dayOfWeek = DateUtils.getDayOfWeek(mItemYear, mItemMonth, mItemDate);
//      NUM_ROWS = (monthDays - mItemDate + 1 + dayOfWeek - 1) / 7 +
//          ((monthDays - mItemDate + 1 + dayOfWeek - 1) % 7 == 0 ? 0 : 1);
//      return NUM_ROWS * (width / 7) * 5 / 5 + offsetHeigh;
//    } else {
//      // 获取当月一共有多少天
//      int monthDays = DateUtils.getMonthDays(mItemYear, mItemMonth);
//      // 获取当月第一天位于周几
//      int firstDayWeek = DateUtils.getFirstDayWeek(mItemYear, mItemMonth);
//      NUM_ROWS = (monthDays + firstDayWeek - 1) / 7 +
//          ((monthDays + firstDayWeek - 1) % 7 == 0 ? 0 : 1);
//      return NUM_ROWS * (width / 7) * 5 / 5 + offsetHeigh;
//    }
  }
}
