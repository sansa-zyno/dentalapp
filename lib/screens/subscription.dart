import 'package:dental_rescue/models/entitlement.dart';
import 'package:dental_rescue/provider/revenuecat.dart';
import 'package:dental_rescue/resources/purchase_api.dart';
import 'package:dental_rescue/utils/paywall_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Subscription extends StatelessWidget {
  const Subscription({Key key}) : super(key: key);
  static const routename = "Subscription_Screen";

  @override
  Widget build(BuildContext context) {
    final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Subscriptions",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.015,
              ),
              Text(
                  "This is a must have app for every family to have just in case of a dental emergency."),
              SizedBox(
                height: height * 0.015,
              ),
              Text(
                  "Dental Rescue is an app that allows you connect a trusted dentist for advices and prescriptions during a dental emergency. It is like having your trusted dentist on demand. "),
              SizedBox(
                height: height * 0.015,
              ),
              Text(
                  "Have peace of mind when you experience a dental emergency. This app will connect you to Dr Nguyen anytime and anywhere."),
              SizedBox(
                height: height * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Get Access to Dr Nguyen in minutes ",
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.015,
              ),
              Text(
                  "Speak to him in minutes either by text, phone  or video. He will give you advice and guide you through your dental emergency. Most importantly, Dr Nguyen can prescribe medication to you through the app."),
              SizedBox(
                height: height * 0.05,
              ),
              buildEntitlement(entitlement),
              SizedBox(height: height * 0.03),
              MaterialButton(
                  color: Colors.grey,
                  child: Text("See plans"),
                  onPressed: () {
                    //print(height);
                    fetchOffers(context);
                  }),
              height < 650
                  ? SizedBox(height: height * 0.03)
                  : SizedBox(height: height * 0.06),
              Text(
                "To cancel Subscription at any time, simply click on the plan and click on Manage Subscriptions. This will redirect you to Play Store where you can then cancel the Subscription ",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color(0xffADAADE),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future fetchOffers(context) async {
    final offerings = await PurchaseApi.fetchOffers(all: false);

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
                await PurchaseApi.purchasePackage(package);
                Navigator.pop(context);
              }));
    }
  }

  Widget buildEntitlement(Entitlement entitlement) {
    switch (entitlement) {
      case Entitlement.allcourses:
        return buildEntitlementIcon(
            text: "You are on paid plan", icon: Icons.payment);

      case Entitlement.free:
      default:
        return buildEntitlementIcon(
            text: "You are on free plan", icon: Icons.lock);
    }
  }

  Widget buildEntitlementIcon({text, icon}) {
    return Center(
      child: Card(
        child: Container(
          height: 100,
          width: 250,
          padding: EdgeInsets.all(25),
          child: Column(
            children: [Text(text), SizedBox(height: 5), Icon(icon)],
          ),
        ),
      ),
    );
  }
}
