import 'package:flutter/material.dart';
import 'package:flutter_app/custom/boom/Sandable.dart';

main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("boom demo"),
      ),
      body: Center(
        child: BoomDemo(),
      ),
    ),
  ));
}

class BoomDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(

          alignment: Alignment.center,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Center(
            child: Container(
              child: Sandable(
                child: Image.asset(
                  "images/boat.png",
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
                duration: Duration(milliseconds: 1000),
                numberOfLayers: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}
