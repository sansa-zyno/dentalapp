import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_rescue/provider/image_upload_provider.dart';
import 'package:dental_rescue/services/database.dart';
import 'package:dental_rescue/utils/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class ImageService {
  /*Future<String> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return null;
    }
  }*/

  Future<String> getImageUrl() async {
    String urlImage;
    try {
      File image = await Utils.pickImage(source: ImageSource.gallery);
      String fileName = '${DateTime.now().toString()}.png';

      if (image != null) {
        ///Saving Pdf to firebase
        Reference reference = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = reference.putData(await image.readAsBytes());
        urlImage = await (await uploadTask).ref.getDownloadURL();
      }
      return urlImage;
    } catch (e) {
      return null;
    }
  }

  void setImageMsg(String url, String chatRoomId, DocumentSnapshot doc) async {
    Map<String, dynamic> messageInfoMap = {
      "type": 'image',
      "photoUrl": url,
      "sendBy": doc['name'],
      "ts": Timestamp.now(),
    };

    String messageId = randomAlphaNumeric(12);

    Database().addMessage(chatRoomId, messageId, messageInfoMap).then((value) {
      Map<String, dynamic> lastMessageInfoMap = {
        "type": "image",
        "read": false,
        "lastMessage": url,
        "lastMessageSendTs": Timestamp.now(),
        "lastMessageSendBy": doc['name']
      };

      Database().updateLastMessageSend(chatRoomId, lastMessageInfoMap);
    });
  }

  void uploadImage(String chatRoomId, DocumentSnapshot doc,
      ImageUploadProvider imageUploadProvider) async {
    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await getImageUrl();

    imageUploadProvider.setToIdle();
    if (url != null) {
      setImageMsg(url, chatRoomId, doc);
    }
  }
}
