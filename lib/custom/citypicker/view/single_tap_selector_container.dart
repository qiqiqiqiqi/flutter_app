import 'package:flutter/material.dart';
import 'round_button.dart';
import 'package:flutter_app/custom/citypicker/data/address.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

typedef OnTabSelected = void Function(AddressTab tab);
enum AddressTab { TAB_PROVINCE, TAB_CITY, TAB_AREA, TAB_UNSELECT }

class SingleSelectorContainer extends StatefulWidget {
  OnTabSelected onTabSelected;
  Address address;

  SingleSelectorContainer({this.onTabSelected, this.address});

  @override
  State<StatefulWidget> createState() {
    return SingleSelectorContainerState();
  }
}

class SingleSelectorContainerState extends State<SingleSelectorContainer>
    with TickerProviderStateMixin {
  AnimationController animationController;
  AddressTab currentTab = AddressTab.TAB_PROVINCE;
  AddressTab preTab = AddressTab.TAB_PROVINCE;
  GlobalKey tipsGlobalkey;
  double progress = 0.0;
  double scale = 1.0;
  double translationX = 0.0;
  Map<AddressTab, GlobalKey> tabGlobalKeys;
  double offsetX = 0.0;
  double offsetX2 = 0.0;
  Vector.Vector3 vector3=Vector.Vector3(0.0, 0.0, 0.0);

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabGlobalKeys = Map();
    tipsGlobalkey = GlobalKey();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((Duration duration) {
//      setState(() {
//        RenderBox renderBoxTips =
//            tipsGlobalkey.currentContext?.findRenderObject();
//        vector3 = renderBoxTips.getTransformTo(null)?.getTranslation();
//        print('vector3=${vector3?.toString()}');
//        RenderBox renderBoxTarget =
//            tabGlobalKeys[currentTab]?.currentContext?.findRenderObject();
//        if (renderBoxTarget != null) {
//          offsetX = renderBoxTarget.size.width / 2;
//          scale = renderBoxTarget.size.width / renderBoxTips.size.width;
//          translationX = offsetX2 =
//              renderBoxTarget.size.width / 2 - renderBoxTips.size.width / 2;
//        }
//      });
    });

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animationController.addListener(() {
      setState(() {
        progress = animationController.value;

        RenderBox renderBoxTips =
            tipsGlobalkey.currentContext?.findRenderObject();
        RenderBox renderBoxPre =
            tabGlobalKeys[preTab]?.currentContext?.findRenderObject();
        Offset fromOffset = renderBoxPre.localToGlobal(Offset.zero);
        RenderBox renderBoxTarget =
            tabGlobalKeys[currentTab]?.currentContext?.findRenderObject();
        Offset toOffset = renderBoxTarget.localToGlobal(Offset.zero);

        double startX = (renderBoxPre.size.width / 2 + fromOffset.dx);
        double endX = (renderBoxTarget.size.width / 2 + toOffset.dx);
        //计算指示器相对于原点的偏移
        if (endX - startX > 0) {
          if (preTab == AddressTab.TAB_PROVINCE) {
            translationX = (endX - startX) * progress + offsetX2 - vector3?.x;
          } else {
            translationX = startX +
                (endX - startX) * progress -
                offsetX +
                offsetX2 -
                vector3?.x;
          }
        } else {
          translationX = startX +
              (endX - startX) * progress -
              offsetX +
              offsetX2 -
              vector3?.x;
        }
        //计算指示器的缩放
        if (renderBoxTarget.size.width > renderBoxPre.size.width) {
          scale = renderBoxPre.size.width / renderBoxTips.size.width +
              (renderBoxTarget.size.width / renderBoxTips.size.width -
                      renderBoxPre.size.width / renderBoxTips.size.width) *
                  progress;
        } else if (renderBoxTarget.size.width < renderBoxPre.size.width) {
          scale = renderBoxTarget.size.width / renderBoxTips.size.width +
              ((renderBoxPre.size.width / renderBoxTips.size.width) -
                      renderBoxTarget.size.width / renderBoxTips.size.width) *
                  (1 - progress);
        }
        print('initState():preIndex=$preTab,currentIndex=$currentTab,'
            'translationX=$translationX,scale=$scale');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: buildSinglesWidgets(),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> buildSinglesWidgets() {
    tabGlobalKeys.clear();
    GlobalKey insertKey(AddressTab tab) {
      GlobalKey globalKey = GlobalKey();
      tabGlobalKeys[tab] = globalKey;
      return globalKey;
    }

    List<Widget> widgets = List();
    if (widget.address != null) {
      if (widget.address.provinceData != null) {
        widgets.add(Column(
          children: <Widget>[
            StatefulRoundButton(
              key: insertKey(AddressTab.TAB_PROVINCE),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Text("${widget.address.provinceData.provinceName}"),
              onPress: () {
                changeIndex(AddressTab.TAB_PROVINCE);
              },
            ),
            Container(
              height: 4,
              child: Transform(
                alignment: AlignmentDirectional.center,
                transform: Matrix4.translationValues(translationX, 0, 0),
                child: Transform(
                  alignment: AlignmentDirectional.center,
                  transform: Matrix4.diagonal3Values(scale, 1, 1),
                  child: Container(
                    key: tipsGlobalkey,
                    color: Colors.green,
                    width: 60.0,
                  ),
                ),
              ),
            )
          ],
        ));
      }

      if (widget.address.cityData != null) {
        widgets.add(StatefulRoundButton(
          key: insertKey(AddressTab.TAB_CITY),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text("${widget.address.cityData.cityName}"),
          onPress: () {
            changeIndex(AddressTab.TAB_CITY);
          },
        ));
      }

      if (widget.address.areaData != null) {
        widgets.add(StatefulRoundButton(
          key: insertKey(AddressTab.TAB_AREA),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text("${widget.address.areaData.areaName}"),
          onPress: () {
            changeIndex(AddressTab.TAB_AREA);
          },
        ));
      }
    } else {
      widgets.add(Container());
    }
    return widgets;

    /*return <Widget>[
      StatefulRoundButton(
        key: insertKey(AddressTab.TAB_PROVINCE),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Text("text0text0"),
        onPress: () {
          changeIndex(AddressTab.TAB_PROVINCE);
        },
      ),
      StatefulRoundButton(
        key: insertKey(AddressTab.TAB_CITY),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Text("text1"),
        onPress: () {
          changeIndex(AddressTab.TAB_CITY);
        },
      ),
      StatefulRoundButton(
        key: insertKey(AddressTab.TAB_AREA),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Text(
          "text2text2text2",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onPress: () {
          changeIndex(AddressTab.TAB_AREA);
        },
      ),
    ];*/
  }

  void changeIndex(AddressTab tab) {
    if (animationController?.status == AnimationStatus.forward) {
      return;
    }
    preTab = currentTab;
    currentTab = tab;
    widget.onTabSelected?.call(tab);
    animationController.forward(from: 0);
  }
}
