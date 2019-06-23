import 'package:flutter/material.dart';
import 'package:flutter_app/fitforce/datarecord/sleep/timeseekbar/sleepseekbarpage.dart';

main() {
  runApp( MaterialApp(
    home: Scaffold(
      body: Center(
        child: SleepSeekBarPage(
          onProgressChange:
              (DateTime startTime, DateTime endTime, int rangeTime) {
            print("SleepSeekBarPage():startTime=${startTime
                .toIso8601String()},endTime=${endTime.toIso8601String()}");
          },
          dayOffset: 0,
        ),
      ),
    ),
  ));
}
