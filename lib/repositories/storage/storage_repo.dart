import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_insta_clone/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

class StorageRepo extends BaseStorgaeRepo {
  final FirebaseStorage _firebaseStorage;

  StorageRepo({FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<String> _uploadImageAndReturnURl(
      {@required File image, @required String ref}) async {
    final downloadUrl = await _firebaseStorage
        .ref(ref)
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
    return downloadUrl;
  }

  @override
  Future<String> uploadPostImageAndGiveUrl({@required File image}) async {
    final imageId = Uuid().v4();
    final ref = 'images/posts/post_$imageId.jpg';
    final downloadUrl = await _uploadImageAndReturnURl(image: image, ref: ref);
    return downloadUrl;
  }

  @override
  Future<String> uploadProfileImageAndGiveUrl(
      {@required String url, @required File image}) async {
    var imageId = Uuid().v4();

    //update profile image
    if (url.isNotEmpty) {
      final exp = RegExp(r'userProfile_(.*).jpg');
      imageId = exp.firstMatch(url)[1];
    }

    final ref = 'images/users/userProfile_$imageId.jpg';
    final downloadUrl = await _uploadImageAndReturnURl(image: image, ref: ref);
    return downloadUrl;
  }
}
