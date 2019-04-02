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
  int itemCount = 9;

  @override
  void initState() {
    super.initState();
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000)).then((onValue) {
      setState(() {
        if (itemCount > 10) {
          itemCount = 4;
        } else {
          itemCount++;
        }
      });
    });
  }

  Future<void> onLoadMore() async {
    print("RefreshDemo:onLoadMore()");
    await Future.delayed(Duration(milliseconds: 1000)).then((onValue) {
      setState(() {
        itemCount++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("pullRefreshDemo"),
      ),
      body: Container(
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
              cacheExtent: 0,
              padding: EdgeInsets.all(0),
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                  ),
                );
              }),
        ),
      ),
    );
  }
}
