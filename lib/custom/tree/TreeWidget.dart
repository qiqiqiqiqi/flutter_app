import 'package:flutter/material.dart';
import 'package:flutter_app/custom/tree/TreeNode.dart';
import 'TreePainter.dart';
import 'dart:math' as Math;

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
  Map<int, List<TreeNode>> treeNodeMap = Map();
  TreeNode rootTreeNode = TreeNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.addListener(() {});
    fillLeftRightNode(rootTreeNode, 3);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        width: constraints.biggest.width,
        height: constraints.biggest.height,
        color: Colors.black,
        child: CustomPaint(
          painter: TreePainter(color: Colors.white, rootTreeNode: rootTreeNode),
        ),
      );
    });
  }

  void fillLeftRightNode(TreeNode rootTreeNode, int depth) {
    if (depth > 0) {
      rootTreeNode.left = TreeNode();
      rootTreeNode.right = TreeNode();
      fillLeftRightNode(rootTreeNode.left, depth - 1);
      fillLeftRightNode(rootTreeNode.right, depth - 1);
    }
  }
}
