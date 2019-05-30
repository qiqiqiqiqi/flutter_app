import 'package:flutter/material.dart';

import 'package:flutter_app/custom/citypicker/data/address.dart';
import 'single_tap_selector_container.dart';
import 'package:flutter_app/custom/citypicker/view/address_container_InheritedWidget.dart';
import 'package:flutter_app/custom/citypicker/observer/tab_observer.dart';
import 'package:flutter_app/custom/citypicker/view/address_province_list.dart';
import 'package:flutter_app/custom/citypicker/view/address_city_list.dart';
import 'package:flutter_app/custom/citypicker/view/address_area_List.dart';

class CityContentContainer extends StatefulWidget {
  CityContentContainer();

  @override
  State<StatefulWidget> createState() {
    return CityContentState();
  }
}

class CityContentState extends State<CityContentContainer> with TabObserve {
  Address selectedAddress;
  AddressTab currentTab = AddressTab.TAB_PROVINCE;

  @override
  void initState() {
    super.initState();
    selectedAddress = Address();
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
    if (currentTab == AddressTab.TAB_PROVINCE) {
      return AddressProvinceList(
        selectedAddress: selectedAddress,
      );
    } else if (currentTab == AddressTab.TAB_CITY) {
      return AddressCityList(
        selectedAddress: selectedAddress,
      );
    } else if (currentTab == AddressTab.TAB_AREA) {
      return AddressAreaList(
        selectedAddress: selectedAddress,
      );
    }
  }

  @override
  void onTabChange(AddressTab addressTab) {
    print('CityContentState--onTabChange():addressTab=$addressTab');
    setState(() {
      currentTab = addressTab;
    });
  }
}
