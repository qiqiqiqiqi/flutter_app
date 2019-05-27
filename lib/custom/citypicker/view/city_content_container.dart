import 'package:flutter/material.dart';
import 'package:flutter_app/custom/citypicker/mode/province.dart';
import 'package:flutter_app/custom/citypicker/data/citydata.dart';
import 'package:flutter_app/custom/citypicker/data/areadata.dart';
import 'package:flutter_app/custom/citypicker/data/provincedata.dart';
import 'package:lpinyin/lpinyin.dart';

typedef OnSelectedData = void Function(
    ProvinceData provinceData, CityData cityData, AreaData areaData);

class CityContentContainer extends StatefulWidget {
  OnSelectedData onSelectedData;
  int selectedPosition;

  CityContentContainer({this.onSelectedData, this.selectedPosition});

  @override
  State<StatefulWidget> createState() {
    return CityContentState();
  }
}

class CityContentState extends State<CityContentContainer> {
  List<ProvinceData> provinces;
  List<CityData> hotCitys;
  ProvinceData selectedProvinceData;
  CityData selectedCityData;
  AreaData selectedAreaData;

//  List<String> hotCityIDs = [
//    "110000",
//    '310000',
//    "440100",
//    '440300',
//    "330100",
//    '320100',
//    "320500",
//    '120000',
//    "420100",
//    '430100',
//    "500000",
//    '510100',
//  ];
  List<String> hotCityIDs = [
    "北京",
    '上海',
    "广州",
    '深圳',
    "杭州",
    '南京',
    "苏州",
    '天津',
    "武汉",
    '长沙',
    "重庆",
    '成都',
  ];

  @override
  void initState() {
    super.initState();
    Map province = provincesData;
    provinces = List();
    province.forEach((key, value) {
      provinces.add(ProvinceData()
        ..provinceID = key
        ..provinceName = value);
    });

    Map city = citiesData;
    city.forEach((key, value) {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("CityContentState:didChangeDependencies()");
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              '热门城市',
              style: TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
            ),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 2.0),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
//                color: Colors.green,
                child: Text(
                  '${hotCityIDs[index]}',
                  style: TextStyle(color: Color(0xFF374147), fontSize: 14),
                ),
              );
            },
            childCount: hotCityIDs.length,
          ),
        ),
        SliverToBoxAdapter(
          child: Text(
            '省市地区',
            style: TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
          ),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return InkWell(
              onTap: () {
                selectedProvinceData = provinces[index];
                Map citysData = citiesData[selectedProvinceData.provinceID];

                setState(() {});
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${PinyinHelper.getFirstWordPinyin(provinces[index].provinceName).substring(0, 1)..substring(0, 1)}',
                        style:
                            TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          '${provinces[index].provinceName}',
                          style:
                              TextStyle(color: Color(0xFF374147), fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(
                          Icons.check,
                          color: Color(0xFF1AD9CA),
                          size: 12,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }, childCount: provinces.length),
        )
      ],
    );
  }
}
