import 'package:flutter/material.dart';

import 'package:flutter_app/custom/citypicker/data/address.dart';
import 'package:lpinyin/lpinyin.dart';
import 'single_tap_selector_container.dart';
import 'package:flutter_app/custom/citypicker/address_container_InheritedWidget.dart';

class AddressAreaList extends StatefulWidget {
  final Address selectedAddress;

  AddressAreaList({@required this.selectedAddress});

  @override
  State<StatefulWidget> createState() {
    return AddressAreaListState();
  }
}

class AddressAreaListState extends State<AddressAreaList> {
  List<AreaData> areas;
  ScrollController scrollController;
  AddressTab currentTab = AddressTab.TAB_PROVINCE;
  GlobalKey provinceGlobalKey;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    areas = List();
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
    areas?.clear();
    AddressContainerInheritedWidget.of(context)
        .city[widget.selectedAddress.cityData.cityID]
        .forEach((key, value) {
      areas.add(AreaData()
        ..areaID = key
        ..areaName = value['name']);
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
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return InkWell(
            onTap: () {
              onItemSelected(index);
            },
            child: buildListItem(currentTab, index, widget.selectedAddress),
          );
        }, childCount: areas.length),
      )
    ];
  }

  Container buildListItem(AddressTab addressTab, int index, Address address) {
    String name = areas[index].areaName;
    bool selected = address.areaData?.areaID == areas[index].areaID;
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
    print('onItemSelected():currentTab=$currentTab');
    widget.selectedAddress.areaData = areas[index];
    scrollController.jumpTo(0.0);
    AddressContainerInheritedWidget.of(context)
        .addressObserver
        .notifyStateChange(widget.selectedAddress);
  }
}
