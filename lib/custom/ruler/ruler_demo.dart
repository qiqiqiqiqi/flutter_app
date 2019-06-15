import 'package:flutter/material.dart';
import 'ruler.dart';

main() {
  runApp(MaterialApp(
    title: 'ruler demo',
    home: Scaffold(
      appBar: AppBar(title: Text('ruler demo')),
      body: Center(
        child: Ruler(
          height: 80,
          onSelectedValue: (BuildContext context,double value) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('$value')));
          },
        ),
      ),
    ),
  ));
}
