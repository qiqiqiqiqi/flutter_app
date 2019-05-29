import 'package:flutter/material.dart';
import 'package:flutter_app/custom/citypicker/view/single_tap_selector_container.dart';
import 'package:flutter_app/custom/citypicker/view/city_content_container.dart';
import 'package:flutter_app/custom/citypicker/data/address.dart';
import 'address_container.dart';
import 'package:flutter_app/custom/citypicker/mode/province.dart';

main() {
  runApp(MaterialApp(title: "citypicker demo", home: CityPickerDemo()));
}

class CityPickerDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CityPickerState();
  }
}

class CityPickerState extends State<CityPickerDemo> {
  AddressTab selectedAddressTab = AddressTab.TAB_PROVINCE;
  Address selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("citypicker demo"),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.only(left: 0, right: 0, top: 30),
            child: AddressContainerInheritedWidget(
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
                            onPressed: () {},
                            iconSize: 18,
                            padding: EdgeInsets.all(0),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SingleSelectorContainer()),
                    Expanded(child: CityContentContainer())
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
