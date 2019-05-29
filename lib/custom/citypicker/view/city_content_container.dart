import 'package:flutter/material.dart';

import 'package:flutter_app/custom/citypicker/data/address.dart';
import 'package:lpinyin/lpinyin.dart';
import 'single_tap_selector_container.dart';
import 'package:flutter_app/custom/citypicker/address_container.dart';
import 'package:flutter_app/custom/citypicker/observer/tab_observer.dart';

class CityContentContainer extends StatefulWidget {
  CityContentContainer();

  @override
  State<StatefulWidget> createState() {
    return CityContentState();
  }
}

class CityContentState extends State<CityContentContainer> with TabObserve {
  List<ProvinceData> provinces;
  List<CityData> citys;
  List<AreaData> areas;
  Address selectedAddress;

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
    selectedAddress = Address();
    scrollController = ScrollController();
    provinces = List();
    citys = List();
    areas = List();
  }

  @override
  void didChangeDependencies() {
    AddressContainerInheritedWidget headContainerInheritedWidget =
        AddressContainerInheritedWidget.of(context);
    if (headContainerInheritedWidget != null &&
        headContainerInheritedWidget.tabObserver != null) {
      headContainerInheritedWidget.tabObserver.subscribe(this);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    AddressContainerInheritedWidget headContainerInheritedWidget =
        AddressContainerInheritedWidget.of(context);
    if (headContainerInheritedWidget != null &&
        headContainerInheritedWidget.tabObserver != null) {
      headContainerInheritedWidget.tabObserver.unsubscribe(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    provinces?.clear();
    AddressContainerInheritedWidget.of(context).province.forEach((key, value) {
      provinces.add(ProvinceData()
        ..provinceID = key
        ..provinceName = value);
    });
    return buildView();
  }

  Widget buildView() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
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
            padding: EdgeInsets.only(top: 22, left: 20),
            child: Text(
              '热门城市',
              style: TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
          sliver: SliverGrid(
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
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              '省市地区',
              style: TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
            ),
          ),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return InkWell(
              onTap: () {
                onItemSelected(index);
              },
              child: buildListItem(currentTab, index, selectedAddress),
            );
          }, childCount: provinces.length),
        )
      ];
    } else if (currentTab == AddressTab.TAB_CITY) {
      return <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 22, left: 20),
            child: Text(
              '城市',
              style: TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
            ),
          ),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return InkWell(
              onTap: () {
                onItemSelected(index);
              },
              child: buildListItem(currentTab, index, selectedAddress),
            );
          }, childCount: citys.length),
        )
      ];
    } else if (currentTab == AddressTab.TAB_AREA) {
      return <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 22, left: 20),
            child: Text(
              '区县',
              style: TextStyle(color: Color(0xFFAAB2B7), fontSize: 12),
            ),
          ),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return InkWell(
              onTap: () {
                onItemSelected(index);
              },
              child: buildListItem(currentTab, index, selectedAddress),
            );
          }, childCount: areas.length),
        )
      ];
    }
  }

  Container buildListItem(AddressTab addressTab, int index, Address address) {
    String name;
    bool selected = false;
    if (addressTab == AddressTab.TAB_PROVINCE) {
      name = provinces[index].provinceName;
      selected =
          address.provinceData?.provinceID == provinces[index].provinceID;
    } else if (addressTab == AddressTab.TAB_CITY) {
      name = citys[index].cityName;
      selected = address.cityData?.cityID == citys[index].cityID;
    } else if (addressTab == AddressTab.TAB_AREA) {
      name = areas[index].areaName;
      selected = address.areaData?.areaID == areas[index].areaID;
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: <Widget>[
            Container(
              width: 20,
              alignment: Alignment.centerLeft,
              child: Text(
                '${PinyinHelper.getFirstWordPinyin(name).substring(0, 1)..substring(0, 1)}',
                style: TextStyle(
                    color: selected ? Color(0xFF1AD9CA) : Color(0xFFAAB2B7),
                    fontSize: 12),
              ),
            ),
            Text(
              '$name',
              style: TextStyle(
                  color: selected ? Color(0xFF1AD9CA) : Color(0xFF374147),
                  fontSize: 14),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.check,
                color: selected ? Color(0xFF1AD9CA) : Color(0xFFAAB2B7),
                size: selected ? 12 : 0,
              ),
            )
          ],
        ),
      ),
    );
  }

  void onItemSelected(int index) {
    print('onItemSelected():currentTab=$currentTab');
    switch (currentTab) {
      case AddressTab.TAB_PROVINCE:
        if (selectedAddress.provinceData?.provinceID !=
            provinces[index].provinceID) {
          citys.clear();
          selectedAddress.provinceData = provinces[index];
          selectedAddress.cityData = null;
          selectedAddress.areaData = null;

          AddressContainerInheritedWidget.of(context)
              .city[selectedAddress.provinceData.provinceID]
              .forEach((key, value) {
            citys.add(CityData()
              ..cityID = key
              ..cityName = value['name']);
          });
          print('onItemSelected():citys=$citys');
        }

        if (citys.isNotEmpty) {
          currentTab = AddressTab.TAB_CITY;
        }

        break;
      case AddressTab.TAB_CITY:
        if (selectedAddress.cityData?.cityID != citys[index].cityID) {
          areas.clear();
          selectedAddress.cityData = citys[index];
          selectedAddress.areaData = null;

          AddressContainerInheritedWidget.of(context)
              .city[selectedAddress.cityData.cityID]
              .forEach((key, value) {
            areas.add(AreaData()
              ..areaID = key
              ..areaName = value['name']);
          });
        }
        if (areas.isNotEmpty) {
          currentTab = AddressTab.TAB_AREA;
        }
        break;
      case AddressTab.TAB_AREA:
        selectedAddress.areaData = areas[index];
        break;
      case AddressTab.TAB_UNSELECT:
        break;
    }
    scrollController.jumpTo(0.0);

    AddressContainerInheritedWidget.of(context)
        .addressObserver
        .notifyStateChange(selectedAddress);
  }

  @override
  void onTabChange(AddressTab addressTab) {
    print('CityContentState--onTabChange():addressTab=$addressTab');
    setState(() {
      currentTab = addressTab;
    });
  }
}
