import 'package:flutter/material.dart';
import 'ThumbWidget.dart';

void main() {
  ThumbController thumbController = ThumbController();
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          thumbController.startAnima(index: 3);
        },
        child: Text('anima'),
      ),
      body: Center(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                thumbController.startAnima(index: index);
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: <Widget>[
                    ThumbWidget(
                      imagePath: 'images/data_record_naozhong.png',
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('title title title'),
                            Text('sub title')
                          ],
                        ),
                      ),
                      thumbController: thumbController,
                      index: index,
                      width: 50,
                      height: 50,
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.blueAccent,
              height: 1,
            );
          },
          itemCount: 200,
        ),
      ),
    ),
  ));
}
