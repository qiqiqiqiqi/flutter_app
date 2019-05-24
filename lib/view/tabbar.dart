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
        new PageBody("组件"),
        new PageBody("main1"),
        new PageBody("main2"),
        new PageBody("main3"),
      ], physics: NeverScrollableScrollPhysics(), controller: tabController),
      bottomNavigationBar: Container(
        color: Colors.blueGrey,
        child: new TabBar(
          indicatorColor: Colors.red,
          //indicator: new ShapeDecoration(shape: Border()),
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black,
          tabs: <Tab>[
            new Tab(text: "组件"),
            new Tab(text: "main1main1main1main1"),
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

class PageBody extends StatefulWidget {
  String title;

  PageBody(this.title);

  @override
  State<StatefulWidget> createState() {
    return PageBodyState();
  }
}

class PageBodyState extends State<PageBody> with AutomaticKeepAliveClientMixin {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("PageBodyState:this=$this");
          setState(() {
            count++;
          });
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Text("${widget.title},count=$count"),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true; //wantKeepAlive=true时state不会重置
}
