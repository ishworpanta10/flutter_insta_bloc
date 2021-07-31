import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/constants/firebase_collection_constants.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/models/user_model.dart';
import 'package:flutter_insta_clone/repositories/repositories.dart';

class UserRepo extends BaseUserRepo {
  final FirebaseFirestore _firebaseFirestore;

  UserRepo({FirebaseFirestore firebaseFirestore}) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> getUserWithId({@required String userId}) async {
    final doc = await _firebaseFirestore.collection(FirebaseCollectionConstants.userCollection).doc(userId).get();
    return doc.exists ? UserModel.fromDocument(doc) : UserModel.empty;
  }

  @override
  Future<void> updateUser({@required UserModel userModel}) async {
    await _firebaseFirestore.collection(FirebaseCollectionConstants.userCollection).doc(userModel.id).update(
          userModel.toDocument(),
        );
  }

  @override
  Future<List<UserModel>> searchUsers({@required String query}) async {
    final userCollection = FirebaseCollectionConstants.userCollection;
    final userSnap = await _firebaseFirestore.collection(userCollection).where("username", isGreaterThanOrEqualTo: query).get();
    return userSnap.docs.map((queryDocSnap) => UserModel.fromDocument(queryDocSnap)).toList();
  }
}
