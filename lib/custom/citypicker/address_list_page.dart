import 'package:flutter/material.dart';

class AddressListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddressListPageState();
  }
}

class AddressListPageState extends State<AddressListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemCount: 7, itemBuilder: (context, index) {

      }),
    );
  }
}
