import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_rescue/provider/user_provider.dart';
import 'package:dental_rescue/screens/chat_screen.dart';
import 'package:dental_rescue/screens/login.dart';
import 'package:dental_rescue/screens/messages_screen.dart';
import 'package:dental_rescue/services/database.dart';
import 'package:dental_rescue/utils/call_utilities.dart';
import 'package:dental_rescue/utils/permissions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'callscreens/pickup/pickup_layout.dart';

class DoctorSide extends StatefulWidget {
  const DoctorSide({Key key}) : super(key: key);

  @override
  _DoctorSideState createState() => _DoctorSideState();
}

class _DoctorSideState extends State<DoctorSide> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Stream userStream;
  DocumentSnapshot doctorSnap;
  UserProvider userProvider;

  getUser() async {
    User currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser.uid);
    doctorSnap = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.uid)
        .get();

    setState(() {});
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });
    getUser();
    userStream = FirebaseFirestore.instance
        .collection('Users')
        .where("role", isEqualTo: 'user')
        .snapshots();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Container(
              child: Center(
            child: Text(
              'Users/Patients',
              style: TextStyle(color: Color(0xFF166138)),
            ),
          )),
          backgroundColor: Colors.white,
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
                                isNotEqualTo: doctorSnap['name'])
                            .where("users", arrayContains: doctorSnap['name'])
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
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Color(0xFF166138),
                ),
                onPressed: () async {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(currentUser.uid)
                      .update({"status": "offline"});
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => Login()));
                }),
            SizedBox(width: 10),
          ],
        ),
        body: StreamBuilder(
            stream: userStream,
            builder: (ctx, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemBuilder: (ctx, index) {
                        DocumentSnapshot snap = snapshot.data.docs[index];
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(2, 2),
                                )
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Stack(children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Center(
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: Image.network(
                                                  snap['profilePicUrl'])),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          right: 2,
                                          child: Container(
                                              height: 15,
                                              width: 15,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: snap['status'] ==
                                                          'online'
                                                      ? Colors.green
                                                      : snap['status'] == 'away'
                                                          ? Colors.orange
                                                          : Colors.grey)))
                                    ]),
                                    SizedBox(width: 30),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snap['name'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              child: Icon(
                                                Icons.chat,
                                                color: Color(0xFF166138),
                                              ),
                                              onTap: () {
                                                var chatRoomId =
                                                    getChatRoomIdByUsernames(
                                                        doctorSnap['name'],
                                                        snap['name']);

                                                Map<String, dynamic>
                                                    chatRoomInfoMap = {
                                                  "users": [
                                                    doctorSnap['name'],
                                                    snap['name']
                                                  ]
                                                };
                                                Database().createChatRoom(
                                                    chatRoomId,
                                                    chatRoomInfoMap);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (cxt) =>
                                                          Chat_Screen(
                                                            me: doctorSnap,
                                                            recipient: snap,
                                                          )),
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            InkWell(
                                              child: Icon(
                                                Icons.call,
                                                color: Color(0xFF166138),
                                              ),
                                              onTap: () async {
                                                if (snap['status'] ==
                                                    "online") {
                                                  await Permissions
                                                          .cameraAndMicrophonePermissionsGranted()
                                                      ? CallUtils.dialAudio(
                                                          from: doctorSnap,
                                                          to: snap,
                                                          context: context,
                                                        )
                                                      : {};
                                                } else {
                                                  scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "${snap['name']} is not online at the moment, you can consider leaving a message instead")));
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            InkWell(
                                              child: Icon(
                                                Icons.video_call,
                                                color: Color(0xFF166138),
                                              ),
                                              onTap: () async {
                                                if (snap['status'] ==
                                                    "online") {
                                                  await Permissions
                                                          .cameraAndMicrophonePermissionsGranted()
                                                      ? CallUtils.dialVideo(
                                                          from: doctorSnap,
                                                          to: snap,
                                                          context: context,
                                                        )
                                                      : {};
                                                } else {
                                                  scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "${snap['name']} is not online at the moment, you can consider leaving a message instead")));
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data.docs.length,
                    )
                  : Container();
            }),
      ),
    );
  }
}
