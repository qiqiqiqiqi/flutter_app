import 'package:flutter/material.dart';
import 'package:flutter_app/fitforce/datarecord/common_round_button.dart';
import 'diet_record_seek_bar.dart';
import 'diet_record_decoration.dart';
import 'diet_add_dialog.dart';
main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: DietRecordPage(),
    ),
  ));
}

class DietRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DietRecordPageState();
  }
}

class DietRecordPageState extends State<DietRecordPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                buildDietSeekBar(),
                buildDietKcalDeatils(),
                buildDietList()
              ],
            )),
            StatefulRoundButton(
              margin: EdgeInsets.only(left: 38, right: 38, bottom: 12 /*46*/),
              disable: true,
              disableBackgroundColor: Color(0xFFE8E9EB),
              pressBackgroundColor: Color(0x9F1AD9CA),
              normalBackgroundColor: Color(0xFF1AD9CA),
              height: 45,
              raduis: 4,
              child: Text(
                '完成',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.none),
              ),
              onPress: () {},
            )
          ],
        ),
      );
    });
  }

  SliverToBoxAdapter buildDietKcalDeatils() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 32, right: 32, top: 30, bottom: 34),
        child: Row(
          children: <Widget>[
            Expanded(
                child: RichText(
              text: TextSpan(
                  text: '45',
                  style: TextStyle(
                      color: Color(0xFF374147),
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' g',
                        style: TextStyle(
                            color: Color(0xFFB9B8B8),
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '\n蛋白',
                        style: TextStyle(
                            color: Color(0xFFB9B8B8),
                            fontSize: 14,
                            fontWeight: FontWeight.bold))
                  ]),
              textAlign: TextAlign.center,
            )),
            Container(
              width: 1,
              height: 30,
              color: Color(0xFFF3F3F3),
            ),
            Expanded(
                child: RichText(
              text: TextSpan(
                  text: '26',
                  style: TextStyle(
                      color: Color(0xFF374147),
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' g',
                        style: TextStyle(
                            color: Color(0xFFB9B8B8),
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '\n碳水',
                        style: TextStyle(
                            color: Color(0xFFB9B8B8),
                            fontSize: 14,
                            fontWeight: FontWeight.bold))
                  ]),
              textAlign: TextAlign.center,
            )),
            Container(
              width: 1,
              height: 30,
              color: Color(0xFFF3F3F3),
            ),
            Expanded(
                child: RichText(
              text: TextSpan(
                  text: '38',
                  style: TextStyle(
                      color: Color(0xFF374147),
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' g',
                        style: TextStyle(
                            color: Color(0xFFB9B8B8),
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '\n脂肪',
                        style: TextStyle(
                            color: Color(0xFFB9B8B8),
                            fontSize: 14,
                            fontWeight: FontWeight.bold))
                  ]),
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildDietSeekBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 26),
        child: DietRecordSeekBar(progress: 1024.0, maxProgress: 1800.0),
      ),
    );
  }

  SliverList buildDietList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return Container(
        decoration: DietRecordDecoration(
            position: index,
            offsetTop: 25,
            offsetLeft: 12,
            offsetBottom: 6,
            itemCount: 20),
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 6, top: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 13),
              child: Image.asset(
                'images/datarecord/ic_bate_wucna.png',
                package: 'hb_solution',
                width: 24,
                height: 24,
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 17),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.only(left: 2, right: 2, top: 50),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4)),
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  offset: Offset(-1, 0),
                                  blurRadius: 4,
                                  color: Colors.grey[200]),
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 4,
                                  color: Colors.grey[200])
                            ]),
                        child: ListView.separated(
                            padding: EdgeInsets.all(0),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 20),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text('小龙虾',
                                            style: TextStyle(
                                                color: Color(0xFF57595D),
                                                fontSize: 14))),
                                    Text('100g',
                                        style: TextStyle(
                                            color: Color(0xFF57595D),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Image.asset(
                                        'images/datarecord/ic_date_delete.png',
                                        package: 'hb_solution',
                                        width: 16,
                                        height: 16,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 18),
                                child: Divider(
                                  height: 1,
                                  color: Color(0xFFF1F2F3),
                                ),
                              );
                            },
                            itemCount: 2),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                offset: Offset(-1, -1),
                                blurRadius: 4,
                                color: Colors.grey[200]),
                            BoxShadow(
                                offset: Offset(1, 1),
                                blurRadius: 4,
                                color: Colors.grey[200])
                          ]),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            '早餐$index',
                            style: TextStyle(
                                color: Color(0xFF374147),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                decoration: TextDecoration.none),
                          )),
                          GestureDetector(
                            onTapUp: (TapUpDetails details){
                              showDietAddDialog(context);
                            },
                            child: Icon(
                              Icons.add,
                              color: Color(0xFF1AD9CA),
                              size: 16,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      );
    }, childCount: 20));
  }

  showDietAddDialog(BuildContext context) async {
     showDialog(
        context: context, //BuildContext对象
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new DietAddDialog();
        });

  }
}
