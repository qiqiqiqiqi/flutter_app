import 'package:flutter/material.dart';
import 'cardwidget.dart';

class CardRecord {
  Offset offset;
  int index;

  CardRecord({this.offset = const Offset(0, 0), this.index});
}

mixin CardMixin {
  void next() {}

  void previous() {}
}

class CardController with CardMixin {
  CardMixin cardMixin;

  @override
  void next() {
    if (cardMixin != null) {
      cardMixin.next();
    }
  }

  @override
  void previous() {
    if (cardMixin != null) {
      cardMixin.previous();
    }
  }
}

class CardContainer extends StatefulWidget {
  List<double> datas = [0.0, 1.0, 2.0, 3.0];

  CardController cardController;

  CardContainer({@required this.cardController});

  @override
  State<StatefulWidget> createState() {
    return CardContainerState();
  }
}

class CardContainerState extends State<CardContainer>
    with TickerProviderStateMixin, CardMixin {
  Offset currentOffset;
  CardRecord currentCardRecord;
  AnimationController _animationController;
  Tween<double> _tween;
  Map<double, CardRecord> _itemCardRecordMap;
  double maxWidth;
  double maxHeight;
  bool reverse = false;
  List<double> removeDatas = [];

  @override
  void dispose() {
    super.dispose();
    widget.cardController?.cardMixin = null;
  }

  @override
  void initState() {
    super.initState();
    widget.cardController?.cardMixin = this;
    _itemCardRecordMap = Map();
    for (int i = 0; i < widget.datas.length; i++) {
      _itemCardRecordMap[widget.datas[i]] = CardRecord(index: i);
    }
    currentCardRecord = _itemCardRecordMap[widget.datas[0]];
    currentOffset =
        Offset(currentCardRecord.offset.dx, currentCardRecord.offset.dy);
    initAnima();
  }

  void initAnima() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _tween = Tween();
    Animation<double> animate = _tween.animate(_animationController);
    animate.addListener(() {
      double value = animate.value;
      setState(() {
        //记录移除时的偏移量，等待进入时赋值为开始偏移
        currentCardRecord.offset =
            Offset(value, currentOffset.dy * (value / currentOffset.dx));
      });
      print(
          'CardContainerState--initState()--addListener():value=$value,currentCardRecord.offset=${currentCardRecord.offset}');
    });
    animate.addStatusListener((AnimationStatus status) {
      print(
          'CardContainerState--initState()--addStatusListener():status=$status');
      if (AnimationStatus.completed == status) {
        setState(() {
          if (!reverse) {
            removeDatas.add(removeFirst());
          } else {
            _itemCardRecordMap[widget.datas[0]].offset = Offset(0, 0);
            currentCardRecord = _itemCardRecordMap[widget.datas[0]];
            currentOffset = currentCardRecord.offset;
          }
        });
      }
    });
  }

  void startAnima(Offset sourceOffset, bool reverse) {
    this.reverse = reverse;
    currentOffset = Offset(sourceOffset.dx, sourceOffset.dy);
    if (!_animationController.isAnimating) {
      _animationController.reset();
      if (reverse) {
        _tween.begin = sourceOffset.dx;
        _tween.end = 0;
        _animationController.forward();
      } else {
        _tween.begin = 0;
        _tween.end = sourceOffset.dx;
        _animationController.forward();
      }
    }
  }

  List<Widget> getWidgets() {
    List<Widget> widgets = List();
    for (int i = 0; i < widget.datas.length; i++) {
      DragCard dragCard = DragCard(
        position: i,
        offset: currentCardRecord.offset,
      );
      if (i == 0) {
        widgets.add(GestureDetector(
          onPanDown: onPanDown,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          child: dragCard,
        ));
      } else {
        widgets.add(dragCard);
      }
    }
    widgets = widgets.reversed.toList();
    return widgets;
  }

  void onPanDown(DragDownDetails details) {}

  void onPanUpdate(DragUpdateDetails dragUpdateDetails) {
    print("CardContainer:onPanUpdate():"
        "dragUpdateDetails.delta=${dragUpdateDetails.delta}");
    setState(() {
      currentOffset == null
          ? currentOffset = dragUpdateDetails.delta
          : currentOffset += dragUpdateDetails.delta;
      currentCardRecord.offset = Offset(currentOffset.dx, currentOffset.dy);
    });
  }

  void onPanEnd(DragEndDetails dragEndDetails) {
    print("CardContainer:onPanEnd():");
    if (widget.datas.length > 1 &&
        (currentOffset.dy.abs() >= maxHeight / 2 ||
            currentOffset.dx.abs() >= maxWidth / 2)) {
      setState(() {
        //removeFirst();
        startAnima(currentOffset, false);
      });
    } else {
      startAnima(currentCardRecord.offset, true);
    }
  }

  dynamic removeFirst() {
    var data = widget.datas.removeAt(0);
    currentCardRecord = _itemCardRecordMap[widget.datas[0]];
    currentOffset = currentCardRecord.offset;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      print('CardContainerState--build():constraints=$constraints');
      maxWidth = constraints.maxWidth;
      maxHeight = constraints.maxHeight;
      return Stack(
        children: getWidgets(),
      );
    });
  }

  @override
  void next() {
    print('CardContainerState--next()');
    if (widget.datas.length > 1) {
      startAnima(Offset(-maxWidth / 2, -maxHeight / 2), false);
    }
  }

  @override
  void previous() {
    print('CardContainerState--previous()');
    if (removeDatas.isNotEmpty) {
      widget.datas.insert(0, removeDatas.removeLast());
      // startAnima(Offset(-maxWidth / 2, -maxHeight / 2), true);
      startAnima(_itemCardRecordMap[widget.datas[0]].offset, true);
    }
  }
}
