import 'package:flutter/material.dart';
import 'ruler.dart';

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
  bool targetOffstage = false;
  List<bool> targetOffstages = [false, false, false];

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
            ),
            Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 65),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return buildItem(index);
              },
              itemCount: 3,
            ))
          ],
        );
      }),
    );
  }

  Widget buildItem(int index) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
            boxShadow: [
              ///阴影颜色/位置/大小等
              BoxShadow(
                color: Colors.grey[200], offset: Offset(1, 1),

                ///模糊阴影半径
                blurRadius: 4,
              ),
              BoxShadow(
                  color: Colors.grey[200],
                  offset: Offset(-1, -1),
                  blurRadius: 4),
              BoxShadow(
                  color: Colors.grey[100],
                  offset: Offset(1, -1),
                  blurRadius: 4),
              BoxShadow(
                  color: Colors.grey[100], offset: Offset(-1, 1), blurRadius: 4)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, top: 16, bottom: 16),
              child: Text(
                '体重',
                style: TextStyle(color: Color(0xFF374147), fontSize: 14),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Divider(
                height: 1,
                color: Color(0xFFF2F4F5),
              ),
            ),
            Offstage(
              offstage: !targetOffstages[index],
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      '当前体重',
                      style: TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
                    ),
                    Container(
                      /*foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [Color(0x66ffffff), Color(0xFFE4E6EB), Color(0x66ffffff)],
                      )),*/
                      padding: EdgeInsets.only(
                        top: 15,
                        bottom: 30,
                      ),
                      child: Ruler(
                        width: constraints.maxWidth - 128,
                        height: 80,
                      ),
                    ),
                    Text(
                      '目标体重',
                      style: TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 15,
                        bottom: 30,
                      ),
                      child: Ruler(
                        width: constraints.maxWidth - 128,
                        height: 80,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: targetOffstages[index],
              child: InkWell(
                onTap: () {
                  setState(() {
                    targetOffstages[index] = !targetOffstages[index] ;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Color(0xFF1AD9CA),
                        size: 16,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          '设定目标',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF1AD9CA)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
