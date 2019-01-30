import 'package:flutter/material.dart';

main() {
  runApp(new FlutterApp());
}

class FlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
            primaryColor: Colors.brown,
            backgroundColor: Colors.orange,
            accentColor: Colors.amber[400],
            textTheme: new TextTheme(
                body1: new TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
            iconTheme:
                new IconThemeData(color: Colors.deepPurpleAccent, size: 40.0)),
        home: new FlutterHomePage());
  }
}

class FlutterHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FlutterHomePageState();
  }
}

class FlutterHomePageState extends State<FlutterHomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = buildTabController();
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        print("tabchange:index=${tabController.index}");
      }
    });
  }

  TabController buildTabController() =>
      new TabController(length: 4, initialIndex: 0, vsync: this);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: Text("flutter app")),
      body: new TabBarView(children: <Widget>[
        ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: new Text("title${index}"),
                onTap: () {
                  print("onTap():item=$index");
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 1,
                  color: Colors.blue,
                ),
            itemCount: 10),
        new Text("main1"),
        new Text("main2"),
        new Text("main3")
      ], controller: tabController),
      bottomNavigationBar: Container(
        color: Colors.blueGrey,
        child: new TabBar(
          indicatorColor: Colors.red,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black,
          tabs: <Tab>[
            new Tab(text: "组件"),
            new Tab(text: "main1"),
            new Tab(text: "main2"),
            new Tab(text: "main3")
          ],
          controller: tabController,
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }
}
