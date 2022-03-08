import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_rescue/screens/about.dart';
import 'package:dental_rescue/screens/edit_profile.dart';
import 'package:dental_rescue/screens/home.dart';
import 'package:dental_rescue/screens/login.dart';
import 'package:dental_rescue/screens/subscription.dart';
import 'package:dental_rescue/screens/terms_and_conditions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AppDrawer extends StatelessWidget {
  final DocumentSnapshot doc;
  AppDrawer({this.doc});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Drawer(
        child: Container(
      child: ListView(
        children: [
          Container(
            height: height < 650 ? height * 0.3 : height * 0.27,
            color: Color(0xffADAADE),
            child: Column(
              children: [
                doc != null
                    ? Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Container(
                                height: 90,
                                width: 90,
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    child: Image.network(
                                      doc['profilePicUrl'],
                                      fit: BoxFit.cover,
                                    ))),
                          ),
                          Container(
                            child: Column(
                              children: [
                                // Adobe XD layer: 'Darel Steward' (text)
                                Text(
                                  doc['name'],
                                  style: TextStyle(
                                    fontFamily: 'Noto Sans',
                                    fontSize: 16,
                                    color: const Color(0xfff2f2f2),
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                  textHeightBehavior: TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),

                                // Adobe XD layer: 'Example@xyz.com' (text)
                                Text(
                                  doc['email'],
                                  style: TextStyle(
                                    fontFamily: 'Noto Sans',
                                    fontSize: 12,
                                    color: const Color(0xfff2f2f2),
                                    height: 1.5,
                                  ),
                                  textHeightBehavior: TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.028,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 1,
                  child: RaisedButton(
                    child: // Adobe XD layer: 'Next' (text)
                        // Adobe XD layer: 'Get Started' (text)
                        Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 12,
                        color: Color(0xff7672C9),
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Color(0xffF2F2F2),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => EditProfile(doc)));
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            color: Color(0xffEDEDF8),
            child: ListTile(
              leading: Image.asset('images/Iconly-Light-Outline-Home.png'),
              title: Text("Home", style: TextStyle(color: Color(0xff7672C9))),
              onTap: () {
                Navigator.of(context).pushNamed(Home_Screen.routename);
              },
            ),
          ),
          ListTile(
            leading: Image.asset('images/vuesax-linear-card.png'),
            title: Text("Subscription", style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.of(context).pushNamed(Subscription.routename);
            },
          ),
          ListTile(
            leading: Image.asset('images/vuesax-linear-shield-tick.png'),
            title: Text("Terms of Conditions",
                style: TextStyle(color: Colors.black)),
            onTap: () async {
              Navigator.of(context).pushNamed(TermsAndConditions.routename);
            },
          ),
          ListTile(
            leading: Image.asset('images/Iconly-Light-Outline-Info-Square.png'),
            title: Text("About", style: TextStyle(color: Colors.black)),
            onTap: () async {
              Navigator.of(context).pushNamed(About_Screen.routename);
            },
          ),
          ListTile(
            leading: Image.asset('images/Logout.png'),
            title: Text("Logout", style: TextStyle(color: Colors.black)),
            onTap: () async {
              final currentUser = FirebaseAuth.instance.currentUser;
              await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(currentUser.uid)
                  .update({"status": "offline"});
              //await Purchases.logOut();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed(Login.routename);
            },
          ),
        ],
      ),
    ));
  }
}
