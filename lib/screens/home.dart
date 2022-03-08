import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_rescue/enum/view_state.dart';
import 'package:dental_rescue/modals/drawer.dart';
import 'package:dental_rescue/models/entitlement.dart';
import 'package:dental_rescue/provider/image_upload_provider.dart';
import 'package:dental_rescue/provider/revenuecat.dart';
import 'package:dental_rescue/provider/user_provider.dart';
import 'package:dental_rescue/screens/about.dart';
import 'package:dental_rescue/screens/callscreens/pickup/pickup_layout.dart';
import 'package:dental_rescue/screens/chat_screen.dart';
import 'package:dental_rescue/screens/messages_screen.dart';
import 'package:dental_rescue/screens/subscription.dart';
import 'package:dental_rescue/services/database.dart';
import 'package:dental_rescue/services/image_service.dart';
import 'package:dental_rescue/services/localstore.dart';
import 'package:dental_rescue/utils/call_utilities.dart';
import 'package:dental_rescue/utils/permissions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home_Screen extends StatefulWidget {
  static const routename = "Home_Screen";

  @override
  _Home_ScreenState createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  ImageUploadProvider _imageUploadProvider;
  DocumentSnapshot doc;
  DocumentSnapshot doctorSnap;
  String chatRoomId, myUserName;

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getUser() async {
    User currentUser = FirebaseAuth.instance.currentUser;
    doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.uid)
        .get();

    setState(() {});
  }

  Future<String> getDoctor() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Users")
        .where("role", isEqualTo: 'doctor')
        .get();

    doctorSnap = snap.docs[0];
    setState(() {});
    return doctorSnap['name'];
  }

  getChatRoomId(value) async {
    myUserName = await SharedPreferenceHelper().getUserName();
    chatRoomId = await getChatRoomIdByUsernames(value, myUserName);
    setState(() {});
  }

  UserProvider userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getDoctor().then((value) => getChatRoomId(value));

    /*Purchases.addPurchaserInfoUpdateListener((purchaserInfo) {
      print('uuuuuuuuuuuuuuuuuu');
      final entitlements = purchaserInfo.entitlements.active.values.toList();
      //_entitlement = entitlements.isEmpty ? Entitlement.free : Entitlement.allcourses;
      print(entitlements);
    });*/

    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scaffoldKey.currentState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;
    return SafeArea(
      child: PickupLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            title: Text(
              "Home",
              style: TextStyle(color: Colors.black),
            ),
            elevation: 0,
            backgroundColor: Color(0xffffffff),
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            leading: InkWell(
                onTap: () {
                  scaffoldKey.currentState.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SvgPicture.asset(
                    'images/Group 26.svg',
                    color: Color(0xff7672C9),
                  ),
                )),
            actions: [
              Stack(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.message,
                        color: Color(0xFF166138),
                        size: 30,
                      ),
                      onPressed: () async {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => Messages()));
                      }),
                  Positioned(
                      top: 0,
                      right: 2,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("chatrooms")
                              .where("read", isEqualTo: false)
                              .where('lastMessageSendBy',
                                  isNotEqualTo: myUserName)
                              .where("users", arrayContains: myUserName)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Center(
                                    child: Text('${snapshot.data.docs.length}'))
                                : Container();
                          },
                        ),
                      ))
                ],
              ),
              SizedBox(width: 10),
              /*Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(FontAwesomeIcons.fileAlt, color: Color(0xff7672C9)),
              )*/
            ],
          ),
          key: scaffoldKey,
          drawer: AppDrawer(doc: doc),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 1,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 90,
                        backgroundImage: AssetImage('images/nguyenpix.jpg'),
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .where("role", isEqualTo: "doctor")
                              .snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Positioned(
                                    bottom: 10,
                                    right: 25,
                                    child: Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: snapshot.data.docs[0]
                                                        ['status'] ==
                                                    'online'
                                                ? Colors.green
                                                : snapshot.data.docs[0]
                                                            ['status'] ==
                                                        'away'
                                                    ? Colors.orange
                                                    : Colors.grey)))
                                : Container();
                          })
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),

                  // Adobe XD layer: 'Have peace of mind …' (text)
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: // Adobe XD layer: 'I am here for you' (text)
                          Text(
                        'I am here for you',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          color: Color(0xFF166138),
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                        textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      )),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  // Adobe XD layer: 'Get Access to Dr Ng…' (text)
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: // Adobe XD layer: 'What do you need he…' (text)
                          Text(
                        'What do you need help with today? I am here for you. Do you have a dental emergency or have a question to ask me about your oral health? Please choose below',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 12,
                          color: const Color(0xff4d4d4d),
                          height: 1.5,
                        ),
                        textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      )),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  entitlement != Entitlement.free
                      ? _imageUploadProvider.getViewState == ViewState.LOADING
                          ? Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              // margin: EdgeInsets.only(left: 10,right: 10),
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => showModalBottomSheet(
                                      context: context,
                                      builder: (context) => buildsheet(
                                          context,
                                          scaffoldKey,
                                          doctorSnap,
                                          userProvider.userDoc,
                                          chatRoomId,
                                          _imageUploadProvider),
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(15)))),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset('images/Group 74.png'),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                InkWell(
                                  onTap: () => showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Second_Opinions(
                                          context,
                                          scaffoldKey,
                                          doctorSnap,
                                          userProvider.userDoc,
                                          chatRoomId,
                                          _imageUploadProvider),
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(15)))),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset('images/Group 72.png'),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(About_Screen.routename);
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset('images/Group 70.png'),
                                  ),
                                ),
                              ],
                            ))
                      : Center(
                          child: Column(children: [
                          Text('You have no active plan',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic)),
                          SizedBox(
                            height: 8.0,
                          ),
                          MaterialButton(
                            color: Colors.grey,
                            child: Text('Buy plan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                )),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(Subscription.routename);
                            },
                          ),
                        ])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildsheet(
        BuildContext context,
        scaffoldKey,
        DocumentSnapshot docsnap,
        DocumentSnapshot doc,
        String chatroomId,
        ImageUploadProvider imageUploadProvider) =>
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Center(
          child: Container(
            height: 3,
            width: 30,
            color: Color(0xffC4C4C4),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
        ),

        // Adobe XD layer: 'Photo' (text)
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            'Photo',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              color: const Color(0xff232323),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.left,
          ),
        ),
        // Adobe XD layer: 'Add photos of your …' (text)

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),

        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            'Add photos of your dental emergency',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 12,
              color: const Color(0xff4d4d4d),
              height: 1.5,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.left,
          ),
        ),
        GestureDetector(
          onTap: () async {
            Map<String, dynamic> chatRoomInfoMap = {
              "users": [doc['name'], docsnap['name']]
            };
            await Database().createChatRoom(chatroomId, chatRoomInfoMap);
            ImageService().uploadImage(chatroomId, doc, imageUploadProvider);
          },
          child: Container(
            margin: EdgeInsets.only(left: 20),
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: new BoxDecoration(
              color: Color(0xffEDEDF8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              FontAwesomeIcons.camera,
              color: Color(0xff7672C9),
              size: 30,
            ),
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        // Adobe XD layer: 'Service' (text)
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            'Service',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              color: const Color(0xff232323),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.left,
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        // Adobe XD layer: 'Select one of servi…' (text)
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            'Select one of services below to connect with dentist',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 12,
              color: const Color(0xff4d4d4d),
              height: 1.5,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      Map<String, dynamic> chatRoomInfoMap = {
                        "users": [doc['name'], docsnap['name']]
                      };
                      await Database()
                          .createChatRoom(chatroomId, chatRoomInfoMap);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) => Chat_Screen(
                                me: doc,
                                recipient: docsnap,
                              )));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: new BoxDecoration(
                        color: Color(0xffEDEDF8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        FontAwesomeIcons.commentDots,
                        color: Color(0xff7672C9),
                        size: 30,
                      ),
                    ),
                  ),

                  // Adobe XD layer: 'Message' (text)
                  Text(
                    'Message',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 10,
                      color: const Color(0xff7672c9),
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.07,
              ),
              InkWell(
                onTap: () async {
                  if (docsnap['status'] == "online") {
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? CallUtils.dialAudio(
                            from: doc, to: docsnap, context: context)
                        : {};
                  } else {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Dr Nguyen is not online at the moment, you can consider leaving a message instead")));
                  }
                },
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: new BoxDecoration(
                        color: Color(0xffEDEDF8),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: Icon(FontAwesomeIcons.phoneAlt,
                              color: Color(0xff7672c9), size: 30)),
                    ),

                    // Adobe XD layer: 'Voice Call' (text)
                    Text(
                      'Voice Call',
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 10,
                        color: const Color(0xff7672c9),
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.07,
              ),
              InkWell(
                onTap: () async {
                  //Navigator.of(context).pushNamed(Video_Call.routename);
                  if (docsnap['status'] == "online") {
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? CallUtils.dialVideo(
                            from: doc,
                            to: docsnap,
                            context: context,
                          )
                        : {};
                  } else {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Dr Nguyen is not online at the moment, you can consider leaving a message instead")));
                  }
                },
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: new BoxDecoration(
                          color: Color(0xffEDEDF8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(FontAwesomeIcons.video,
                            size: 30, color: Color(0xff7672c9))),
// Adobe XD layer: 'Video Call' (text)
                    Text(
                      'Video Call',
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 10,
                        color: const Color(0xff7672c9),
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
      ],
    );
Widget Second_Opinions(
        BuildContext context,
        scaffoldKey,
        DocumentSnapshot docsnap,
        DocumentSnapshot doc,
        String chatroomId,
        ImageUploadProvider imageUploadProvider) =>
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Center(
          child: Container(
            height: 3,
            width: 30,
            color: Color(0xffC4C4C4),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
        ),

        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            'Service',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              color: const Color(0xff232323),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.left,
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        // Adobe XD layer: 'Select one of servi…' (text)
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            'Select one of services below to connect with dentist',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 12,
              color: const Color(0xff4d4d4d),
              height: 1.5,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  Map<String, dynamic> chatRoomInfoMap = {
                    "users": [doc['name'], docsnap['name']]
                  };
                  await Database().createChatRoom(chatroomId, chatRoomInfoMap);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => Chat_Screen(
                            me: doc,
                            recipient: docsnap,
                          )));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.14,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: new BoxDecoration(
                          color: Color(0xffEDEDF8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.commentDots,
                          color: Color(0xff7672C9),
                          size: 28,
                        ),
                      ),

                      // Adobe XD layer: 'Message' (text)
                      Text(
                        'Message',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 10,
                          color: const Color(0xff7672c9),
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.14,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: new BoxDecoration(
                        color: Color(0xffEDEDF8),
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> chatRoomInfoMap = {
                            "users": [doc['name'], docsnap['name']]
                          };
                          await Database()
                              .createChatRoom(chatroomId, chatRoomInfoMap);
                          ImageService().uploadImage(
                              chatroomId, doc, imageUploadProvider);
                        },
                        child: Icon(
                          FontAwesomeIcons.camera,
                          color: Color(0xff7672C9),
                          size: 28,
                        ),
                      ),
                    ),

                    // Adobe XD layer: 'Voice Call' (text)
                    Text(
                      'Send Photo',
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 10,
                        color: const Color(0xff7672c9),
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              GestureDetector(
                onTap: () async {
                  Map<String, dynamic> chatRoomInfoMap = {
                    "users": [doc['name'], docsnap['name']]
                  };
                  await Database().createChatRoom(chatroomId, chatRoomInfoMap);
                  ImageService()
                      .uploadImage(chatroomId, doc, imageUploadProvider);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.14,
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: new BoxDecoration(
                            color: Color(0xffEDEDF8),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset('images/Group 62.png')),
                      Text(
                        'Document\n Opinion',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 10,
                          color: const Color(0xff7672c9),
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              InkWell(
                onTap: () async {
                  if (docsnap['status'] == "online") {
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? CallUtils.dialVideo(
                            from: doc,
                            to: docsnap,
                            context: context,
                          )
                        : {};
                  } else {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Dr Nguyen is not online at the moment, you can consider leaving a message instead")));
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.14,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: new BoxDecoration(
                          color: Color(0xffEDEDF8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.video,
                          color: Color(0xff7672C9),
                          size: 28,
                        ),
                      ),
// Adobe XD layer: 'Video Call' (text)
                      Text(
                        'Video Call',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 10,
                          color: const Color(0xff7672c9),
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
      ],
    );
