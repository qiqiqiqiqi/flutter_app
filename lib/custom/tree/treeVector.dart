import 'dart:math' as Math;

class TreeVector {
  Math.Point point;

  TreeVector({this.point});

  length() {
    return Math.sqrt(this.point.x * this.point.x + this.point.y * this.point.y);
  }

  rotate(double angle, int generation) {
    //angle = angle / 180 * Math.pi;
    this.point = Math.Point(
        Math.cos(angle) * this.point.x - Math.sin(angle) * this.point.y,
        Math.sin(angle) * this.point.x + Math.cos(angle) * this.point.y);
//    if (generation == 1) {
//      print(
//          "TreeVector--rotate():point=${this.point.toString()},generation=$generation");
//    }
  }
}
