import 'package:flutter/material.dart';

import 'dash_path.dart';

class SportRecordDecoration extends Decoration {
  int position = 0;
  double offsetLeft;
  double offsetTop;
  double offsetRight;
  double offsetBottom;
  int itemCount = 0;

  SportRecordDecoration(
      {@required this.position,
      this.offsetLeft = 0,
      this.offsetTop = 0,
      this.offsetRight = 0,
      this.offsetBottom = 0,
      @required this.itemCount});

  @override
  BoxPainter createBoxPainter([onChanged]) {
    return SportRecordDecorationBoxPainter(
        position: position,
        offsetLeft: offsetLeft,
        offsetTop: offsetTop,
        offsetRight: offsetRight,
        offsetBottom: offsetBottom,
        itemCount: itemCount);
  }
}

class SportRecordDecorationBoxPainter extends BoxPainter {
  int position = 0;
  double offsetLeft;
  double offsetTop;
  double offsetRight;
  double offsetBottom;
  int itemCount = 0;

  SportRecordDecorationBoxPainter(
      {@required this.position,
      this.offsetLeft,
      this.offsetTop,
      this.offsetRight,
      this.offsetBottom,
      @required this.itemCount});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Offset leftTop = configuration.size.topLeft(Offset(offset.dx, 0));
    final Offset centerLeft =
        configuration.size.centerLeft(Offset(offset.dx, 0));
    final Offset bottomRight = configuration.size.bottomRight(offset);
    print(
        'DietRecordDecorationBoxPainter--paint():position=$position,offset=$offset,${configuration.size},'
        'leftTop=$leftTop,bottomRight=$bottomRight,centerLeft=$centerLeft');
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Color(0xFFE4E4E4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.save();
    Path path = Path();
    if (position != 0) {
      if (position != itemCount - 1) {
        path.moveTo(offsetLeft + leftTop.dx, leftTop.dy);
        path.lineTo(offsetLeft + leftTop.dx, offsetTop + leftTop.dy);
      } else {
        path.moveTo(offsetLeft + leftTop.dx, leftTop.dy);
        path.lineTo(offsetLeft + leftTop.dx, configuration.size.height / 2);
      }
      canvas.drawPath(
        dashPath(
          path,
          dashArray: CircularIntervalList<double>(<double>[3.0, 3.0]),
        ),
        paint,
      );
    }
    if (position != itemCount - 1) {
      path.moveTo(offsetLeft + leftTop.dx, bottomRight.dy - offsetBottom);
      path.lineTo(offsetLeft + leftTop.dx, bottomRight.dy);
      canvas.drawPath(
        dashPath(
          path,
          dashArray: CircularIntervalList<double>(<double>[3.0, 3.0]),
        ),
        paint,
      );
    }
    canvas.restore();
  }
}
