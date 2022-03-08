
/*import 'package:dental_rescue/screens/otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Phone_number extends StatefulWidget {
  static const routename = "Phone_number";

  @override
  _Phone_numberState createState() => _Phone_numberState();
}

class _Phone_numberState extends State<Phone_number> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),

              Text(
                'Phone Number',
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 26,
                  color: const Color(0xff232323),
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.left,
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.099,
              ),

              // Adobe XD layer: 'Easy way to enter t…' (text)
              Text(
                'Easy way to enter the application using your phone number',
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

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),

              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 1,
                child: RaisedButton(
                  child: // Adobe XD layer: 'Next' (text)
                      Text(
                    'Next',
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
                        .pushReplacementNamed(OTP_Screen.routename);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
