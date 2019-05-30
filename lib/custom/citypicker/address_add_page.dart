import 'package:flutter/material.dart';
import 'package:flutter_app/custom/citypicker/view/round_button.dart';

class AddresAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddressAddPageState();
  }
}

class AddressAddPageState extends State<AddresAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF1F1A20),
              ),
              onPressed: null),
          centerTitle: true,
          title: Text(
            '新增收货地址',
            style: TextStyle(fontSize: 18, color: Color(0xFF1F1A20)),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20, right: 20),
                        width: 56,
                        child: Text(
                          '收货人',
                          style:
                              TextStyle(color: Color(0xFF808184), fontSize: 14),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                        style:
                            TextStyle(color: Color(0xFF374147), fontSize: 14),
                        maxLines: 1,
                        decoration: new InputDecoration(
                            hintStyle: TextStyle(
                                color: Color(0xFFAAB2B7), fontSize: 14),
                            hintText: "请填写收货人姓名",
                            border: InputBorder.none),
                      ))
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: Color(0xFFF2F4F5),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20, right: 20),
                        width: 56,
                        child: Text(
                          '手机号码',
                          style:
                              TextStyle(color: Color(0xFF808184), fontSize: 14),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                        keyboardType: TextInputType.number,
                        style:
                            TextStyle(color: Color(0xFF374147), fontSize: 14),
                        maxLines: 1,
                        decoration: new InputDecoration(
                            hintStyle: TextStyle(
                                color: Color(0xFFAAB2B7), fontSize: 14),
                            hintText: "请填写收货人手机号",
                            border: InputBorder.none),
                      ))
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: Color(0xFFF2F4F5),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20, right: 20),
                        width: 56,
                        child: Text(
                          '收货地址',
                          style:
                              TextStyle(color: Color(0xFF808184), fontSize: 14),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                        style:
                            TextStyle(color: Color(0xFF374147), fontSize: 14),
                        controller: TextEditingController.fromValue(
                            TextEditingValue(
                                // 设置内容
                                text: '广东省深圳市',
                                // 保持光标在最后
                                selection: TextSelection.fromPosition(
                                    TextPosition(
                                        affinity: TextAffinity.downstream,
                                        offset: '广东省深圳市'.length)))),
                        maxLines: 1,
                        decoration: new InputDecoration(
                            hintStyle: TextStyle(
                                color: Color(0xFFAAB2B7), fontSize: 14),
                            hintText: "请选择省/市/县区",
                            border: InputBorder.none),
                      ))
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: Color(0xFFF2F4F5),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                      ),
                      child: TextField(
                          style:
                              TextStyle(color: Color(0xFF374147), fontSize: 14),
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: '请输入详细的地址信息(街道、楼牌号等)',
                            hintStyle: TextStyle(
                                color: Color(0xFFAAB2B7), fontSize: 14),
                          )),
                    ),
                  )
                ],
              ),
            )),
            StatefulRoundButton(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 40),
              pressBackgroundColor: Color(0xbf1AD9CA),
              normalBackgroundColor: Color(0xff1AD9CA),
              height: 48,
              raduis: 4,
              child: Text(
                '完成',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ));
  }
}
