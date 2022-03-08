import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollection = _firestore.collection("Users");
//user class
  DocumentSnapshot _userDoc;

  Future<User> getCurrentUser() async {
    User currentUser = _auth.currentUser;
    return currentUser;
  }

  Future getUserDetails() async {
    User currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot = await _userCollection.doc(currentUser.uid).get();
    return documentSnapshot;
  }

  DocumentSnapshot get userDoc => _userDoc;

  void refreshUser() async {
    _userDoc = await getUserDetails();
    notifyListeners();
  }
}
