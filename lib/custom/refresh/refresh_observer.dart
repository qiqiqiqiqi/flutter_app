import 'refresh_state.dart';

class RefreshObserver {
  final List<RefreshObserve> refreshObserves = List();

  void subscribe(RefreshObserve refreshObserve) {
    refreshObserves.add(refreshObserve);
  }

  void unsubscribe(RefreshObserve refreshObserver) {
    refreshObserves.remove(refreshObserver);
  }

  void notifyStateChange(RefreshState refreshState, double offsetY) {
    for (RefreshObserve refreshObserve in refreshObserves) {
      refreshObserve.onRefreshState(refreshState, offsetY);
    }
  }
}

abstract class RefreshObserve {
  void onRefreshState(RefreshState refreshState, double offsetY);
}
