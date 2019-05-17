class DateUtils {
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
  /// @return 日：1		一：2		二：3		三：4		四：5		五：6		六：7
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
}
