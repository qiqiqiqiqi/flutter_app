import 'package:flutter/material.dart';
import 'round_button.dart';
import 'package:flutter_app/custom/citypicker/data/address.dart';
import 'package:flutter_app/custom/citypicker/view/address_container_InheritedWidget.dart';
import 'package:flutter_app/custom/citypicker/observer/address_observer.dart';

typedef OnTabSelected = void Function(AddressTab tab);
enum AddressTab { TAB_PROVINCE, TAB_CITY, TAB_AREA, TAB_UNSELECT }

class SingleSelectorContainer extends StatefulWidget {
  SingleSelectorContainer();

  @override
  State<StatefulWidget> createState() {
    return SingleSelectorContainerState();
  }
}

class SingleSelectorContainerState extends State<SingleSelectorContainer>
    with TickerProviderStateMixin, AddressObserve {
  AnimationController animationController;
  AddressTab currentTab = AddressTab.TAB_PROVINCE;
  AddressTab preTab = AddressTab.TAB_PROVINCE;
  GlobalKey tipsGlobalkey;
  double progress = 0.0;
  double scale = 1.0;
  double translationX = 0.0;
  Map<AddressTab, GlobalKey> tabGlobalKeys;
  double offsetX = 0.0;
  Address address;
  AddressContainerInheritedWidget headContainerInheritedWidget;
  @override
  void dispose() {
    animationController?.dispose();
    if (headContainerInheritedWidget != null &&
        headContainerInheritedWidget.addressObserver != null) {
      headContainerInheritedWidget.addressObserver.unsubscribe(this);
    }
    super.dispose();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     headContainerInheritedWidget = AddressContainerInheritedWidget.of(context);
    if (headContainerInheritedWidget != null &&
        headContainerInheritedWidget.addressObserver != null) {
      headContainerInheritedWidget.addressObserver.subscribe(this);
    }
  }

  @override
  void initState() {
    super.initState();
    tabGlobalKeys = Map();
    tipsGlobalkey = GlobalKey();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animationController.addListener(() {
      setState(() {
        progress = animationController.value;
        RenderBox renderBoxProvince = tabGlobalKeys[AddressTab.TAB_PROVINCE]
            ?.currentContext
            ?.findRenderObject();
        Offset provinceOffset = renderBoxProvince.localToGlobal(Offset.zero);
        offsetX = renderBoxProvince.size.width / 2 + provinceOffset.dx;

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

        translationX = startX + (endX - startX) * progress - offsetX;

        //计算指示器的缩放
        if (renderBoxTarget.size.width >= renderBoxPre.size.width) {
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
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: buildSinglesWidgets(),
            ),
            Container(
              height: 1,
              color: address == null ? Colors.transparent : Color(0xFFF2F4F5),
            )
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
    if (address != null) {
      if (address.provinceData != null) {
        widgets.add(Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            StatefulRoundButton(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              key: insertKey(AddressTab.TAB_PROVINCE),
              child: LimitedBox(
                maxWidth: 100,
                child: Text("${address.provinceData.provinceName}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: currentTab == AddressTab.TAB_PROVINCE
                          ? Color(0xFF1AD9CA)
                          : Color(0xFF374147),
                      fontSize: 14,
                    )),
              ),
              onPress: () {
                changeIndex(AddressTab.TAB_PROVINCE);
              },
            ),
            Container(
              height: 2,
              child: Transform(
                alignment: AlignmentDirectional.center,
                transform: Matrix4.translationValues(translationX, 0, 0),
                child: Transform(
                  alignment: AlignmentDirectional.center,
                  transform: Matrix4.diagonal3Values(scale, 1, 1),
                  child: Container(
                    key: tipsGlobalkey,
                    color: Color(0xFF1AD9CA),
                    width:
                        1.0, //这里就设置为1吧，如果选择了省数据，上面的weiget的width肯定比1大；如果设置的比较大，有的省的weiget的width会比他小导致不对齐
                  ),
                ),
              ),
            )
          ],
        ));

        if (address.cityData == null) {
          widgets.add(Container(
            margin: EdgeInsets.only(left: 20),
            child: StatefulRoundButton(
              padding: EdgeInsets.symmetric(vertical: 16),
              key: insertKey(AddressTab.TAB_CITY),
              child: Text("请选择",
                  style: TextStyle(
                    color: currentTab == AddressTab.TAB_CITY
                        ? Color(0xFF1AD9CA)
                        : Color(0xFF374147),
                    fontSize: 14,
                  )),
              onPress: () {
                changeIndex(AddressTab.TAB_CITY);
              },
            ),
          ));
        }
      }

      if (address.cityData != null) {
        widgets.add(Container(
          margin: EdgeInsets.only(left: 20),
          child: StatefulRoundButton(
            padding: EdgeInsets.symmetric(vertical: 16),
            key: insertKey(AddressTab.TAB_CITY),
            child: LimitedBox(
              maxWidth: 100,
              child: Text("${address.cityData.cityName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: currentTab == AddressTab.TAB_CITY
                        ? Color(0xFF1AD9CA)
                        : Color(0xFF374147),
                    fontSize: 14,
                  )),
            ),
            onPress: () {
              changeIndex(AddressTab.TAB_CITY);
            },
          ),
        ));

        if (address.areaData == null) {
          widgets.add(Container(
            margin: EdgeInsets.only(left: 20),
            child: StatefulRoundButton(
              padding: EdgeInsets.symmetric(vertical: 16),
              key: insertKey(AddressTab.TAB_AREA),
              child: Text("请选择",
                  style: TextStyle(
                    color: currentTab == AddressTab.TAB_AREA
                        ? Color(0xFF1AD9CA)
                        : Color(0xFF374147),
                    fontSize: 14,
                  )),
              onPress: () {
                changeIndex(AddressTab.TAB_AREA);
              },
            ),
          ));
        }
      }

      if (address.areaData != null) {
        widgets.add(Expanded(child: Container(
          margin: EdgeInsets.only(left: 20),
          child: StatefulRoundButton(
            padding: EdgeInsets.symmetric(vertical: 16),
            key: insertKey(AddressTab.TAB_AREA),
            child: LimitedBox(
              maxWidth: 100,
              child: Text("${address.areaData.areaName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: currentTab == AddressTab.TAB_AREA
                        ? Color(0xFF1AD9CA)
                        : Color(0xFF374147),
                    fontSize: 14,
                  )),
            ),
            onPress: () {
              changeIndex(AddressTab.TAB_AREA);
            },
          ),
        )));
      }
    } else {
      widgets.add(Container());
    }
    return widgets;
  }

  void changeIndex(AddressTab tab) {
    setState(() {
      changeTab(tab);
    });
  }

  void changeTab(AddressTab tab) {
    if (animationController?.status == AnimationStatus.forward) {
      return;
    }
    preTab = currentTab;
    currentTab = tab;
    animationController.forward(from: 0);

    AddressContainerInheritedWidget.of(context)
        .tabObserver
        .notifyTabChange(tab);
  }

  @override
  void onAddressChange(Address address) {
    print(
        'SingleSelectorContainerState--onAddressChange():address=${address.toString()}');
    setState(() {
      this.address = address;
      if (address != null) {
        if (address.provinceData != null) {
          if (address.cityData == null) {
            changeTab(AddressTab.TAB_CITY);
          }
        }
        if (address.cityData != null) {
          if (address.areaData == null) {
            changeTab(AddressTab.TAB_AREA);
          }
        }
        if (address.areaData != null) {
          changeTab(AddressTab.TAB_AREA);
        }
      }
    });
  }
}
