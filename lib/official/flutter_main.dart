import 'package:flutter/material.dart';

main() {
  runApp(new FlutterApp());
}

class FlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "flutter app",
        theme: new ThemeData(
            primaryColor: Colors.brown,
            backgroundColor: Colors.orange,
            accentColor: Colors.amber[400],
            textTheme: new TextTheme(
                body1: new TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
            iconTheme:
                new IconThemeData(color: Colors.deepPurpleAccent, size: 40.0)),
        home: new Text("empty"));
  }
}

class FlutterHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FlutterHomePageState();
  }
}

class FlutterHomePageState extends State<FlutterHomePage>  with SingleTickerProviderStateMixin{
  @override
  void initState() {
    super.initState();
    TabController tabController = buildTabController();
    //tabController.addListener(new V)
  }

  TabController buildTabController() => new TabController(length: 4,initialIndex: 0,vsync: this);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: Text("flutter app")),
      body: new TabBarView(children: <Widget>[
        new Text("main0"),
        new Text("main1"),
        new Text("main2"),
        new Text("main3")
      ], controller: buildTabController()),
      bottomNavigationBar: new TabBar(tabs: <Tab>[
        new Tab(text: "main0"),
        new Tab(text: "main1"),
        new Tab(text: "main2"),
        new Tab(text: "main3")
      ]),
    );
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }
}
