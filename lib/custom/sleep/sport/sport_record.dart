import 'package:flutter/material.dart';
import 'sport_record_decoration.dart';

class SportRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SportRecordPageState();
  }
}

class SportRecordPageState extends State<SportRecordPage> {
  Map<int,GlobalKey> globalKeys;
  Offset popuOffset;
  Size popuSize;

  @override
  void initState() {
    super.initState();
    globalKeys = Map();
    popuOffset ;
    popuSize;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                child: NotificationListener(
                    onNotification: (ScrollNotification scrollNotification) {
                      print('scrollNotification');
                      if (popuOffset != null && popuSize != null) {
                        setState(() {
                          popuOffset = null;
                          popuSize = null;
                        });
                      }
                    },
                    child: CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      slivers: <Widget>[
                        buildKalContainer(constraints),
                        buildSliverList()
                      ],
                    )),
              )),
          popuOffset != null
              ? Positioned(
                  top: popuOffset.dy.abs(),
                  left: popuOffset.dx.abs(),
                  width: popuSize.width,
                  child: Container(
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
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(16),
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 42,
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'images/datarecord/ic_bate_paobu.png',
                                  package: 'hb_solution',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      '跑步',
                                      style: TextStyle(
                                          color: Color(0xFF374147),
                                          fontSize: 14,
                                          decoration: TextDecoration.none),
                                    ))
                              ],
                            ),
                          );
                        }),
                  ))
              : Container()
        ],
      );
    });
  }

  SliverPadding buildSliverList() {
    globalKeys.clear();
    int itemCount = 200;
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 44),
      sliver: SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
                print("SliverChildBuilderDelegate():$index");
       if(globalKeys[index]!=null){
         globalKeys[index]=GlobalKey();
       }
        return Container(
          decoration: SportRecordDecoration(
              position: index,
              itemCount: itemCount,
              offsetLeft: 63,
              offsetBottom: 20,
              offsetTop: 20),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: buildTimeWigets(index, itemCount),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: buildTimeIconWigets(index, itemCount),
                ),
              ),
              Expanded(
                key: globalKeys[index],
                  child: GestureDetector(
                onTap: () {
                  if (index == itemCount - 1) {
                    showPopu(index);
                  }
                },
                child: Container(
                    alignment: Alignment.centerLeft,
                    height: 52,
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
                    child: buildItemContentWiget(index, itemCount)),
              ))
            ],
          ),
        );
      }, childCount: itemCount)),
    );
  }

  void showPopu(int index) {
    print('index=$index');
    setState(() {
      RenderBox itemContentRenderBox =
          globalKeys[index].currentContext.findRenderObject();
      popuSize = itemContentRenderBox.size;
      popuOffset = itemContentRenderBox.globalToLocal(Offset.zero);
      print('popuOffset=$popuOffset,popuSize=$popuSize');
    });
  }

  List<Widget> buildTimeWigets(int index, int itemCount) {
    if (index != itemCount - 1) {
      return <Widget>[
        Text(
          '07:30',
          style: TextStyle(
              color: Color(0xFFBFC5C9),
              fontSize: 12,
              decoration: TextDecoration.none),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            '08:30',
            style: TextStyle(
                color: Color(0xFFBFC5C9),
                fontSize: 12,
                decoration: TextDecoration.none),
          ),
        )
      ];
    } else {
      return [];
    }
  }

  List<Widget> buildTimeIconWigets(int index, int itemCount) {
    if (index != itemCount - 1) {
      return <Widget>[
        Image.asset(
          'images/datarecord/ic_bate_motion_jieshu.png',
          package: 'hb_solution',
          width: 16,
          height: 16,
          fit: BoxFit.cover,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 6.4),
          color: Color(0xFF979797),
          width: 2,
          height: 5,
        ),
        Image.asset(
          'images/datarecord/ic_bate_motion_kaishi.png',
          package: 'hb_solution',
          width: 16,
          height: 16,
          fit: BoxFit.cover,
        )
      ];
    } else {
      return <Widget>[
        Image.asset(
          'images/datarecord/ic_bate_motion_tianjia.png',
          package: 'hb_solution',
          width: 16,
          height: 16,
          fit: BoxFit.cover,
        )
      ];
    }
  }

  Widget buildItemContentWiget(int index, int itemCount) {
    if (index != itemCount - 1) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10, right: 4),
                child: Image.asset(
                  'images/datarecord/ic_bate_paobu.png',
                  package: 'hb_solution',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                )),
            Text(
              '跑步',
              style: TextStyle(
                  color: Color(0xFF374147),
                  fontSize: 14,
                  decoration: TextDecoration.none),
            ),
            Expanded(
              child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                    text: '90',
                    style: TextStyle(
                        color: Color(0xFF374147),
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                          text: '分钟',
                          style: TextStyle(
                              color: Color(0xFFBFC5C9),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none))
                    ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16, left: 14),
              child: Image.asset(
                'images/datarecord/ic_date_delete.png',
                package: 'hb_solution',
                width: 16,
                height: 16,
                fit: BoxFit.contain,
              ),
            )
          ]);
    } else {
      return Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            '你做了什么运动',
            style: TextStyle(
                color: Color(0xFFD1D5D8),
                fontSize: 14,
                decoration: TextDecoration.none),
          ));
    }
  }

  SliverToBoxAdapter buildKalContainer(BoxConstraints constraints) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: constraints.maxWidth - 40,
        child: AspectRatio(
          aspectRatio: 355 / 148,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.centerLeft,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 45),
                          child: Text(
                            '今日消耗卡路里',
                            style: TextStyle(
                                color: Color(0xFFBFC5C9),
                                fontSize: 12,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(left: 32, top: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'images/datarecord/ic_bate_motion_ranzhi.png',
                                package: 'hb_solution',
                                width: 21,
                                height: 32,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text.rich(TextSpan(
                                    text: '68',
                                    style: TextStyle(
                                      color: Color(0xFF374147),
                                      fontSize: 45,
                                      decoration: TextDecoration.none,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' 千卡',
                                          style: TextStyle(
                                            color: Color(0xFFBFC5C9),
                                            fontSize: 14,
                                            decoration: TextDecoration.none,
                                          ))
                                    ])),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              Positioned(
                  right: 0,
                  top: 0,
                  height: 113,
                  width: 142,
                  child: Image.asset(
                    'images/datarecord/bg_bate_motion.png',
                    package: 'hb_solution',
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
