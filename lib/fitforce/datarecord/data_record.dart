//import 'package:flutter/material.dart';
//import 'package:hb_solution/core/root.dart';
//import 'package:hb_solution/widget/header/common_header.dart';
//import 'sleep/sleep_record.dart';
//import 'diet/diet_record.dart';
//import 'sport/sport_record.dart';
//
//class DataRecordPage extends SolutionPage {
//  @override
//  void onInitState(_solutionWidgetState) {
//    super.onInitState(_solutionWidgetState);
//    showContent();
//  }
//
//  @override
//  Widget withHeaderCreator(BuildContext context, SolutionArgs initArgs) {
//    return CommonHeader(
//      centerWiget: Container(
//        child: Row(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            InkWell(
//              splashColor: Colors.transparent,
//              child: Padding(
//                padding: EdgeInsets.only(right: 12.5),
//                child: Image.asset(
//                  'images/datarecord/ic_bate_date_zuo_selected.png',
//                  package: 'hb_solution',
//                  width: 15,
//                  height: 21,
//                ),
//              ),
//            ),
//            Text(
//              '06.11',
//              style: TextStyle(
//                  color: Color(0xFF374147),
//                  fontSize: 18,
//                  fontWeight: FontWeight.bold),
//            ),
//            InkWell(
//              splashColor: Colors.transparent,
//              child: Padding(
//                padding: EdgeInsets.only(left: 12.5),
//                child: Image.asset(
//                  'images/datarecord/ic_bate_date_you_selected.png',
//                  package: 'hb_solution',
//                  width: 15,
//                  height: 21,
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//      headerEntity: HeaderEntity(onLeftTab: () {}),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SleepRecordPage();
//    return SportRecordPage();
//    return DietRecordPage();
//
//  }
//}
