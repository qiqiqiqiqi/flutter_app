import 'dart:convert' as JSON;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:isolate';

///https://juejin.im/post/5a9a21f8518825558b3d5d35
void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
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

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }

    return false;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Sample App"),
        ),
        body: getBody());
  }

  ListView getListView() => new ListView.builder(
      itemCount: widgets.length * 2,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  Widget getRow(int i) {
    if (i.isOdd) {
      return new Divider();
    }
    return new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text("Row ${widgets[i ~/ 2]["title"]}"));
  }

  loadData() async {
    ReceivePort receivePort =
        new ReceivePort(); //main isolate中的ReceivePort用于接收child isolate中发送过来的消息
    Isolate.spawn(dataLoader, receivePort.sendPort); //
    // The 'echo' isolate sends it's SendPort as the first message
    SendPort sendPort = await receivePort
        .first; //1挂起等待receivePort接收消息//接收从child isolate中发送过来的消息，这里是接收从child isolate中发送过来的SendPort用于main isolate向child isolate中发送消息
    List msg = await sendReceive(
        sendPort, "https://jsonplaceholder.typicode.com/posts"); //3
    //List msg = await sendReceive2(receivePort,sendPort, "https://jsonplaceholder.typicode.com/posts");//3
    setState(() {
      widgets = msg;
    });
  }

// the entry point for the isolate
  //该方法必须设置为static？
  static dataLoader(SendPort sendPort) async {
    // Open the ReceivePort for incoming messages.
    ReceivePort receivePort =
        new ReceivePort(); //child isolate中的ReceivePort用于接收main isolate中发送过来的消息
    // Notify any other isolates what port this isolate listens to.
    sendPort.send(receivePort.sendPort); //2
    await for (var msg in receivePort) {
      //4//挂起等待receivePort接收消息
      String data = msg[0];
      SendPort replyTo = msg[1];
      String dataURL = data;
      http.Response response = await http.get(dataURL);
      // Lots of JSON to parse
      replyTo.send(JSON.jsonDecode(response.body));
    }
  }

  Future sendReceive(SendPort port, msg) {
    //ReceivePort为什么不能使用同一个
    ReceivePort response = new ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }

  Future sendReceive2(ReceivePort response, SendPort port, msg) {
    port.send([msg, response.sendPort]);
    return response.last;
  }
}
