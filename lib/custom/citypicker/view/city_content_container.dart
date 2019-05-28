import 'package:flutter/material.dart';
import 'package:flutter_app/custom/citypicker/mode/province.dart';
import 'package:flutter_app/custom/citypicker/data/address.dart';

import 'package:lpinyin/lpinyin.dart';
import 'single_tap_selector_container.dart';

typedef OnAddressSelected = void Function(
    Address address, AddressTab addressTab);

class CityContentContainer extends StatefulWidget {
  OnAddressSelected onAddressSelected;
  AddressTab selectedAddressTab;

  CityContentContainer({this.onAddressSelected, this.selectedAddressTab});

  @override
  State<StatefulWidget> createState() {
    return CityContentState();
  }
}

class CityContentState extends State<CityContentContainer> {
  List<ProvinceData> provinces;
  List<CityData> citys;
  List<AreaData> areas;
  Address selectedAddress = Address();
  ScrollController scrollController;
  AddressTab currentTab = AddressTab.TAB_PROVINCE;

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
    scrollController = ScrollController();
    Map province = provincesData;
    provinces = List();
    citys = List();
    areas = List();
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
  void didUpdateWidget(CityContentContainer oldWidget) {
    print(
        "CityContentState:didUpdateWidget():${widget.selectedAddressTab},currentTab=$currentTab");
    currentTab = widget.selectedAddressTab;
  }

  @override
  Widget build(BuildContext context) {
    return buildView();
  }

  Widget buildView() {
    return CustomScrollView(
      controller: scrollController,
      slivers: buildViewByTab(),
    );
  }

  List<Widget> buildViewByTab() {
    print("CityContentState:buildViewByTab():currentTab=$currentTab");
    if (currentTab == AddressTab.TAB_PROVINCE) {
      return <Widget>[
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
                onItemSelected(index);
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
      ];
    } else if (currentTab == AddressTab.TAB_CITY) {
      return <Widget>[
        SliverToBoxAdapter(
          child: Text(
            '城市',
            style: TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
          ),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return InkWell(
              onTap: () {
                onItemSelected(index);
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${PinyinHelper.getFirstWordPinyin(citys[index].cityName).substring(0, 1)..substring(0, 1)}',
                        style:
                            TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          '${citys[index].cityName}',
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
          }, childCount: citys.length),
        )
      ];
    } else if (currentTab == AddressTab.TAB_AREA) {
      return <Widget>[
        SliverToBoxAdapter(
          child: Text(
            '区县',
            style: TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
          ),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return InkWell(
              onTap: () {
                onItemSelected(index);
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${PinyinHelper.getFirstWordPinyin(areas[index].areaName).substring(0, 1)..substring(0, 1)}',
                        style:
                            TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          '${areas[index].areaName}',
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
          }, childCount: areas.length),
        )
      ];
    } else if (currentTab == 3) {}
  }

  void onItemSelected(int index) {
    print(
        'onItemSelected():widget.selectedPosition=${widget.selectedAddressTab}');
    switch (currentTab) {
      case AddressTab.TAB_PROVINCE:
        citys.clear();
        if (selectedAddress.provinceData?.provinceID !=
            provinces[index].provinceID) {
          selectedAddress.provinceData = provinces[index];
          selectedAddress.cityData = null;
          selectedAddress.areaData = null;

          citiesData[selectedAddress.provinceData.provinceID]
              .forEach((key, value) {
            citys.add(CityData()
              ..cityID = key
              ..cityName = value['name']);
          });
          print('onItemSelected():citys=$citys');

          if (citys.isNotEmpty) {
            currentTab = AddressTab.TAB_CITY;
          }
          widget.onAddressSelected?.call(selectedAddress, currentTab);
        }
        break;
      case AddressTab.TAB_CITY:
        areas.clear();

        if (selectedAddress.cityData?.cityID != citys[index].cityID) {
          selectedAddress.cityData = citys[index];
          selectedAddress.areaData = null;

          citiesData[selectedAddress.cityData.cityID].forEach((key, value) {
            areas.add(AreaData()
              ..areaID = key
              ..areaName = value['name']);
          });

          if (areas.isNotEmpty) {
            currentTab = AddressTab.TAB_AREA;
          }
          widget.onAddressSelected?.call(selectedAddress, currentTab);
        }
        break;
      case AddressTab.TAB_AREA:
        selectedAddress.areaData = areas[index];
        widget.onAddressSelected?.call(selectedAddress, AddressTab.TAB_AREA);
        break;
      case AddressTab.TAB_UNSELECT:
        break;
    }
    scrollController.jumpTo(0.0);
  }
}
