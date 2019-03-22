import 'package:flutter/material.dart';
import 'package:flutter_app/custom/dragcard/custom_drag_gesture_recognizer.dart';
import 'DragCard.dart';
import 'custom_gesture_detector.dart';
class PullContentContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PullContentState();
  }
}

class PullContentState extends State<PullContentContainer> {
  List<Widget> widgets;
  Offset offset = Offset(0, 0);

  @override
  void initState() {
    super.initState();
  }

  List<Widget> getWidgets() {
    widgets = List();
    for (int i = 0; i < 4; i++) {
      DragCard dragCard = DragCard(
        position: i,
        offset: offset,
      );
      if (i == 0) {
        widgets.add(CustomGestureDetector(
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          child: dragCard,
          direction: Direction.top | Direction.left | Direction.right,
        )
           /* Listener(
              onPointerMove: onPointerMove,
              onPointerUp: onPointerUp,
              child: dragCard,
            )*/);
      } else {
        widgets.add(dragCard);
      }
    }
    widgets = widgets.reversed.toList();
    return widgets;
  }

  void onPointerMove(PointerMoveEvent dragUpdateDetails) {
    print("PullContentContainer:onPanUpdate():"
        "dragUpdateDetails.delta=${dragUpdateDetails.delta}");
    setState(() {
      offset == null
          ? offset = dragUpdateDetails.delta
          : offset += dragUpdateDetails.delta;
    });
  }

  void onPointerUp(PointerUpEvent dragEndDetails) {
    print("PullContentContainer:onPanEnd():");
    setState(() {
      offset = Offset(0, 0);
    });
  }

  void onPanUpdate(DragUpdateDetails dragUpdateDetails) {
    print("PullContentContainer:onPanUpdate():"
        "dragUpdateDetails.delta=${dragUpdateDetails.delta}");
    setState(() {
      offset == null
          ? offset = dragUpdateDetails.delta
          : offset += dragUpdateDetails.delta;
    });
  }

  void onPanEnd(DragEndDetails dragEndDetails) {
    print("PullContentContainer:onPanEnd():");
    setState(() {
      offset = Offset(0, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: getWidgets(),
    );
  }
}
