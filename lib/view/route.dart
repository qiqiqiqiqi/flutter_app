import 'package:flutter/material.dart';
import 'package:flutter_app/pagerouterbuilder/fadepagerouterbuilder.dart';
import 'package:flutter_app/pagerouterbuilder/slidepagerrouterbuilder.dart';
import 'package:flutter_app/pagerouterbuilder/rotationpagerouterbuilder.dart';

main() {
  runApp(new MaterialApp(
      title: "界面路由跳转",
      home: new FirstPager(
          products: List.generate(20, (i) => Product("商品 $i", "商品详情 $i")))));
}

class FirstPager extends StatelessWidget {
  List<Product> products;

  FirstPager({Key key, this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("商品列表")),
      body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return new Column(
              children: <Widget>[
                ListTile(
                  leading: new Icon(Icons.photo),
                  title: new Text(products[index].name),
                  onTap: () {
                    navigatorToSecondPager(context, products[index]);
                  },
                ),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                )
              ],
            );
          }),
    );
  }
}

navigatorToSecondPager(BuildContext context, Product product) async {
//  Product result = await Navigator.push(
//      context, MaterialPageRoute(builder: (context) => SecondPager(product)));
  Product result = await Navigator.push(
      context, RotationPageRouterBuilder(SecondPager(product)));
  Scaffold.of(context)
      .showSnackBar(new SnackBar(content: new Text("${result.toString()}")));
}

class SecondPager extends StatelessWidget {
  Product product;

  SecondPager(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("${product.details}")),
      body: new Center(
          child: new RaisedButton(
        onPressed: () {
          Navigator.pop(context, product);
        },
        child: new Text("返回上一级界面"),
      )),
    );
  }
}

class Product {
  String name;
  String details;

  Product(this.name, this.details);

  @override
  String toString() {
    return 'Product{name: $name, details: $details}';
  }
}
