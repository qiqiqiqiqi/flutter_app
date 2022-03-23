import 'package:flutter/material.dart';
import 'package:flutter_app/custom/citypicker/data/address.dart';
import 'package:flutter_app/custom/citypicker/observer/address_observer.dart';
import 'package:flutter_app/custom/citypicker/observer/tab_observer.dart';

typedef OnSelectedAddress = Function(Address address);

class AddressContainerInheritedWidget extends InheritedWidget {
  AddressObserver addressObserver;
  TabObserver tabObserver;
  OnSelectedAddress onSelectedAddress;
  final Map province;
  final Map city;

  static AddressContainerInheritedWidget of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AddressContainerInheritedWidget>();
    // return context.findAncestorWidgetOfExactType();
  }

  AddressContainerInheritedWidget(
      {Key key, Widget child, this.province, this.city, this.onSelectedAddress})
      : super(key: key, child: child) {
    addressObserver = AddressObserver();
    tabObserver = TabObserver();
  }

  @override
  bool updateShouldNotify(AddressContainerInheritedWidget oldWidget) {
    return addressObserver != oldWidget.addressObserver &&
        tabObserver != oldWidget.tabObserver;
  }
}
