import 'package:flutter/material.dart';

enum BoundaryMode { before, after, all }
enum SelectMode { single, multiple }
enum ViewMode { week, month }

typedef OnSelectedDateTime = void Function(DateTime dateTime);
typedef OnSelectedDateTimeRange = void Function(DateTimeRange dateTimeRange);
