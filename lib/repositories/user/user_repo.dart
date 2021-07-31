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
    final doc = await _firebaseFirestore.collection(FirebaseCollectionConstants.user).doc(userId).get();
    return doc.exists ? UserModel.fromDocument(doc) : UserModel.empty;
  }

  @override
  Future<void> updateUser({@required UserModel userModel}) async {
    await _firebaseFirestore.collection(FirebaseCollectionConstants.user).doc(userModel.id).update(
          userModel.toDocument(),
        );
  }

  @override
  Future<List<UserModel>> searchUsers({@required String query}) async {
    final userCollection = FirebaseCollectionConstants.user;
    final userSnap = await _firebaseFirestore.collection(userCollection).where("username", isGreaterThanOrEqualTo: query).get();
    return userSnap.docs.map((queryDocSnap) => UserModel.fromDocument(queryDocSnap)).toList();
  }

  @override
  void followUser({@required String userId, @required String followUserId}) {
    final followers = FirebaseCollectionConstants.followers;
    final following = FirebaseCollectionConstants.following;
    final userFollowers = FirebaseCollectionConstants.userFollowers;
    final userFollowing = FirebaseCollectionConstants.userFollowing;

    /// add followUser to user's collection
    _firebaseFirestore.collection(following).doc(userId).collection(userFollowing).doc(followUserId).set({});

    /// add current user to followUser's userFollowers.
    _firebaseFirestore.collection(followers).doc(followUserId).collection(userFollowers).doc(userId).set({});
  }

  @override
  void unfollowUser({@required String userId, @required String unfollowUserId}) {
    final followers = FirebaseCollectionConstants.followers;
    final following = FirebaseCollectionConstants.following;
    final userFollowers = FirebaseCollectionConstants.userFollowers;
    final userFollowing = FirebaseCollectionConstants.userFollowing;

    /// remove unfollowing user from user's userFollowing
    _firebaseFirestore.collection(following).doc(userId).collection(userFollowing).doc(unfollowUserId).delete();

    /// remove user from unfollowUser's usersFollowers.
    _firebaseFirestore.collection(followers).doc(unfollowUserId).collection(userFollowers).doc(userId).delete();
  }

  @override
  Future<bool> isFollowing({@required String userId, @required String otherUserId}) async {
    final followers = FirebaseCollectionConstants.followers;
    final following = FirebaseCollectionConstants.following;
    final userFollowers = FirebaseCollectionConstants.userFollowers;
    final userFollowing = FirebaseCollectionConstants.userFollowing;

    /// is otherUser in user's userFollowing
    final otherUserDoc = await _firebaseFirestore.collection(following).doc(userId).collection(userFollowing).doc(otherUserId).get();
    return otherUserDoc.exists;
  }
}
