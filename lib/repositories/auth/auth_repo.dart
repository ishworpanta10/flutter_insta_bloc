import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_insta_clone/constants/firebase_collection_constants.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/repositories/auth/base_auth_repo.dart';

class AuthRepo extends BaseAuthRepo {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepo({FirebaseFirestore firebaseFirestore, auth.FirebaseAuth firebaseAuth})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Stream<auth.User> get user => _firebaseAuth.userChanges();

  @override
  Future<auth.User> signUpWithEmailAndPassword({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      _firebaseFirestore.collection(FirebaseConstants.users).doc(user.uid).set({
        "username": username,
        "email": email,
        "followers": 0,
        "following": 0,
      });
      return user;
    } on auth.FirebaseAuthException catch (err) {
      debugPrint('Error During SignUp in FirebaseAuth : ${err.message}');
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      debugPrint('Error During SignUp in Platform : ${err.message}');
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  Future<auth.User> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on auth.FirebaseAuthException catch (err) {
      debugPrint('Error During Login in FirebaseAuth ${err.message}');
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      debugPrint('Error During Login in Platform ${err.message}');
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
