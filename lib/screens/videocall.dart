/*import 'package:flutter/material.dart';

class Video_Call extends StatelessWidget {
  static const routename = "Video_Call";
  const Video_Call({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF0F0F5),
        body: Container(
            height: MediaQuery.of(context).size.height * 1,
            child: Stack(
              children: [
                //full pic user
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.78,
                    width: MediaQuery.of(context).size.width * 1,
                    child: FittedBox(
                        fit: BoxFit.fill,
                        child: Image.asset('images/user.png')),
                  ),
                ),

                //black container
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 05,
                    color: Colors.black.withOpacity(0.3),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                              // Adobe XD layer: 'Dr. Ngunyen' (text)
                              Text(
                                'Dr. Ngunyen',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans',
                                  fontSize: 24,
                                  color: const Color(0xe5ffffff),
                                  fontWeight: FontWeight.w600,
                                  height: 1.3333333333333333,
                                ),
                                textHeightBehavior: TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),

                              //second user
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Image.asset('images/seconduser.jpg'))
                            ],
                          ),
                        ),
                        // Adobe XD layer: '00:08:17' (text)

                        //end call time
                        Container(
                          padding: EdgeInsets.only(bottom: 25),
                          child: Column(
                            children: [
                              Text(
                                '00:08:17',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans',
                                  fontSize: 24,
                                  color: const Color(0xe5ffffff),
                                  height: 1.3333333333333333,
                                ),
                                textHeightBehavior: TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.026,
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        decoration: new BoxDecoration(
                                          color: Color(0xffC0C0C0),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                            'images/vuesax-linear-microphone-2.png')),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        decoration: new BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          'images/Call.png',
                                          color: Colors.white,
                                        )),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        decoration: new BoxDecoration(
                                          color: Color(0xffC0C0C0),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                            'images/vuesax-linear-video-slash.png')),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}*/
