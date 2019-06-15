import 'package:flutter/material.dart';
import 'package:flutter_app/custom/citypicker/view/address_container_InheritedWidget.dart';
import 'package:flutter_app/custom/citypicker/data/address.dart';
import 'package:lpinyin/lpinyin.dart';

class AddressProvinceList extends StatefulWidget {
  final Address selectedAddress;

  AddressProvinceList({@required this.selectedAddress});

  @override
  State<StatefulWidget> createState() {
    return AddressProvinceListState();
  }
}

class AddressProvinceListState extends State<AddressProvinceList> {
  ScrollController scrollController;
  List<ProvinceData> provinces;
  GlobalKey provinceGlobalKey;
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
    provinces = List();
    provinceGlobalKey = GlobalKey();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provinces?.clear();
    AddressContainerInheritedWidget.of(context).province.forEach((key, value) {
      provinces.add(ProvinceData()
        ..provinceID = key
        ..provinceName = value);
    });
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      controller: scrollController,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
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
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
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
          key: provinceGlobalKey,
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return InkWell(
              onTap: () {
                onItemSelected(index);
              },
              child: buildListItem(index, widget.selectedAddress),
            );
          }, childCount: provinces.length),
        )
      ],
    );
  }

  Container buildListItem(int index, Address address) {
    String name = provinces[index].provinceName;
    bool selected =
        address.provinceData?.provinceID == provinces[index].provinceID;

    return Container(
      height: 44.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
    if (widget.selectedAddress.provinceData?.provinceID !=
        provinces[index].provinceID) {
      widget.selectedAddress.provinceData = provinces[index];
      widget.selectedAddress.cityData = null;
      widget.selectedAddress.areaData = null;
    }
    AddressContainerInheritedWidget.of(context)
        .addressObserver
        .notifyStateChange(widget.selectedAddress);
  }
}
