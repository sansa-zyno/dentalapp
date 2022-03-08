import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_rescue/screens/doctor_side.dart';
import 'package:dental_rescue/screens/home.dart';
import 'package:dental_rescue/screens/phone_number.dart';
import 'package:dental_rescue/screens/register.dart';
import 'package:dental_rescue/services/localstore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Login extends StatefulWidget {
  static const routename = "Login";
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController(text: '');

  TextEditingController passwordController = TextEditingController(text: '');
  final _key = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool hidePass = true;

  upload() async {
    if (_formKey.currentState.validate()) {
      try {
        isLoading = true;
        setState(() {});
        UserCredential result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        User user = result.user;
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        SharedPreferenceHelper().saveUserName(doc['name']);
        await Purchases.logIn(user.uid);
        if (doc['role'] == "doctor") {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(user.uid)
              .update({"status": "online"});
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => DoctorSide()),
              (route) => false);
          isLoading = false;
          setState(() {});
        } else {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(user.uid)
              .update({"status": "online"});
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => Home_Screen()),
              (route) => false);
          isLoading = false;
          setState(() {});
        }
      } on FirebaseAuthException catch (signUpError) {
        setState(() {
          isLoading = false;
        });
        if (signUpError.code == "user-not-found") {
          _key.currentState.showSnackBar(SnackBar(
              content: Text(
                  "There is no user record corresponding to this email address")));
        } else if (signUpError.code == "invalid-email") {
          _key.currentState
              .showSnackBar(SnackBar(content: Text("Invalid email address")));
        } else if (signUpError.code == "wrong-password") {
          _key.currentState
              .showSnackBar(SnackBar(content: Text("Wrong password")));
        }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffffffff),
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Adobe XD layer: 'Login' (text)

                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 26,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),

                /*Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    'Select your best way to enter the application',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 14,
                      color: const Color(0xff919191),
                      height: 1,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),*/

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),

                Center(child: Image.asset('images/Attachment.png')),
                // Adobe XD layer: 'Continue with phone…' (text)

                /* SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),*/

                Container(
                  margin: EdgeInsets.only(left: 15, right: 20),
                  child: Text(
                    'Email Address',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      color: const Color(0xff232323),
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),

                SizedBox(height: 5),

                // Adobe XD layer: 'Frame 1' (shape)
                Container(
                  margin: EdgeInsets.only(left: 15, right: 20),
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: const Color(0xfff4f5f6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "example@gmail.com"),
                      validator: (value) {
                        if (value == "") {
                          return "This field must not be empty.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                SizedBox(height: 15),

                Container(
                  margin: EdgeInsets.only(left: 15, right: 20),
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      color: const Color(0xff232323),
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),

                SizedBox(height: 5),

                // Adobe XD layer: 'Frame 1' (shape)
                Container(
                  margin: EdgeInsets.only(left: 15, right: 20),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: const Color(0xfff4f5f6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextFormField(
                      obscureText: hidePass,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "password",
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                hidePass = !hidePass;
                              });
                            }),
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "This field must not be empty.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Container(
                      height: 30,
                      width: 150,
                      color: Color(0xfff4f5f6),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            _resetPassword(emailController.text, context);
                          },
                          child: Text(
                            "Forgot Password?",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                /* Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.phone,color: const Color(0xff7672c9),),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.width * 0.04,
                        child: Image.asset('images/Vector.png')),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(Phone_number.routename);
                      },
                      child: Text(
                        'Continue with phone number',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 12,
                          color: const Color(0xff7672c9),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(FontAwesomeIcons.googlePlus,color: const Color(0xff7672c9),),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.width * 0.04,
                        child: Image.asset('images/Group.png')),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    // Adobe XD layer: 'Continue With Google' (text)
                    Text(
                      'Continue With Google',
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 12,
                        color: const Color(0xff7672c9),
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),*/

                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 1,
                        child: RaisedButton(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 16),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Color(0xff9490D5),
                          textColor: Colors.white,
                          onPressed: () {
                            upload();
                          },
                        ),
                      ),

                SizedBox(height: 8), //expr

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don’t have an account?"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    // Adobe XD layer: 'Continue With Google' (text)
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(Register.routename);
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          color: const Color(0xff7672C9),
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                        textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  void _resetPassword(String email, BuildContext ctx) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _key.currentState.showSnackBar(SnackBar(
        content: Text(
          "A recovery email has been sent to you.",
        ),
        backgroundColor: Theme.of(ctx).primaryColor,
      ));
    } on FirebaseAuthException catch (err) {
      var message = "An error has occured, please try again.";

      if (err.message != null) {
        message = err.message;
      }

      if (email == null || email.isEmpty) {
        message = "Please enter your registered email";
      }

      _key.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    } catch (err) {}
  }
}
