import 'package:flutter/material.dart';
import 'package:flutter_app/custom/citypicker/view/single_tap_selector_container.dart';
import 'package:flutter_app/custom/citypicker/view/address_content_container.dart';
import 'package:flutter_app/custom/citypicker/data/address.dart';
import 'package:flutter_app/custom/citypicker/view/address_container_InheritedWidget.dart';
import 'package:flutter_app/custom/citypicker/mode/province.dart';

class AddressSelectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddressSelectPageState();
  }
}

class AddressSelectPageState extends State<AddressSelectPage> {
  AddressTab selectedAddressTab = AddressTab.TAB_PROVINCE;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 30),
        child: AddressContainerInheritedWidget(
          onSelectedAddress: (Address address) {
            print('AddressSelectPageState--build():address=$address');
            Navigator.of(context).pop(address);
          },
          province: provincesData,
          city: citiesData,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "请选择",
                          style: TextStyle(
                            color: Color(0xFF374147),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                        iconSize: 18,
                        padding: EdgeInsets.all(0),
                      )
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleSelectorContainer()),
                Expanded(child: CityContentContainer()),
              ],
            ),
          ),
        ),
      );
    }));
  }
}
