import 'package:flutter/material.dart';
import 'pull_refresh.dart';
import 'defualt_refresh_head.dart';
import 'defualt_refresh_foot.dart';

main() {
  runApp(MaterialApp(
    home: RefreshDemo(),
  ));
}

class RefreshDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RefreshState();
  }
}

class RefreshState extends State<RefreshDemo>
    with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();

  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 5000)).then((onValue) {});
  }

  Future<void> onLoadMore() async {
    await Future.delayed(Duration(milliseconds: 5000)).then((onValue) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("pullRefreshDemo"),
      ),
      body: Container(
        color: Colors.white,
        child: PullRefresh(
          onRefresh: onRefresh,
          onLoadMore: onLoadMore,
          headBuilder: (BuildContext context) {
            return DefualtRefreshHead();
          },
          footBuilder: (BuildContext context) {
            return DefualtRefreshFoot();
          },
          child: ListView.builder(
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: new Text("data$index"),
                      leading: new Icon(Icons.add_box),
                      subtitle: new Text("data$index"),
                      isThreeLine: false,
                      trailing: new Icon(Icons.arrow_right),
                      onTap: () {},
                    ),
                    new Divider(
                      height: 1,
                      color: Colors.orangeAccent,
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
