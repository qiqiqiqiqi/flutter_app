import 'dart:convert' as JSON;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

///https://juejin.im/post/5a9a21f8518825558b3d5d35
///
/// 在Dart中我们可以通过async关键字来声明一个异步方法，异步方法会在调用后立即返回给调用者一个Future对象
///（但这个逻辑存在一些漏洞，在Dart2中有一些改变，详见synchronous async start discussion），
/// 而异步方法的方法体将会在后续被执行（应该也是通过协程的方式实现）。在异步方法中可以使用
/// await表达式挂起该异步方法中的某些步骤从而实现等待某步骤完成的目的，await表达式的表达式部分
/// 通常是一个Future类型，即在await处挂起后交出代码的执行权限直到该Future完成。在Future
/// 完成后将包含在Future内部的数据类型作为整个await表达式的返回值，接着异步方法继续从await表达式挂起点后继续执行

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'async&await demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];
  var ld, ld2;

  @override
  void initState() {
    super.initState();
    ld = loadData();
    print("initState():ld=${ld},ld2=${ld2},ld==ld2 is ${ld == ld2}");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("async&await demo"),
        ),
        body: new ListView.builder(
            itemCount: widgets.length * 2,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            }));
  }

  Widget getRow(int i) {
    if (i.isOdd) {
      return new Divider();
    }
    return new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text("Row ${widgets[i ~/ 2]["title"]}"));
  }

  /// async修饰的异步方法需要声明返回一个Future类型，如果方法体内没有主动的返回一个Future类型，系统会将返回值包含到一个Future中返回。
  /// await表达式的表达式部分需要返回一个Future对象。
  /// await表达式需要在一个async修饰的方法中使用才会生效。

  /// Dart中我们可以通过async关键字来声明一个异步方法，异步方法会在调用后立即返回给调用者一个Future对象.
  loadData() async {
    print("loadData() await beforce:");
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await request(
        dataURL); //等一等，等数据返回，await表达式的表达式部分通常是一个Future类型，即在await处挂起后交出代码的执行权限直到该Future完成再继续向下执行
    print("loadData() await after:");
    setState(() {
      widgets = JSON.jsonDecode(response.body);
      print("widgets[0]=${widgets[0]}");
    });
  }

  Future<http.Response> request(String dataURL) {
    ld2 = http.get(dataURL);
    return ld2;
  }
}
