import 'package:flutter/material.dart';
import 'round_button.dart';

class SingleSelectorContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SingleSelectorContainerState();
  }
}

class SingleSelectorContainerState extends State<SingleSelectorContainer>
    with TickerProviderStateMixin {
  AnimationController animationController;
  int currentIndex = 0;
  int preIndex = 0;
  GlobalKey tipsGlobalkey;
  double progress = 0.0;
  double scale = 1.0;
  double translationX = 0.0;
  List<GlobalKey> tabGlobalKeys;

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabGlobalKeys = List();
    tipsGlobalkey = GlobalKey();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animationController.addListener(() {
      setState(() {
        progress = animationController.value;
        RenderBox renderBoxTips =
            tipsGlobalkey.currentContext?.findRenderObject();
        Offset tipsOffset = renderBoxTips.localToGlobal(Offset.zero);

        RenderBox renderBoxPre =
            tabGlobalKeys[preIndex]?.currentContext?.findRenderObject();
        Offset fromOffset = renderBoxPre.localToGlobal(Offset.zero);

        RenderBox renderBoxTarget =
            tabGlobalKeys[currentIndex]?.currentContext?.findRenderObject();
        Offset toOffset = renderBoxTarget.localToGlobal(Offset.zero);


        double startX = (renderBoxPre.size.width / 2 + fromOffset.dx);
        double endX = (renderBoxTarget.size.width / 2 + toOffset.dx);
        if (endX - startX >= 0) {
          if (preIndex == 0) {
            translationX = (endX - startX) * progress;
          } else {
            translationX = startX + (endX - startX) * progress-30;
          }
        } else {
          translationX = startX + (endX - startX) * progress-30;
        }

       // scale = renderBoxTarget.size.width / renderBoxPre.size.width;

        print('initState():preIndex=$preIndex,currentIndex=$currentIndex,'
            'translationX=$translationX');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: buildSinglesWidgets(),
          ),
          Transform(
            transform: Matrix4.translationValues(translationX, 0, 0),
            child:  Transform.scale(
              scale: scale,
              child: Container(
                key: tipsGlobalkey,
                color: Colors.green,
                width: 60,
                height: 4,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildSinglesWidgets() {
    tabGlobalKeys.clear();
    GlobalKey insertKey(int index) {
      GlobalKey globalKey = GlobalKey();
      tabGlobalKeys.add(globalKey);
      return globalKey;
    }

    return <Widget>[
      StatefulRoundButton(
        key: insertKey(0),
        width: 60,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Text("text0"),
        onPress: () {
          changeIndex(0);
        },
      ),
      StatefulRoundButton(
        key: insertKey(1),
        width: 60,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Text("text1"),
        onPress: () {
          changeIndex(1);
        },
      ),
      StatefulRoundButton(
        key: insertKey(2),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Text(
          "text2text2text2",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onPress: () {
          changeIndex(2);
        },
      ),
      StatefulRoundButton(
        key: insertKey(3),
        width: 60,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Text("text3"),
        onPress: () {
          changeIndex(3);
        },
      ),
    ];
  }

  void changeIndex(int index) {
    if(animationController?.status==AnimationStatus.forward){
      return;
    }
    preIndex = currentIndex;
    currentIndex = index;
    if (preIndex == currentIndex) {
      return;
    }
    animationController.forward(from: 0);
  }
}
