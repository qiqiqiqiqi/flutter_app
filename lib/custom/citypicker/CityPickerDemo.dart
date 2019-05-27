import 'package:flutter/material.dart';
import 'package:flutter_app/custom/citypicker/view/single_tap_selector_container.dart';
import 'package:flutter_app/custom/citypicker/view/city_content_container.dart';
import 'package:flutter_app/custom/citypicker/data/citydata.dart';
import 'package:flutter_app/custom/citypicker/data/areadata.dart';
import 'package:flutter_app/custom/citypicker/data/provincedata.dart';

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
  int selectedPosition = 0;

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
                  SingleSelectorContainer(onTypeSelected: (int position) {
                    setState(() {
                      selectedPosition = position;
                    });
                  }),
                  Expanded(
                      child: CityContentContainer(
                          selectedPosition: selectedPosition,
                          onSelectedData: (ProvinceData provinceData,
                              CityData cityData, AreaData areaData) {}))
                ],
              ),
            ),
          );
        }));
  }
}
