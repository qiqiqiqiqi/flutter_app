import 'package:flutter/material.dart';
import 'pull_refresh.dart';
import 'pullHeadContainer.dart';
import 'PullController.dart';

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
  PullController pullController;

  @override
  void initState() {
    super.initState();
    pullController = PullController(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("pullRefreshDemo"),
      ),
      body: PullRefresh(
        pullController: pullController,
        headBuilder: (PullController pullController) {
          return PullHeadContainer(
            pullState: pullController.currentPullState,
          );
        },
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: 100,
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
    );
  }
}
