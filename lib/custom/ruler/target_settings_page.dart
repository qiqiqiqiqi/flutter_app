import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    home: TargetSettingsPage(),
  ));
}

class TargetSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TargetSettingsPageState();
  }
}

class TargetSettingsPageState extends State<TargetSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF1F1A20),
            ),
            onPressed: null),
        centerTitle: true,
        title: Text(
          '设置目标',
          style: TextStyle(fontSize: 18, color: Color(0xFF1F1A20)),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            alignment: AlignmentDirectional.center,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {},
              child: Text(
                '完成',
                style: TextStyle(color: Color(0xFF1AD9CA), fontSize: 16),
              ),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    size: 10.15,
                    color: Color(0xFFAAB2B7),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 11),
                    child: Text(
                      '一次仅能设定一个目标',
                      style: TextStyle(fontSize: 12, color: Color(0xFFAAB2B7)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                  color: Color(0xFFF2F4F5),
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
              child: Text(
                '控制体重',
                style: TextStyle(color: Color(0xFF374147), fontSize: 16),
              ),
            )
          ],
        );
      }),
    );
  }
}
