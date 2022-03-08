import 'package:dental_rescue/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Get_Started extends StatelessWidget {
  static const routename = "Get_Started";
  const Get_Started({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xffffffff),
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset('images/phone.png')),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xff0B090A),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.asset('images/nguyenpix.jpg')),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xff0B090A),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.asset('images/pharmacy.png')),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),

                // Adobe XD layer: 'Have peace of mind …' (text)
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Have peace of mind when you experience a dental emergency. This app will connect you to Dr Nguyen anytime and anywhere.',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 14,
                      color: const Color(0xff212121),
                      height: 1.5,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                // Adobe XD layer: 'Get Access to Dr Ng…' (text)
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Get Access to Dr Nguyen in minutes\nSpeak to him in minutes either text, chat or video. He can give you advice and guide you through your dental emergency. Most importantly, Dr Nguyen can prescribe medication to you directly through the app.\n\nSubscribe today!\n\$4.99 per month\n\n25% of fee will go to our local food pantry monthly.',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 14,
                      color: const Color(0xff919191),
                      height: 1.5,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),

                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 1,
                  child: RaisedButton(
                    child: // Adobe XD layer: 'Next' (text)
                        // Adobe XD layer: 'Get Started' (text)
                        Text(
                      'Get Started',
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 12,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Color(0xff9490D5),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(Home_Screen.routename);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
