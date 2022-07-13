import 'package:flutter/material.dart';

class CalendarDateUtils {
  /// 通过年份和月份 得到当月的日子，dart中月份是从1开始的
  static int getMonthDays(int year, int month) {
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      case 2:
        if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
          return 29;
        } else {
          return 28;
        }
        break;
      default:
        return -1;
    }
  }

  /// 返回当前月份1号位于周几
  ///
  /// @param year  年份
  /// @param month 月份，传入系统获取的，不需要正常的,从1开始
  /// @return 一：1   二：2  三：3   四：4   五：5   六：6  日：7
  static int getFirstDayWeek(int year, int month) {
    return getDayOfWeek(year, month, 1);
  }

  static int getDayOfWeek(int year, int month, int day) {
    DateTime dateTime = DateTime(year, month, day);
    return dateTime.weekday;
  }

  ///返回与dateTime 相差duration个月的日期
  static DateTime getNextMonth(DateTime dateTime, int duration) {
    int month = dateTime.month;
    int year = dateTime.year;
    if (duration > 0) {
      month += duration;
      if (month > 12) {
        year = month ~/ 12 + dateTime.year;
        month = month % 12;
      }
    } else if (duration < 0) {
      if (duration.abs() > 12) {
        year = month ~/ 12 + dateTime.year;
        if ((month % 12).abs() >= dateTime.month) {
          year -= 1;
          month = month % 12 + 12 + month;
        } else {
          month = month % 12 + month;
        }
      }
    }
    return DateTime(year, month);
  }

  ///返回与dateTime 相差duration个星期的日期
  static DateTime getNextWeek(DateTime dateTime, int duration) {
    var desTime = dateTime.add(Duration(days: duration * 7));
    print(
        "CalendarDateUtils-getNextWeek():dateTime=$dateTime,desTime=$desTime");
    return desTime;
  }

  ///返回与dateTime 所在星期的开始日期
  static DateTime startWeekDayOf(DateTime dateTime) {
    var weekday = dateTime.weekday;
    print(
        "CalendarDateUtils-startWeekDayOf():dateTime=$dateTime,desTime=${dateTime.add(Duration(days: -(weekday % 7)))}");
    return dateTime.add(Duration(days: -(weekday % 7)));
  }

  /// 返回某天的下一天
  static DateTime getOneDayNextDate(DateTime dateTime, int duration) {
    return dateTime.add(Duration(days: duration));
  }

  /// 是否是同一天
  static bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }

  static String getTwoDigitsHours(DateTime dataTime) {
    if (dataTime != null) {
      return dataTime.toString().split(' ')[1].split(':')[0];
    }
    return '';
  }

  static String getTwoDigitsMinute(DateTime dataTime) {
    if (dataTime != null) {
      return dataTime.toString().split(' ')[1].split(':')[1];
    }
    return '';
  }

  static String getTwoDigitsMonth(DateTime dataTime) {
    if (dataTime != null) {
      return dataTime.toString().split(' ')[0].split('-')[1];
    }
    return '';
  }

  static String getTwoDigitsMonthDay(DateTime dataTime) {
    if (dataTime != null) {
      return dataTime.toString().split(' ')[0].split('-')[2];
    }
    return '';
  }

  static String getTwoDigitsMonthDay2(int monthDay) {
    if (monthDay != null) {
      if (monthDay >= 10) return "${monthDay}";
      return "0${monthDay}";
    }
    return '';
  }

  static String twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  static String fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  static String getYYYYMMDDHHMMSSString(DateTime dataTime) {
    if (dataTime != null) {
      String y = fourDigits(dataTime.year);
      String m = twoDigits(dataTime.month);
      String d = twoDigits(dataTime.day);
      String h = twoDigits(dataTime.hour);
      String min = twoDigits(dataTime.minute);
      String sec = twoDigits(dataTime.second);
      return "$y-$m-$d $h:$min:$sec";
    }
    return '';
  }

  static String getYYYYMMDDString(DateTime dataTime) {
    if (dataTime != null) {
      String y = fourDigits(dataTime.year);
      String m = twoDigits(dataTime.month);
      String d = twoDigits(dataTime.day);

      return "$y-$m-$d";
    }
    return '';
  }

  /// 时间间隔内的月数
  static int getMonths(DateTimeRange dateTimeRange) {
    if (dateTimeRange.end.year < dateTimeRange.start.year) {
      return 0;
    } else if (dateTimeRange.end.year == dateTimeRange.start.year) {
      return dateTimeRange.end.month - dateTimeRange.start.month + 1;
    } else {
      int months = 12 - dateTimeRange.start.month + 1;
      months += (dateTimeRange.end.year - dateTimeRange.start.year - 1) * 12;
      months += dateTimeRange.end.month;
      return months;
    }
  }

  /// 时间间隔内的周数
  static int getWeeks(DateTimeRange dateTimeRange) {
    //补齐前面的周
    int pre = dateTimeRange.start.weekday % 7;
    DateTime startTime = DateTime(dateTimeRange.start.year,
            dateTimeRange.start.month, dateTimeRange.start.day)
        .add(Duration(days: -pre));
    //补齐后面的周
    int after = 7 - dateTimeRange.end.weekday % 7;
    DateTime endTime = DateTime(dateTimeRange.end.year, dateTimeRange.end.month,
            dateTimeRange.end.day)
        .add(Duration(days: after));

    return (endTime.difference(startTime).inDays ~/ 7);
  }

  static String dateTimeRangeToString(DateTimeRange selectedDateTimeRange) {
    String dateString = ' — — ';
    if (CalendarDateUtils.isSameDay(
            selectedDateTimeRange.start, DateTime.now()) &&
        CalendarDateUtils.isSameDay(
            selectedDateTimeRange.end, DateTime.now())) {
      dateString = '今日';
    } else if (CalendarDateUtils.isSameDay(selectedDateTimeRange.start,
            DateTime.now().add(Duration(days: -1))) &&
        CalendarDateUtils.isSameDay(selectedDateTimeRange.end,
            DateTime.now().add(Duration(days: -1)))) {
      dateString = '昨日';
    } else if (CalendarDateUtils.isSameDay(selectedDateTimeRange.start,
            DateTime.now().add(Duration(days: -6))) &&
        CalendarDateUtils.isSameDay(
            selectedDateTimeRange.end, DateTime.now())) {
      dateString = '近7日';
    } else if (CalendarDateUtils.isSameDay(selectedDateTimeRange.start,
            DateTime.now().add(Duration(days: -29))) &&
        CalendarDateUtils.isSameDay(
            selectedDateTimeRange.end, DateTime.now())) {
      dateString = '近30日';
    } else {
      dateString = '${getYYYYMMDDString(selectedDateTimeRange.start)}'
          ' — '
          '${getYYYYMMDDString(selectedDateTimeRange.end)}';
    }
    return dateString;
  }
}
