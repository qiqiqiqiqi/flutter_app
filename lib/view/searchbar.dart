import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    title: "searchbar demo",
    home: SearchBar(),
  ));
}

class SearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchBarState();
  }
}

class SearchBarState extends State<SearchBar> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("searchbar demo"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchBarDelegate(),
              );
            },
          )
        ],
      ),
    );
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  List<String> suggestList = [
    "good doctors",
    "liulangdiqiu",
    "labixiaoxing",
    "bianxingjinguang",
    "huoyingrenzhu",
    "haizeiwang"
  ];
  List<String> recentList = ["huoyingrenzhu", "haizeiwang"];

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
//    if (query.isEmpty) {
//      return Center(
//        child: Text("空空如也"),
//      );
//    } else {
//      return Center(
//        child: Text("result"),
//      );
//    }
  return searchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return searchResults();
  }

  ListView searchResults() {
    List<String> suggest = query.isEmpty
        ? suggestList
        : suggestList.where((child) {
            return child.contains(query);
          }).toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        int position = suggest[index].indexOf(query);
        return Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_box),
              title: RichText(
                  text: TextSpan(
                      text: suggest[index].substring(0, position),
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                    TextSpan(
                        text: suggest[index]
                            .substring(position, position + query.length),
                        style: TextStyle(color: Colors.redAccent)),
                    TextSpan(
                        text: suggest[index].substring(position + query.length),
                        style: TextStyle(color: Colors.black))
                  ])),
            ),
            Divider(
              height: 1,
              color: Colors.black,
            )
          ],
        );
      },
      itemCount: suggest.length,
    );
  }
}
