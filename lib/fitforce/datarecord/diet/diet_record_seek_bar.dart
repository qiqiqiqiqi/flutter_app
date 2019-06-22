import 'package:flutter/material.dart';
import 'diet_record_seek_bar_painter.dart';

class DietRecordSeekBar extends StatefulWidget {
  final double progress;
  final double maxProgress;

  const DietRecordSeekBar(
      {@required this.progress, @required this.maxProgress});

  @override
  State<StatefulWidget> createState() {
    return DietREcordSeekBarState();
  }
}

class DietREcordSeekBarState extends State<DietRecordSeekBar>
    with TickerProviderStateMixin {
  AnimationController animationController;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      animationController.forward(from: 0);
    });

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animationController.addListener(() {
      setState(() {
        progress = animationController.value * widget.progress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        alignment: Alignment.center,
        child: CustomPaint(
          size: Size(152, 152),
          painter:
              DietRecordSeekBarPainter(progress: progress, maxProgress: 1800.0),
        ),
      );
    });
  }
}
