import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_rescue/provider/image_upload_provider.dart';
import 'package:dental_rescue/services/database.dart';
import 'package:dental_rescue/services/image_service.dart';
import 'package:dental_rescue/services/localstore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class Chat_Screen extends StatefulWidget {
  //static const routename="Chat_Screen";
  final recipient;
  final me;
  Chat_Screen({this.recipient, this.me});

  @override
  _Chat_ScreenState createState() => _Chat_ScreenState();
}

bool isMe = false;
final GlobalKey<FormState> _formKey = GlobalKey();

class _Chat_ScreenState extends State<Chat_Screen> {
  ImageUploadProvider _imageUploadProvider;
  TextEditingController messageTextEdittingController = TextEditingController();
  String chatRoomId, messageId = "";
  Stream messageStream;
  String myUserName;

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getMyInfoFromSharedPreference() async {
    myUserName = await SharedPreferenceHelper().getUserName();
    chatRoomId = getChatRoomIdByUsernames(widget.recipient['name'], myUserName);
  }

  addMessage(bool sendClicked) {
    if (messageTextEdittingController.text != "") {
      String message = messageTextEdittingController.text;

      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        "type": 'text',
        "message": message,
        "sendBy": widget.me['name'],
        "ts": lastMessageTs,
        "imgUrl": widget.me['profilePicUrl']
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      Database()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "type": "text",
          "read": false,
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myUserName
        };

        Database().updateLastMessageSend(chatRoomId, lastMessageInfoMap);
        if (sendClicked) {
          // remove the text in the message input field
          messageTextEdittingController.text = "";
          // make message id blank to get regenerated on next message send
          messageId = "";
        }
      });
    }
  }

  getAndSetMessages() async {
    messageStream = await Database().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return !sendByMe
        ? Wrap(
            alignment: WrapAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 10,
                  right: 50,
                  top: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffF0F0F5),
                ),
                padding:
                    EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 5),
                // height: MediaQuery.of(context).size.height*0.03,

                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 14,
                    color: const Color(0xff232323),
                    height: 1.5,
                  ),
                  textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          )
        : Wrap(
            alignment: WrapAlignment.end,
            children: [
              // Icon(Icons.phone,color: const Color(0xff7672c9),),
              Container(
                margin: EdgeInsets.only(
                  right: 10,
                  left: 50,
                  top: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff7672C9),
                ),
                padding:
                    EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 5),
                // height: MediaQuery.of(context).size.height*0.03,

                child: // Adobe XD layer: 'Hi Doc, I have some…' (text)
                    Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 14,
                    color: const Color(0xffffffff),
                    height: 1.5,
                  ),
                  textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          );
  }

  Widget imageMessageTile(String url, bool sendByMe) {
    return sendByMe
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Icon(Icons.phone,color: const Color(0xff7672c9),),
              url != null
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.only(
                        right: 15,
                        top: 10,
                        bottom: 10,
                      ),
                      child: FittedBox(
                          fit: BoxFit.fill, child: Image.network(url)),
                    )
                  : Container(),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icon(Icons.phone,color: const Color(0xff7672c9),),
              url != null
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.only(
                        left: 15,
                        top: 10,
                        bottom: 10,
                      ),
                      child: FittedBox(
                          fit: BoxFit.fill, child: Image.network(url)),
                    )
                  : Container(),
            ],
          );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ds['type'] == 'text'
                      ? chatMessageTile(
                          ds["message"], myUserName == ds["sendBy"])
                      : imageMessageTile(
                          ds['photoUrl'], myUserName == ds["sendBy"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    await getAndSetMessages();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doThisOnLaunch();
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffffffff),
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: false,
        title: ListTile(
          leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: widget.recipient['profilePicUrl'] != null
                  ? NetworkImage(widget.recipient['profilePicUrl'])
                  : Container()),
          title: // Adobe XD layer: 'Dr. Ngunyen' (text)
              Text(
            widget.recipient['name'],
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              color: const Color(0xff212121),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.left,
          ),
          subtitle: // Adobe XD layer: 'Online' (text)
              Text(
            widget.recipient['status'] == 'online'
                ? 'Online'
                : widget.recipient['status'] == 'away'
                    ? 'Away'
                    : "Offline",
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              color: const Color(0xff4d4d4d),
              height: 1.5,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),

            /*SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Icon(Icons.phone,color: const Color(0xff7672c9),),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff7672C9),
                  ),
                  padding:
                      EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 5),
                  // height: MediaQuery.of(context).size.height*0.03,

                  child: // Adobe XD layer: 'Hi Doc, I have some…' (text)
                      Text(
                    'Hi Doc, I have some problem with my tooth',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 10,
                      color: const Color(0xffffffff),
                      height: 1.5,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),*/
            Positioned(
                /*bottom: 0,
            left: 0,
            child: Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color(0xffEDEDF8),
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(12),*/
                bottom: 0,
                left: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      offset: Offset(-2, 0),
                      blurRadius: 5,
                    ),
                  ]),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ImageService().uploadImage(
                              chatRoomId, widget.me, _imageUploadProvider);
                        },
                        child: Container(
                          child: Icon(
                            FontAwesomeIcons.camera,
                            color: Color(0xff7672C9),
                            size: 28,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Form(
                              key: _formKey,
                              child: Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                child: TextFormField(
                                  controller: messageTextEdittingController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Write Something here...',
                                    labelStyle: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 14,
                                      color: const Color(0xff666666),
                                      height: 1.5,
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "*Required";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {},
                                  onChanged: (value) {},
                                  onFieldSubmitted: (value) {},
                                ),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      GestureDetector(
                        onTap: () {
                          addMessage(true);
                        },
                        child: Container(
                          child: Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            color: Color(0xff7672C9),
                            size: 28,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
