import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_rescue/screens/callscreens/video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:dental_rescue/models/call.dart';
import 'package:dental_rescue/resources/call_methods.dart';
import 'package:dental_rescue/screens/callscreens/voice_call_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static getAgoraToken(String channelId) async {
    var response = await http.get(Uri.parse(
        "https://nguyendentalapp.herokuapp.com/access_token?channelName=$channelId"));
    String token = jsonDecode(response.body)["token"];
    return token;
  }

  static dialVideo(
      {DocumentSnapshot from, DocumentSnapshot to, context}) async {
    String channelId = Random().nextInt(1000).toString();
    String token = await getAgoraToken(channelId);
    print(token);
    Call call = Call(
        callerId: from.id,
        callerName: from['name'],
        callerPic: from['profilePicUrl'],
        receiverId: to.id,
        receiverName: to['name'],
        receiverPic: to['profilePicUrl'],
        channelId: channelId,
        token: token,
        type: 'video');

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallScreen(call: call),
          ));
    }
  }

  static dialAudio(
      {DocumentSnapshot from, DocumentSnapshot to, context}) async {
    String channelId = Random().nextInt(1000).toString();
    String token = await getAgoraToken(channelId);
    print(token);
    Call call = Call(
        callerId: from.id,
        callerName: from['name'],
        callerPic: from['profilePicUrl'],
        receiverId: to.id,
        receiverName: to['name'],
        receiverPic: to['profilePicUrl'],
        channelId: channelId,
        token: token,
        type: 'call');

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallScreen(call: call),
          ));
    }
  }
}
