import 'package:dental_rescue/models/entitlement.dart';
import 'package:dental_rescue/resources/purchase_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatProvider extends ChangeNotifier {
  RevenueCatProvider() {
    init();
  }

  int coins = 0;

  Entitlement _entitlement = Entitlement.free;
  Entitlement get entitlement => _entitlement;

  Future init() async {
    await updatePurchaseStatus();
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      final entitlements = purchaserInfo.entitlements.active.values.toList();
      _entitlement =
          entitlements.isEmpty ? Entitlement.free : Entitlement.allcourses;
      notifyListeners();
    });
  }

  Future updatePurchaseStatus() async {
    final purchaseInfo = await Purchases.getPurchaserInfo();
    final entitlements = purchaseInfo.entitlements.active.values.toList();
    _entitlement =
        entitlements.isEmpty ? Entitlement.free : Entitlement.allcourses;
    notifyListeners();
  }

  void addCoinsPackage(Package package) {
    switch (package.offeringIdentifier) {
      case Coins.idCoins10:
        coins += 10;
        break;
      case Coins.idCoins100:
        coins += 100;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void spend10Coins() {
    coins -= 10;
    notifyListeners();
  }

  void spend100Coins() {
    coins -= 100;
    notifyListeners();
  }
}
