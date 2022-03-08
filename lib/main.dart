import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_rescue/provider/image_upload_provider.dart';
import 'package:dental_rescue/provider/user_provider.dart';
import 'package:dental_rescue/resources/purchase_api.dart';
import 'package:dental_rescue/screens/about.dart';
import 'package:dental_rescue/screens/chat_screen.dart';
import 'package:dental_rescue/screens/doctor_side.dart';
import 'package:dental_rescue/screens/get_started.dart';
import 'package:dental_rescue/screens/home.dart';
import 'package:dental_rescue/screens/login.dart';
import 'package:dental_rescue/screens/register.dart';
import 'package:dental_rescue/screens/subscription.dart';
import 'package:dental_rescue/screens/terms_and_conditions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dental_rescue/provider/revenuecat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PurchaseApi.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final auth = FirebaseAuth.instance;

  /// RevenueCatProvider rev = RevenueCatProvider();

  setStatusOnline() async {
    final currentUser = auth.currentUser;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.uid)
        .update({"status": "online"});
  }

  setStatusAway() async {
    final currentUser = auth.currentUser;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.uid)
        .update({"status": "away"});
  }

  setStatusOffline() async {
    final currentUser = auth.currentUser;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.uid)
        .update({"status": "offline"});
  }

  @override
  void initState() {
    super.initState();
    /*FirebaseAuth.instance.authStateChanges().listen((userrr) async {
      if (userrr != null) {
        await Purchases.logIn(userrr.uid);
        print(userrr.uid);
      }
    });*/
    if (auth.currentUser != null) {
      setStatusOnline();
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (auth.currentUser != null) {
      if (state == AppLifecycleState.resumed) {
        setStatusOnline();
      } else {
        setStatusAway();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    setStatusOffline();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RevenueCatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Login()
                  : FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(auth.currentUser.uid)
                          .get(),
                      builder: (context, snap) {
                        return snap.hasData
                            ? snap.data['role'] == "doctor"
                                ? DoctorSide()
                                : Home_Screen()
                            : Scaffold(
                                body: Center(
                                child: CircularProgressIndicator(),
                              ));
                      });
            }),
        routes: {
          'Login': (context) => Login(),
          // 'Phone_number': (context) => Phone_number(),
          'Register': (context) => Register(),
          // 'OTP_Screen': (context) => OTP_Screen(),
          'About_Screen': (context) => About_Screen(),
          'T&C_Screen': (context) => TermsAndConditions(),
          'Get_Started': (context) => Get_Started(),
          'Home_Screen': (context) => Home_Screen(),
          'Chat_Screen': (context) => Chat_Screen(),
          'Doctor_Side': (context) => DoctorSide(),
          'Subscription_Screen': (context) => Subscription()
        },
      ),
    );
  }
}
