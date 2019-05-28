import 'package:flutter/material.dart';
import 'package:flutter_app/custom/citypicker/view/single_tap_selector_container.dart';
import 'package:flutter_app/custom/citypicker/view/city_content_container.dart';
import 'package:flutter_app/custom/citypicker/data/address.dart';

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
            padding: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
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
                  SingleSelectorContainer(
                      address: selectedAddress,
                      onTabSelected: (AddressTab position) {
                        setState(() {
                          selectedAddressTab = position;
                        });
                      }),
                  Expanded(
                      child: CityContentContainer(
                          selectedAddressTab: selectedAddressTab,
                          onAddressSelected: (Address address,AddressTab addressTab) {
                            setState(() {
                              selectedAddress = address;
                              selectedAddressTab=addressTab;
                            });
                          }))
                ],
              ),
            ),
          );
        }));
  }
}
