import 'dart:math'as Math;
import 'package:flutter/material.dart';
class TreeUtil {
  static double random(double min, double max) {
    return Math.Random().nextDouble() * (max - min) + min;
  }

  static Color randomRGBA(double min, double max, double a) {
    return Color.fromRGBO(random(min, max).round(), random(min, max).round(),
        random(min, max).round(), a);
  }
}
