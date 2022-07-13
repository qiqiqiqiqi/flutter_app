import 'package:flutter/material.dart';
import 'package:flutter_app/custom/calendar2/calendar_enum.dart';
import 'package:flutter_app/custom/calendar2/week/calendar_week.dart';

import 'calendar_week_day.dart';
import 'month/calendar.dart';
import 'utils/calendar_date_utils.dart';

main() {
  runApp(
    MaterialApp(
      title: "calendar demo",
      home: Scaffold(
        appBar: AppBar(title: Text("calendar demo")),
        body: CalendarContainer(
          scrollDirection: Axis.horizontal,
          dateTimeRange: DateTimeRange(
            start: DateTime.now(),
            end: DateTime(2022, 9),
          ),
          selectedDateTimeRange: DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now(),
          ),
          selectedDateTime: DateTime.now(),
          boundaryMode: BoundaryMode.all,
          selectMode: SelectMode.single,
          viewMode: ViewMode.week,
          onSelectedDateTimeRange: (DateTimeRange dateTimeRange) {},
          onSelectedDateTime: (DateTime dateTime) {},
        ),
      ),
    ),
  );
}

class CalendarContainer extends StatefulWidget {
  final Axis scrollDirection;
  final DateTimeRange dateTimeRange;
  final DateTimeRange selectedDateTimeRange;
  final DateTime selectedDateTime;
  final BoundaryMode boundaryMode;
  final OnSelectedDateTimeRange onSelectedDateTimeRange;
  final OnSelectedDateTime onSelectedDateTime;
  final SelectMode selectMode;
  final ViewMode viewMode;

  CalendarContainer({
    this.scrollDirection = Axis.vertical,
    this.dateTimeRange,
    this.selectedDateTimeRange,
    this.boundaryMode,
    this.onSelectedDateTimeRange,
    this.onSelectedDateTime,
    this.selectedDateTime,
    this.selectMode,
    this.viewMode,
  });

  @override
  State<StatefulWidget> createState() {
    return CalendarContainerState();
  }
}

class CalendarContainerState extends State<CalendarContainer> {
  @override
  Widget build(BuildContext context) {
    /* print('CalendarContainerState--build():getMonths=${DateUtils.getMonths(
      DateTimeRange(
        start: widget.dateTimeRange.start,
        end: widget.selectedDateTimeRange.start,
      ),
    )}，\nselectedDateTimeRange=${widget.selectedDateTimeRange}');*/
    switch (widget.scrollDirection) {
      case Axis.vertical:
        return VerticalContainer();
      case Axis.horizontal:
        return HorizontalContainer(
          dateTimeRange: widget.dateTimeRange,
          selectedDateTimeRange: widget.selectedDateTimeRange,
          selectedDateTime: widget.selectedDateTime,
          itemCount: widget.viewMode == ViewMode.month
              ? CalendarDateUtils.getMonths(widget.dateTimeRange)
              : CalendarDateUtils.getWeeks(widget.dateTimeRange),
          initialPage: widget.selectedDateTimeRange != null
              ? CalendarDateUtils.getMonths(
                    DateTimeRange(
                      start: widget.dateTimeRange.start,
                      end: widget.selectedDateTimeRange.start,
                    ),
                  ) -
                  1
              : 0,
          boundaryMode: widget.boundaryMode,
          onSelectedDateTimeRange: widget.onSelectedDateTimeRange,
          onSelectedDateTime: widget.onSelectedDateTime,
          selectMode: widget.selectMode,
          viewMode: widget.viewMode,
        );
    }
    return VerticalContainer();
  }
}

class VerticalContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          WeekDay(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          '${CalendarDateUtils.getNextMonth(DateTime.now(), index).year}-${CalendarDateUtils.getNextMonth(DateTime.now(), index).month}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Calendar(
                        dateTime: CalendarDateUtils.getNextMonth(
                          DateTime.now(),
                          index,
                        ),
                        onSelectedDateTime: (DateTime dateTime) {},
                      )
                    ],
                  ),
                );
              },
              itemCount: 100,
            ),
          )
        ],
      ),
    );
  }
}

class HorizontalContainer extends StatefulWidget {
  final DateTimeRange dateTimeRange;
  final DateTimeRange selectedDateTimeRange;
  final DateTime selectedDateTime;
  final int itemCount;
  final int initialPage;
  final BoundaryMode boundaryMode;
  final SelectMode selectMode;
  final ViewMode viewMode;
  final OnSelectedDateTime onSelectedDateTime;
  final OnSelectedDateTimeRange onSelectedDateTimeRange;

  HorizontalContainer({
    this.dateTimeRange,
    this.selectedDateTimeRange,
    this.selectedDateTime,
    this.itemCount,
    this.initialPage,
    this.boundaryMode,
    this.selectMode,
    this.viewMode,
    this.onSelectedDateTime,
    this.onSelectedDateTimeRange,
  });

  @override
  State<StatefulWidget> createState() {
    return HorizontalContainerState();
  }
}

class HorizontalContainerState extends State<HorizontalContainer> {
  DateTime currentSelectedDateTime;
  ValueNotifier<DateTimeRange> selectedDateTimeRange;
  DateTime selectedDateTime;
  PageController pageController;
  int currentPage;

  @override
  void initState() {
    super.initState();
    currentSelectedDateTime = CalendarDateUtils.getNextMonth(
        widget.dateTimeRange.start, widget.initialPage);
    selectedDateTimeRange = ValueNotifier(widget.selectedDateTimeRange);
    selectedDateTime = widget.selectedDateTime;
    pageController = PageController(
      initialPage: currentPage = widget.initialPage,
      keepPage: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: WeekDay(),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    currentSelectedDateTime.year == DateTime.now().year
                        ? '${currentSelectedDateTime.month}月'
                        : '${currentSelectedDateTime.year}年${currentSelectedDateTime.month}月',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, color: Color(0xFF2B2B2B)),
                  ),
                ),
                widget.viewMode == ViewMode.month
                    ? Expanded(
                        child: buildPageViewItem(),
                      )
                    : LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Container(
                            height: 80,
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: pageController,
                              itemCount: widget.itemCount,
                              itemBuilder: (BuildContext context, int index) {
                                DateTime dateTime =
                                    CalendarDateUtils.getNextWeek(
                                        CalendarDateUtils.startWeekDayOf(
                                            widget.dateTimeRange.start),
                                        index);
                                return Container(
                                  color: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: CalendarWeek(
                                    selectedDateTimeRange:
                                        selectedDateTimeRange.value,
                                    selectedDateTime: selectedDateTime,
                                    boundaryMode: widget.boundaryMode,
                                    selectMode: widget.selectMode,
                                    viewMode: widget.viewMode,
                                    dateTime: dateTime,
                                    onSelectedDateTime: (DateTime dateTime) {
                                      print(
                                          "calendar_container-onSelectedDateTime():dateTime=$dateTime");
                                      widget.onSelectedDateTime(dateTime);
                                      setState(() {
                                        selectedDateTime = dateTime;
                                        currentSelectedDateTime = dateTime;
                                      });
                                    },
                                    onSelectedDateTimeRange:
                                        (DateTimeRange dateTimeRange) {
                                      widget.onSelectedDateTimeRange(
                                          dateTimeRange);
                                      selectedDateTimeRange.value =
                                          dateTimeRange;
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                              onPageChanged: (int index) {
                                currentPage = index;
                                setState(
                                  () {
                                    currentSelectedDateTime =
                                        CalendarDateUtils.getNextWeek(
                                      CalendarDateUtils.startWeekDayOf(
                                          widget.dateTimeRange.start),
                                      index,
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      )
              ],
            ),
          );
        },
      ),
    );
  }

  PageView buildPageViewItem() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: pageController,
      itemCount: widget.itemCount,
      itemBuilder: (BuildContext context, int index) {
        DateTime dateTime =
            CalendarDateUtils.getNextMonth(widget.dateTimeRange.start, index);
        return Container(
          color: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Calendar(
            selectedDateTimeRange: selectedDateTimeRange.value,
            selectedDateTime: selectedDateTime,
            boundaryMode: widget.boundaryMode,
            selectMode: widget.selectMode,
            viewMode: widget.viewMode,
            dateTime: dateTime,
            onSelectedDateTime: (DateTime dateTime) {
              widget.onSelectedDateTime(dateTime);
              selectedDateTime = dateTime;
              setState(() {});
            },
            onSelectedDateTimeRange: (DateTimeRange dateTimeRange) {
              widget.onSelectedDateTimeRange(dateTimeRange);
              selectedDateTimeRange.value = dateTimeRange;
              setState(() {});
            },
          ),
        );
      },
      onPageChanged: (int index) {
        currentPage = index;
        setState(
          () {
            currentSelectedDateTime = CalendarDateUtils.getNextMonth(
              widget.dateTimeRange.start,
              index,
            );
          },
        );
      },
    );
  }

  @override
  void didUpdateWidget(HorizontalContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dateTimeRange != widget.dateTimeRange ||
        oldWidget.selectedDateTimeRange != widget.selectedDateTimeRange ||
        oldWidget.selectedDateTime != widget.selectedDateTime) {
      setState(() {
        if (widget.viewMode == ViewMode.month) {
          currentSelectedDateTime = CalendarDateUtils.getNextMonth(
            widget.dateTimeRange.start,
            widget.initialPage,
          );
          selectedDateTimeRange.value = widget.selectedDateTimeRange;
        } else {
          currentSelectedDateTime = CalendarDateUtils.getNextWeek(
            widget.dateTimeRange.start,
            widget.initialPage,
          );
          selectedDateTimeRange.value = widget.selectedDateTimeRange;
        }
      });
    }
    if (currentPage != widget.initialPage &&
        //
        !(oldWidget.selectedDateTimeRange.start
                .isAtSameMomentAs(oldWidget.selectedDateTimeRange.end) &&
            oldWidget.selectedDateTimeRange.start
                .isAtSameMomentAs(widget.selectedDateTimeRange.start))) {
      currentPage = widget.initialPage;
      pageController?.animateToPage(
        widget.initialPage,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }
}
