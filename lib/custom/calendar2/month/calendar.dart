import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/custom/calendar2/calendar_enum.dart';

import '../utils/calendar_date_utils.dart';
import 'calendar_painter.dart';

class Calendar extends StatefulWidget {
  final DateTime dateTime;
  final OnSelectedDateTime onSelectedDateTime;
  final OnSelectedDateTimeRange onSelectedDateTimeRange;
  final BoundaryMode boundaryMode;
  final DateTimeRange selectedDateTimeRange;
  final DateTime selectedDateTime;
  final SelectMode selectMode;
  final ViewMode viewMode;

  Calendar({
    Key key,
    this.dateTime,
    this.onSelectedDateTime,
    this.boundaryMode = BoundaryMode.before,
    this.selectedDateTimeRange,
    this.selectedDateTime,
    this.onSelectedDateTimeRange,
    this.selectMode = SelectMode.multiple,
    this.viewMode = ViewMode.month,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {
  int numRows = 6;
  int offsetHeight = 0;
  GlobalKey globalKey = GlobalKey();
  Offset offset;
  DateTime selectedDateTime;
  DateTimeRange selectedDateTimeRange;
  List<List<int>> days;
  int monthDays;
  int weekDay;
  int startDay;

  @override
  void dispose() {
    // print('CalendarState---dispose():dateTime=${widget.dateTime}');
    super.dispose();
  }

  @override
  void initState() {
    // print('CalendarState---initState():dateTime=${widget.dateTime}');
    super.initState();

    days = List.filled(6, List.empty());
    for (int i = 0; i < 6; i++) {
      List<int> childList = List.filled(7, 0);
      days[i] = childList;
    }
    selectedDateTime = widget.selectedDateTime;
    selectedDateTimeRange = widget.selectedDateTimeRange;
    monthDays = CalendarDateUtils.getMonthDays(
        widget.dateTime.year, widget.dateTime.month);
    weekDay = CalendarDateUtils.getFirstDayWeek(
        widget.dateTime.year, widget.dateTime.month);
    startDay = 0;
    if (widget.dateTime.year == DateTime.now().year &&
        widget.dateTime.month == DateTime.now().month) {
      if (widget.boundaryMode == BoundaryMode.after) {
        //以今天为起点的时间
        weekDay = DateTime.now().weekday;
        startDay = DateTime.now().day - 1;
      } else if (widget.boundaryMode == BoundaryMode.before) {
        //以今天为终点的时间
        monthDays = DateTime.now().day;
      }
    }

    weekDay = weekDay == 7 ? 0 : weekDay;
    for (int day = startDay; day < monthDays; day++) {
      int column = (day - startDay + weekDay) % 7; //(0~6列共7列)
      int row = (day - startDay + weekDay) ~/ 7; //(0~5共6行)
      days[row][column] = day + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        'CalendarState---build():dateTime=${widget.dateTime},selectedDateTimeRange=${selectedDateTimeRange.start}--${selectedDateTimeRange.end},viewMode=${widget.viewMode}');
    if (selectedDateTimeRange != widget.selectedDateTimeRange) {
      selectedDateTimeRange = widget.selectedDateTimeRange;
    }
    if (selectedDateTime != widget.selectedDateTime) {
      selectedDateTime = widget.selectedDateTime;
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          onTapUp: (TapUpDetails details) {
            RenderBox renderBox = globalKey.currentContext.findRenderObject();
            Offset offset = renderBox.globalToLocal(details.globalPosition);
            double dayItemSizeWidth = constraints.maxWidth / 7;
            double dayItemSizeHeight = constraints.maxHeight / 6;

            int row = offset.dy ~/ dayItemSizeHeight;
            int column = offset.dx ~/ dayItemSizeWidth;
            if (row > 5 || column > 7 || days[row][column] == 0) {
              return;
            }
            var dateTime = DateTime(
              widget.dateTime.year,
              widget.dateTime.month,
              days[row][column],
            );
            /* print(
              'paint():column=$column,row=$row,selectedDateTime=${dateTime.toString()}',
            );*/
            if (widget.selectMode == SelectMode.single) {
              selectedDateTime = dateTime;
              widget.onSelectedDateTime?.call(selectedDateTime);
            } else {
              if (selectedDateTimeRange == null) {
                selectedDateTimeRange = DateTimeRange(
                  start: dateTime,
                  end: dateTime,
                );
              } else {
                if (selectedDateTimeRange.start
                        .isAtSameMomentAs(selectedDateTimeRange.end) &&
                    dateTime.isAfter(selectedDateTimeRange.start)) {
                  selectedDateTimeRange = DateTimeRange(
                    start: selectedDateTimeRange.start,
                    end: dateTime,
                  );
                } else {
                  selectedDateTimeRange = DateTimeRange(
                    start: dateTime,
                    end: dateTime,
                  );
                }
                widget.onSelectedDateTimeRange?.call(selectedDateTimeRange);
              }
            }
          },
          child: CustomPaint(
            key: globalKey,
            size: Size(
              constraints.maxWidth,
              calculateHeight(
                constraints.maxWidth,
                constraints.maxHeight,
                widget.dateTime,
                widget.viewMode,
              ),
            ),
            painter: CalendarPainter(
              dateTime: widget.dateTime,
              days: days,
              monthDays: monthDays,
              weekDay: weekDay,
              startDay: startDay,
              selectedDateTimeRange: selectedDateTimeRange,
              selectedDateTime: selectedDateTime,
              selectMode: widget.selectMode,
              viewMode: widget.viewMode,
            ),
          ),
        );
      },
    );
  }

  onTapUp(TapUpDetails details) {}

  double calculateHeight(
      double width, double maxHeight, DateTime dateTime, ViewMode viewMode) {
    if (viewMode == ViewMode.week) {
      print(
          'calculateHeight():height=${maxHeight / 6 + offsetHeight},maxHeight=$maxHeight');
      return maxHeight / 6;
    } else {
      if (dateTime.year == DateTime.now().year &&
          dateTime.month == DateTime.now().month) {
        // 获取当月一共有多少天
        int monthDays =
            CalendarDateUtils.getMonthDays(dateTime.year, dateTime.month);
        // 获取当月今天位于周几
        int dayOfWeek = DateTime.now().weekday;
        dayOfWeek = dayOfWeek == 7 ? 1 : dayOfWeek + 1;
        numRows = (monthDays - DateTime.now().day + 1 + dayOfWeek - 1) ~/ 7 +
            ((monthDays - DateTime.now().day + 1 + dayOfWeek - 1) % 7 == 0
                ? 0
                : 1);
        /*print(
          'calculateHeight():dateTime=${dateTime.toString()},monthDays=$monthDays,dayOfWeek=$dayOfWeek'
          ',NUM_ROWS=$numRows,height=${numRows * (width / 7) * 5 / 5 + offsetHeight}');*/
      } else {
        // 获取当月一共有多少天
        int monthDays =
            CalendarDateUtils.getMonthDays(dateTime.year, dateTime.month);
        // 获取当月第一天位于周几
        int firstDayWeek =
            CalendarDateUtils.getFirstDayWeek(dateTime.year, dateTime.month);
        firstDayWeek = firstDayWeek == 7 ? 1 : firstDayWeek + 1;
        numRows = (monthDays + firstDayWeek - 1) ~/ 7 +
            ((monthDays + firstDayWeek - 1) % 7 == 0 ? 0 : 1);
        /*  print(
          'calculateHeight():dateTime=${dateTime.toString()},monthDays=$monthDays,firstDayWeek=$firstDayWeek'
          ',height=${numRows * (width / 7) * 5 / 5 + offsetHeight}');*/
      }
      print(
          'calculateHeight():height=${numRows * (width / 7) + offsetHeight},maxHeight=$maxHeight');
      return min(numRows * (width / 7) + offsetHeight, maxHeight);
    }
  }
}
