import 'package:flutter/material.dart';
import 'package:flutter_app/fitforce/datarecord/common_round_button.dart';
import 'cardcontainer.dart';

main() {

  runApp(MaterialApp(
    title: 'ruler demo',
    home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        appBar: AppBar(title: Text('ruler demo')),
        body: new CardWidget(),
      );
    }),
  ));
}

class CardWidget extends StatelessWidget {
  CardController  cardController = CardController();
   CardWidget({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(child: CardContainer(cardController: cardController,)),
          buildButtonContainer(cardController)
        ],
      ),
    );
  }
}


Container buildButtonContainer( CardController  cardController ) {
  return Container(
    margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: StatefulRoundButton(
              margin: EdgeInsets.only(right: 10),
              height: 44,
              raduis: 4,
              child: Text(
                '上一题',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.none),
              ),
              onPress: () {
                cardController.previous();
              },
              pressBackgroundColor: Color(0x9eAAB2B7),
              normalBackgroundColor: Color(0xFFAAB2B7),
            )),
        StatefulRoundButton(
          height: 44,
          width: 215,
          raduis: 4,
          child: Text('下一题',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.none)),
          onPress: () {
            cardController.next();
          },
          pressBackgroundColor: Color(0xee1AD9CA),
          normalBackgroundColor: Color(0xFF1AD9CA),
        )
      ],
    ),
  );
}
