import 'package:flutter/material.dart';
import 'custom_drag_gesture_recognizer.dart';

typedef GestureDragUpdateCallback = void Function(DragUpdateDetails details);

typedef GestureDragDownCallback = void Function(DragDownDetails details);

typedef GestureDragStartCallback = void Function(DragStartDetails details);

typedef GestureDragEndCallback = void Function(DragEndDetails details);

typedef GestureDragCancelCallback = void Function();

class CustomGestureDetector extends GestureDetector {
  /// A pointer has contacted the screen and might begin to move.
  final GestureDragDownCallback onPanDown;

  /// A pointer has contacted the screen and has begun to move.
  final GestureDragStartCallback onPanStart;

  /// A pointer that is in contact with the screen and moving has moved again.
  final GestureDragUpdateCallback onPanUpdate;

  /// A pointer that was previously in contact with the screen and moving
  /// is no longer in contact with the screen and was moving at a specific
  /// velocity when it stopped contacting the screen.
  final GestureDragEndCallback onPanEnd;

  /// The pointer that previously triggered [onPanDown] did not complete.
  final GestureDragCancelCallback onPanCancel;
  Widget child;
  Direction direction;

  CustomGestureDetector(
      {Key key,
      this.child,
      this.direction,
      this.onPanDown,
      this.onPanStart,
      this.onPanUpdate,
      this.onPanCancel,
      this.onPanEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<Type, GestureRecognizerFactory> gestures =
        <Type, GestureRecognizerFactory>{};

    if (onPanDown != null ||
        onPanStart != null ||
        onPanUpdate != null ||
        onPanEnd != null ||
        onPanCancel != null) {
      gestures[CustomPanGestureReconizer] =
          GestureRecognizerFactoryWithHandlers<CustomPanGestureReconizer>(
        () => CustomPanGestureReconizer(
            debugOwner: this,
            direction: direction
                ),
        (CustomPanGestureReconizer instance) {
          instance
            ..onDown = onPanDown
            ..onStart = onPanStart
            ..onUpdate = onPanUpdate
            ..onEnd = onPanEnd
            ..onCancel = onPanCancel
            ..dragStartBehavior = dragStartBehavior;
        },
      );
    }
    return RawGestureDetector(
      gestures: gestures,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      child: child,
    );
  }
}
