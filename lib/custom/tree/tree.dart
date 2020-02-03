import 'package:flutter/material.dart';
import 'package:flutter_app/custom/tree/branch.dart';


import 'dart:math' as Math;

import 'package:flutter_app/custom/tree/treeVector.dart';

class Tree {
  List<Branch> branchs=[];
  Color color;
  TreeVector treeVector;
  Math.Point position;

  Tree({this.color, this.treeVector, this.position});
}
