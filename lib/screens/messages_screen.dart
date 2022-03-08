import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_rescue/screens/chat_screen.dart';
import 'package:dental_rescue/services/database.dart';
import 'package:dental_rescue/services/localstore.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  Messages({Key key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String myName;
  getMyName() async {
    myName = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  Stream chatroomStream;
  getChatRooms() async {
    chatroomStream = await Database().getChatRooms();
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyName();
  }

  @override
  void initState() {
    // TODO: implement initState
    getChatRooms();
    onScreenLoaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          //leading: Icon(Icons.notifications, color: Colors.black87,),
          title: Text(
            'Inbox',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder(
            stream: chatroomStream,
            builder: (ctx, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (cxt, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return ChatRoomListTile(ds["lastMessage"], ds['type'],
                            ds['read'], ds['lastMessageSendBy'], ds.id, myName);
                      })
                  : Container();
            }),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, type, chatRoomId, myUsername, sentBy;
  final bool read;
  ChatRoomListTile(this.lastMessage, this.type, this.read, this.sentBy,
      this.chatRoomId, this.myUsername);
  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";
  DocumentSnapshot _recipient;
  DocumentSnapshot _sender;

  getRecipientInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot _doc = await FirebaseFirestore.instance
        .collection('Users')
        .where('name', isEqualTo: username)
        .get();
    _recipient = _doc.docs[0];
    profilePicUrl = _recipient['profilePicUrl'];
    name = username;
    setState(() {});
  }

  getSenderDoc() async {
    QuerySnapshot _doc = await FirebaseFirestore.instance
        .collection('Users')
        .where('name', isEqualTo: widget.myUsername)
        .get();
    _sender = _doc.docs[0];
    setState(() {});
  }

  @override
  void initState() {
    getRecipientInfo();
    getSenderDoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.sentBy != widget.myUsername
        ? GestureDetector(
            onTap: () {
              if (_sender['role'] != _recipient['role']) {
                FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(widget.chatRoomId)
                    .update({"read": true});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat_Screen(
                              me: _sender,
                              recipient: _recipient,
                            )));
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        profilePicUrl,
                        fit: BoxFit.fill,
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      name != null
                          ? widget.type == "text"
                              ? Text(
                                  widget.lastMessage,
                                  style: TextStyle(
                                    color: widget.read
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    widget.lastMessage,
                                    height: 60,
                                    width: 60,
                                  ),
                                )
                          : Container()
                    ],
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
