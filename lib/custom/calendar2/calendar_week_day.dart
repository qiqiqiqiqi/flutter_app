import 'package:flutter/material.dart';

class WeekDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: MediaQuery.of(context).size.width,
      child: CustomPaint(
        painter: WeekDayCustomPainter(),
      ),
    );
  }
}

class WeekDayCustomPainter extends CustomPainter {
  List<String> weekDays = ["日", "一", "二", "三", "四", "五", "六"];

  @override
  void paint(Canvas canvas, Size size) {
    double dayItemSize = size.width / 7;
    for (int i = 0; i < 7; i++) {
      canvas.save();
      TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: '${weekDays[i]}',
          style: TextStyle(
            color: Color(0xFF5D5D5D),
            fontSize: 16.0,
            fontStyle: FontStyle.normal,
          ),
        ),
      );
      textPainter.layout();
      canvas.translate(i * dayItemSize, 0);
      textPainter.paint(
        canvas,
        Offset(
          dayItemSize / 2 - textPainter.size.width / 2,
          size.height / 2 - textPainter.size.height / 2,
        ),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
