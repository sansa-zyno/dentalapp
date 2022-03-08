import 'package:dental_rescue/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:dental_rescue/models/call.dart';
import 'package:dental_rescue/resources/call_methods.dart';
import 'package:dental_rescue/screens/callscreens/video_call_screen.dart';
import 'package:dental_rescue/utils/permissions.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class VideoPickupScreen extends StatefulWidget {
  final Call call;

  VideoPickupScreen({
    @required this.call,
  });

  @override
  _VideoPickupScreenState createState() => _VideoPickupScreenState();
}

class _VideoPickupScreenState extends State<VideoPickupScreen> {
  final CallMethods callMethods = CallMethods();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterRingtonePlayer.playRingtone();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    FlutterRingtonePlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Video call Incoming...",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 50),
              CachedImage(
                widget.call.callerPic,
                isRound: true,
                radius: 180,
              ),
              SizedBox(height: 15),
              Text(
                widget.call.callerName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 75),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.call_end),
                    color: Colors.redAccent,
                    onPressed: () async {
                      FlutterRingtonePlayer.stop();
                      await callMethods.endCall(call: widget.call);
                    },
                  ),
                  SizedBox(width: 25),
                  IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      FlutterRingtonePlayer.stop();
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoCallScreen(call: widget.call),
                              ),
                            )
                          : {};
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
