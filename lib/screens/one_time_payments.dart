
/*import 'package:dental_rescue/provider/revenuecat.dart';
import 'package:dental_rescue/resources/purchase_api.dart';
import 'package:dental_rescue/utils/paywall_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OneTimePayment extends StatelessWidget {
  const OneTimePayment({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coins = Provider.of<RevenueCatProvider>(context).coins;

    void spend10Coins() {
      final provider = Provider.of<RevenueCatProvider>(context, listen: false);
      provider.spend10Coins();
    }

    void spend100Coins() {
      final provider = Provider.of<RevenueCatProvider>(context, listen: false);
      provider.spend100Coins();
    }

    return Container(
      child: Column(
        children: [
          Text("You have $coins coins"),
          SizedBox(height: 8),
          MaterialButton(
            child: Text("Get more coins"),
            onPressed: () {
              fetchOffers(context);
            }
          ),
          SizedBox(height: 8),
          MaterialButton(
            child: Text("Spend 10 coins"),
            onPressed: () {
              spend10Coins();
            }
          ),
          SizedBox(height: 8),
          MaterialButton(
            child: Text("Spend 100 coins"),
            onPressed: () {
              spend100Coins();
            }
          )
        ],
      ),
    );
  }

  Future fetchOffers(context) async {
    final offerings = await PurchaseApi.fetchOffersByIds(Coins.allIds);

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No Plans Found')));
    } else {
      //final offer = offerings.first;
      //print('offer: $offer');
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();
      showModalBottomSheet(
          context: context,
          builder: (context) => PaywallWidget(
              title: "Upgrade your Plan",
              description: "Upgrade to a new plan to enjoy more benefits",
              packages: packages,
              onClickedPackage: (package) async {
                final isSuccess = await PurchaseApi.purchasePackage(package);
                if (isSuccess) {
                  final provider = Provider.of<RevenueCatProvider>(context, listen: false);
                  provider.addCoinsPackage(package);
                }
                Navigator.pop(context);
              }));
    }
  }
}*/
