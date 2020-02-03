import 'package:flutter/material.dart';
import 'package:flutter_app/custom/tree/treeNode.dart';
import 'package:flutter_app/custom/tree/treePainter.dart';
import 'dart:math' as Math;
import 'package:flutter_app/custom/tree/branch.dart';
import 'package:flutter_app/custom/tree/tree.dart';
import 'package:flutter_app/custom/tree/treeUtil.dart';
import 'package:flutter_app/custom/tree/treeVector.dart';

main() {
  runApp(MaterialApp(
    title: "TreeWidget Demo",
    home: Scaffold(
      appBar: AppBar(
        title: Text("TreeWidget Demo"),
      ),
      body: TreeWidget(),
    ),
  ));
}

class TreeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TreeWidgetState();
  }
}

class TreeWidgetState extends State with TickerProviderStateMixin {
  AnimationController _animationController;
  double r = 20;
  double ratio = 0.99;
  Tree tree;
  GlobalKey globalKey;
  Size size;

  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey();
    _animationController = AnimationController(vsync: this);
    _animationController.addListener(() {});
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        color: Colors.black,
        child: SizedBox(
          key: globalKey,
          width: constraints.biggest.width,
          height: constraints.biggest.height,
          child: CustomPaint(
            painter: TreePainter(tree: tree),
          ),
        ),
      );
    });
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (mounted) {
        setState(() {
          size = globalKey.currentContext.size;

          tree = Tree(
            color: TreeUtil.randomRGBA(0, 255, 0.3),
            position: Math.Point(size.width / 2, size.height),
            treeVector:
                TreeVector(point: Math.Point(TreeUtil.random(-1, 1), -2)),
          );
          Branch branch = Branch(
              treeVector: tree.treeVector,
              startNode: TreeNode(
                  point: Math.Point(size.width / 2, size.height), r: r));
          grow(branch);
          tree.branchs.add(branch);
        });
      }
    });
  }

  grow(Branch branch) {
    double angle =
        branch.generation == 1 ? 0 : 0.18 - (0.10 / branch.generation);
    if (branch.treeNodes.isNotEmpty) {
      branch.treeNodes.add(TreeNode(
          point: branch.treeNodes.last.point + branch.treeVector.point,
          r: branch.treeNodes.last.r * 0.99));
    } else {
      branch.treeNodes.add(
          TreeNode(point: tree.position + tree.treeVector.point, r: r * 0.99));
    }
    branch.length += branch.treeVector.length();
    if (branch.generation != 1) {
      branch.treeVector
          .rotate(TreeUtil.random(-angle, angle), branch.generation);
    }
    double dt = branch.length - TreeUtil.random(40, 80);
    if (dt > 0) {
      fork(branch);
      return;
    }
    if (branch.treeNodes.last.r < 0.8 || branch.generation > 10) {
      //add leaf
      return;
    } else {
      grow(branch);
    }
  }

  //分叉
  fork(Branch branch) {
    int n = TreeUtil.random(1, 3).round();
    for (int i = 0; i < n; i++) {
      Branch childBranch = branch.clone();
      branch.childs.add(childBranch);
      grow(childBranch);
    }
  }
}
