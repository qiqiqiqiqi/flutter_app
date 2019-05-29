
import 'package:flutter_app/custom/citypicker/data/address.dart';
class AddressObserver {
  final List<AddressObserve> addressObserves = List();

  void subscribe(AddressObserve addressObserve) {
    addressObserves.add(addressObserve);
  }

  void unsubscribe(AddressObserve addressObserver) {
    addressObserves.remove(addressObserver);
  }

  void notifyStateChange(Address address) {
    for (AddressObserve refreshObserve in addressObserves) {
      refreshObserve.onAddressChange(address);
    }
  }
}

abstract class AddressObserve {
  void onAddressChange(Address address);
}
