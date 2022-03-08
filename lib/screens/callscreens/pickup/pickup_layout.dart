import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_rescue/provider/user_provider.dart';
import 'package:dental_rescue/screens/callscreens/pickup/voice_pickup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dental_rescue/models/call.dart';
import 'package:dental_rescue/resources/call_methods.dart';
import 'package:dental_rescue/screens/callscreens/pickup/video_pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    @required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return (userProvider != null && userProvider.userDoc != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.userDoc.id),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data() != null) {
                Call call = Call.fromMap(snapshot.data.data());
                if (!call.hasDialled) {
                  if (call.type == "video") {
                    return VideoPickupScreen(call: call);
                  } else {
                    return VoicePickupScreen(call: call);
                  }
                }
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
