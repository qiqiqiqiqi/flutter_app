//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'package:photo/photo.dart';
//import 'package:photo_manager/photo_manager.dart';
//
//class PhotoWidget extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return PhotoWidgetState();
//  }
//}
//
//class PhotoWidgetState extends State {
//  List<AssetEntity> images;
//
//  @override
//  void initState() {
//    super.initState();
//    setState(() {
//      pickAssets().then((value) => images = value);
//    });
//  }
//
//  Future<List<AssetEntity>> pickAssets() async {
//    return await PhotoPicker.pickAsset(context: context);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return GridView.builder(
//      scrollDirection: Axis.horizontal,
//      itemCount: images.length,
//      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
//          mainAxisSpacing: 2.0,
//          crossAxisCount: 2,
//          crossAxisSpacing: 2.0,
//          childAspectRatio: 0.7),
//      itemBuilder: (BuildContext context, int index) {
//        return  Image.network(
//          "${images[index]}",
//          fit: BoxFit.cover,
//        );
//      },
//    );
//  }
//}
