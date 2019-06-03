import 'package:flutter/material.dart';
import 'ruler.dart';

main() {
  runApp(MaterialApp(
    title: 'ruler demo',
    home: Scaffold(
      appBar: AppBar(title: Text('ruler demo')),
      body: Ruler(),
    ),
  ));
}
