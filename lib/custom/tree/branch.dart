import 'dart:math';

import 'package:flutter_app/custom/tree/treeNode.dart';
import 'package:flutter_app/custom/tree/treeVector.dart';

class Branch {
  List<TreeNode> treeNodes = [];
  List<Branch> childs = [];
  TreeNode startNode;
  double length = 0;
  TreeVector treeVector;
  int generation;

  TreeNode get endNode {
    if (treeNodes != null && treeNodes.isNotEmpty) {
      return treeNodes[treeNodes.length - 1];
    }
    return null;
  }

  Branch({this.startNode, this.generation = 1, this.treeVector}) {
    treeNodes.add(startNode);
  }

  addTreeNode() {}

  Branch clone() {
    TreeVector treeVector = TreeVector(
        point: Point(this.treeVector.point.x, this.treeVector.point.y));
    return Branch(
        startNode: this.endNode,
        generation: this.generation + 1,
        treeVector: treeVector);
  }

  @override
  String toString() {
    return 'Branch{length: $length, generation: $generation}';
  }
}
