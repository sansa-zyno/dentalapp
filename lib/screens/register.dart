import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_rescue/screens/get_started.dart';
import 'package:dental_rescue/services/localstore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  static const routename = "Register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController(text: '');

  TextEditingController passwordController = TextEditingController(text: '');

  TextEditingController nameController = TextEditingController(text: '');

  /* TextEditingController phoneController = TextEditingController(text: '');

  TextEditingController cardController = TextEditingController(text: '');

  TextEditingController expController = TextEditingController(text: '');

  TextEditingController cvvController = TextEditingController(text: '');*/

  File _image;
  String _profilePicUrl = '';
  final _key = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  bool signupLoading = false;
  bool hidePass = true;

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    String fileName = '${DateTime.now().toString()}.png';

    if (image != null) {
      ///Saving Pdf to firebase
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putData(image.readAsBytesSync());
      String urlImage = await (await uploadTask).ref.getDownloadURL();

      setState(() {
        _image = image;
        _profilePicUrl = urlImage;
      });
    }
  }

  upload() async {
    if (_profilePicUrl != "") {
      if (_formKey.currentState.validate()) {
        signupLoading = true;
        setState(() {});
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text)
              .then((value) async {
            User result = value.user;
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(result.uid)
                .set({
              "email": emailController.text,
              "password": passwordController.text,
              "name": nameController.text,
              "profilePicUrl": _profilePicUrl,
              /*"cardNo": cardController.text,
        "phone": phoneController.text,
        "Exp": expController.text,
        "cvv": cvvController.text,*/
              "role": "user",
              "status": "online",
            });
          });
          SharedPreferenceHelper().saveUserName(nameController.text);
          signupLoading = false;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => Get_Started()),
              (route) => false);
        } on FirebaseAuthException catch (signUpError) {
          setState(() {
            signupLoading = false;
          });
          if (signUpError.code == "email-already-in-use") {
            _key.currentState.showSnackBar(SnackBar(
                content: Text("Email already in use",
                    style: TextStyle(color: Colors.red)),
                backgroundColor: Color(0xfff4f5f6)));
          } else if (signUpError.code == "invalid-email") {
            _key.currentState.showSnackBar(SnackBar(
                content: Text("Invalid email address",
                    style: TextStyle(color: Colors.red)),
                backgroundColor: Color(0xfff4f5f6)));
          } else if (signUpError.code == "weak-password") {
            _key.currentState.showSnackBar(SnackBar(
                content:
                    Text("Weak password", style: TextStyle(color: Colors.red)),
                backgroundColor: Color(0xfff4f5f6)));
          }
        }
      }
    } else {
      _key.currentState.showSnackBar(SnackBar(
        content: Text("You must upload a profile picture to continue",
            style: TextStyle(color: Colors.red)),
        backgroundColor: Color(0xfff4f5f6),
      ));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    /*phoneController.dispose();
    cardController.dispose();
    expController.dispose();
    cvvController.dispose();*/
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Adobe XD layer: 'Register' (text)

                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    'Register',
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

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                /* Container(
                  margin: EdgeInsets.only(left: 15),
                  child: // Adobe XD layer: 'Please fill out the…' (text)
                      Text(
                    'Please fill out the form below to complete the process, you will be charged \$6.99/month',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 13.429508209228516,
                      color: const Color(0xff919191),
                      height: 1.4892578111130206,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),*/

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),

                Center(
                  child: InkWell(
                    onTap: getImage,
                    child: Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(0, 0),
                          blurRadius: 5,
                        ),
                      ]),
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50,
                          child: _image == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.grey,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.file(
                                    _image,
                                    height: 120,
                                  ))),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Add Profile picture',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),

                // Adobe XD layer: 'Email Address' (text)
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

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

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

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),

                Container(
                  margin: EdgeInsets.only(left: 15, right: 20),
                  child: Text(
                    'Your Name',
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

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

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
                      controller: nameController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "ben smith"),
                      validator: (value) {
                        if (value == "") {
                          return "This field must not be empty.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

                Container(
                  margin: EdgeInsets.only(left: 15, right: 20),
                  child: Text(
                    'password',
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

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

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
                        if (value.isEmpty) {
                          return "This field cannot be empty";
                        } else if (value.length < 6) {
                          return "The password has to be at least 6 characters long";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                /*SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),

                Container(
                  margin: EdgeInsets.only(left: 15, right: 20),
                  child: Text(
                    'Phone number',
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

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

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
                      controller: phoneController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "124 31242 24"),
                      validator: (value) {
                        if (value == "") {
                          return "This field must not be empty.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
//card no
                Container(
                  margin: EdgeInsets.only(left: 15, right: 20),
                  child: Text(
                    'Card number',
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

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

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
                      controller: cardController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "124 31242 24"),
                      validator: (value) {
                        if (value == "") {
                          return "This field must not be empty.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),

                Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15, right: 20),
                            child: Text(
                              'Expiration Date',
                              style: TextStyle(
                                fontFamily: 'Noto Sans',
                                fontSize: 16,
                                color: const Color(0xff232323),
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.left,
                            ),
                          ),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),

                          // Adobe XD layer: 'Frame 1' (shape)
                          Container(
                            margin: EdgeInsets.only(left: 15, right: 20),
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: const Color(0xfff4f5f6),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: expController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "124 31242 24"),
                                validator: (value) {
                                  if (value == "") {
                                    return "This field must not be empty.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15, right: 20),
                            child: Text(
                              'CVV number',
                              style: TextStyle(
                                fontFamily: 'Noto Sans',
                                fontSize: 16,
                                color: const Color(0xff232323),
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.left,
                            ),
                          ),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),

                          // Adobe XD layer: 'Frame 1' (shape)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: const Color(0xfff4f5f6),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: cvvController,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: "111"),
                                validator: (value) {
                                  if (value == "") {
                                    return "This field must not be empty.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),*/

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                signupLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
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
                              upload();
                            }),
                      ), //expr date
              ],
            )),
          ),
        ),
      ),
    );
  }
}
