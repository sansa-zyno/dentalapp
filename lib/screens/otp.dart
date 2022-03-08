/*
import 'package:dental_rescue/screens/get_started.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTP_Screen extends StatefulWidget {
  static const routename = "OTP_Screen";

  @override
  _OTP_ScreenState createState() => _OTP_ScreenState();
}

class _OTP_ScreenState extends State<OTP_Screen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

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
            ),
          ),
        ),
        backgroundColor: Color(0xffffffff),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: // Adobe XD layer: 'Verification' (text)
                      Scrollbar(
                    child: SingleChildScrollView(
                      child: Text(
                        'Verification',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 32,
                          color: const Color(0xff232323),
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                        textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),

                // Adobe XD layer: 'We have already sen…' (text)
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    'We have already sent the 4 digits code to +122357778789, please fill it below',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      color: const Color(0xff232323),
                      height: 1.5,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.099,
                ),

                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Form(
                    key: _formKey,
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      onChanged: (value) {
                        print(value);
                      },
                      onCompleted: (value) {
                        setState(() {});
                      },
                      onAutoFillDisposeAction: AutofillContextAction.cancel,
                      autoDisposeControllers: true,
                      cursorColor: Colors.black,
                      pinTheme: PinTheme(
                          activeColor: Colors.black,
                          selectedColor: Colors.black,
                          inactiveFillColor: Colors.black,
                          disabledColor: Colors.black,
                          activeFillColor: Colors.black,
                          inactiveColor: Colors.black,
                          fieldWidth: 70),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

                Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          color: const Color(0xff000000),
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'Didn’t receive SMS?',
                          ),
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          TextSpan(
                            text: 'Resend',
                            style: TextStyle(
                              color: const Color(0xff7672c9),
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 1,
                  child: RaisedButton(
                    child: Text(
                      'VERIFY',
                      style: TextStyle(fontSize: 16),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Color(0xff9490D5),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushNamed(Get_Started.routename);
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.035,
                ),
                Center(
                  child: FlatButton(
                      onPressed: () {},
                      child: Text("RESEND",
                          style: TextStyle(
                            color: Color(0xff9490D5),
                          ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
