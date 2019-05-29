import 'package:flutter_app/custom/citypicker/view/single_tap_selector_container.dart';

class TabObserver {
  final List<TabObserve> tabObserves = List();

  void subscribe(TabObserve tabObserve) {
    tabObserves.add(tabObserve);
  }

  void unsubscribe(TabObserve tabObserver) {
    tabObserves.remove(tabObserver);
  }

  void notifyTabChange(AddressTab addressTab) {
    for (TabObserve refreshObserve in tabObserves) {
      refreshObserve.onTabChange(addressTab);
    }
  }
}

abstract class TabObserve {
  void onTabChange(AddressTab addressTab);
}
