import 'package:flutter/material.dart';
import 'package:flutter_app/custom/calendar2/calendar_enum.dart';
import 'package:flutter_app/custom/calendar2/panel.dart';
import 'package:flutter_app/custom/calendar2/week/calendar_week.dart';

import 'calendar_week_day.dart';
import 'month/calendar.dart';
import 'utils/calendar_date_utils.dart';

main() {
  runApp(
    MaterialApp(
      title: "calendar demo",
      home: CalendarPanel(),
    ),
  );
}

class CalendarPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalendarPanelState();
  }
}

class CalendarPanelState extends State<CalendarPanel> {
  PanelController panelController = PanelController();
  DateTime selectedTime = DateTime.now();
  final double weekHeight = 48;
  final double lineHeight = 33;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${selectedTime.year}-${selectedTime.month}-${selectedTime.day}"),
      ),
      body: buildPanel(),
    );
  }

  Widget buildPanel() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 48 +周条目的高度+ 33
        double marginTop =
            (constraints.maxHeight - weekHeight - lineHeight) / 6 +
                weekHeight +
                lineHeight;
        return Stack(
          children: [
            SlidingUpPanel(
              controller: panelController,
              slideDirection: SlideDirection.DOWN,
              maxHeight: constraints.maxHeight,
              minHeight: marginTop,
              parallaxEnabled: true,
              isDraggable: true,
              parallaxOffset: 0.5,
              body: Container(
                margin: EdgeInsets.only(top: marginTop),
                height: constraints.maxHeight - marginTop,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height -
                            constraints.maxHeight,
                      )
                    ],
                  ),
                ),
              ),
              panel: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Container(
                  margin: EdgeInsets.only(top: weekHeight),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return Container(
                                child: Stack(
                                  children: [
                                    /// month
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Visibility(
                                        child: Container(
                                          child: Transform(
                                            transform:
                                                Matrix4.translationValues(
                                                    0, 0, 0),
                                            child: Opacity(
                                              opacity:
                                                  panelController.isAttached
                                                      ? panelController
                                                          .panelPosition
                                                      : .0,
                                              child: calendarContainer(
                                                viewMode: ViewMode.month,
                                                physics: panelController
                                                        .isPanelOpen
                                                    ? BouncingScrollPhysics()
                                                    : NeverScrollableScrollPhysics(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// week
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: IgnorePointer(
                                        //展开后不响应事件
                                        ignoring: panelController.isAttached &&
                                            panelController.isPanelOpen,
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height: (constraints.maxHeight) / 6,
                                            child: Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      0, 0, 0),
                                              child: Opacity(
                                                opacity: 1 -
                                                    (panelController.isAttached
                                                        ? panelController
                                                            .panelPosition
                                                        : .0),
                                                child: calendarContainer(
                                                  viewMode: ViewMode.week,
                                                  physics: panelController
                                                              .isAttached &&
                                                          panelController
                                                              .isPanelClosed
                                                      ? BouncingScrollPhysics()
                                                      : NeverScrollableScrollPhysics(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                          // if (panelController.isPanelClosed) {
                          //   panelController.open();
                          // } else {
                          //   panelController.close();
                          // }
                        },
                        child: Container(
                          height: lineHeight,
                          child: Container(
                            width: 32,
                            height: 3,
                            margin: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFFADAFAF),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18.0),
                bottomRight: Radius.circular(18.0),
              ),
              onPanelSlide: (position) {
                setState(() {});
              },
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                height: weekHeight,
                color: Color(0xFFF5F8F7),
                child: WeekDay(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget calendarContainer(
      {ViewMode viewMode = ViewMode.month, ScrollPhysics physics}) {
    return CalendarContainer(
      scrollDirection: Axis.horizontal,
      dateTimeRange: DateTimeRange(
        start: DateTime(DateTime.now().year, DateTime.now().month),
        end: DateTime(2022, 9, CalendarDateUtils.getMonthDays(2022, 9)),
      ),
      selectedDateTimeRange: DateTimeRange(
        start: selectedTime,
        end: selectedTime,
      ),
      selectedDateTime: selectedTime,
      boundaryMode: BoundaryMode.all,
      selectMode: SelectMode.single,
      viewMode: viewMode,
      onSelectedDateTimeRange: (DateTimeRange dateTimeRange) {},
      onSelectedDateTime: (DateTime dateTime) {
        print("calendarContainer-onSelectedDateTime():dateTime=$dateTime");
        setState(() {
          selectedTime = dateTime;
        });
      },
      physics: physics,
    );
  }
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
  final ScrollPhysics physics;

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
    this.physics,
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
              ? widget.viewMode == ViewMode.month
                  ? (widget.dateTimeRange.start
                          .isBefore(widget.selectedDateTimeRange.start)
                      ? CalendarDateUtils.getMonths(
                            DateTimeRange(
                              start: widget.dateTimeRange.start,
                              end: widget.selectedDateTimeRange.start,
                            ),
                          ) -
                          1
                      : 0)
                  : (widget.dateTimeRange.start
                          .isBefore(widget.selectedDateTime)
                      ? CalendarDateUtils.getWeeks(
                            DateTimeRange(
                              start: widget.dateTimeRange.start,
                              end: widget.selectedDateTime,
                            ),
                          ) -
                          1
                      : 0)
              : 0,
          boundaryMode: widget.boundaryMode,
          onSelectedDateTimeRange: widget.onSelectedDateTimeRange,
          onSelectedDateTime: widget.onSelectedDateTime,
          selectMode: widget.selectMode,
          viewMode: widget.viewMode,
          physics: widget.physics,
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
  final ScrollPhysics physics;

  HorizontalContainer(
      {this.dateTimeRange,
      this.selectedDateTimeRange,
      this.selectedDateTime,
      this.itemCount,
      this.initialPage,
      this.boundaryMode,
      this.selectMode,
      this.viewMode,
      this.onSelectedDateTime,
      this.onSelectedDateTimeRange,
      this.physics});

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
          print("HorizontalContainerState-constraints0=$constraints");
          return Container(
            child: widget.viewMode == ViewMode.month
                ? Expanded(
                    child: buildMonthPageViewItem(),
                  )
                : Container(
                    child: buildWeekPageViewItem(),
                  ),
          );
        },
      ),
    );
  }

  Widget buildWeekPageViewItem() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: pageController,
      itemCount: widget.itemCount,
      physics: widget.physics,
      itemBuilder: (BuildContext context, int index) {
        DateTime dateTime = CalendarDateUtils.getNextWeek(
            CalendarDateUtils.startWeekDayOf(widget.dateTimeRange.start),
            index);
        return Container(
          child: CalendarWeek(
            selectedDateTimeRange: selectedDateTimeRange.value,
            selectedDateTime: widget.selectedDateTime,
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
            currentSelectedDateTime = CalendarDateUtils.getNextWeek(
              CalendarDateUtils.startWeekDayOf(widget.dateTimeRange.start),
              index,
            );
          },
        );
      },
    );
  }

  Widget buildMonthPageViewItem() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: pageController,
      itemCount: widget.itemCount,
      physics: widget.physics,
      itemBuilder: (BuildContext context, int index) {
        DateTime dateTime =
            CalendarDateUtils.getNextMonth(widget.dateTimeRange.start, index);
        return Container(
          child: Calendar(
            selectedDateTimeRange: selectedDateTimeRange.value,
            selectedDateTime: widget.selectedDateTime,
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
