import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_insta_clone/constants/firebase_collection_constants.dart';
import 'package:flutter_insta_clone/models/comment_model.dart';
import 'package:flutter_insta_clone/models/post_model.dart';
import 'package:flutter_insta_clone/repositories/post/base_post_repository.dart';

class PostRepository extends BasePostRepo {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore firebaseFirestore}) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPost({@required PostModel postModel}) async {
    final postCollection = FirebaseCollectionConstants.postCollection;
    await _firebaseFirestore.collection(postCollection).add(
          postModel.toDocuments(),
        );
  }

  @override
  Future<void> createComment({@required CommentModel commentModel}) async {
    final commentCollection = FirebaseCollectionConstants.commentCollection;
    final postCommentCollection = FirebaseCollectionConstants.postCommentsSubCollection;
    await _firebaseFirestore.collection(commentCollection).doc(commentModel.postId).collection(postCommentCollection).add(
          commentModel.toDocuments(),
        );
  }

  @override
  Stream<List<Future<PostModel>>> getUserPosts({@required String userId}) {
    final userCollection = FirebaseCollectionConstants.userCollection;
    final postCollection = FirebaseCollectionConstants.postCollection;
    final authorRef = _firebaseFirestore.collection(userCollection).doc(userId);
    return _firebaseFirestore.collection(postCollection).where('author', isEqualTo: authorRef).orderBy("dateTime", descending: true).snapshots().map(
          (querySnap) => querySnap.docs
              .map(
                (queryDocSnap) => PostModel.fromDocument(queryDocSnap),
              )
              .toList(),
        );
  }

  @override
  Stream<List<Future<CommentModel>>> getPostComment({@required String postId}) {
    final commentCollection = FirebaseCollectionConstants.commentCollection;
    final postCommentsSubCollection = FirebaseCollectionConstants.postCommentsSubCollection;
    return _firebaseFirestore.collection(commentCollection).doc(postId).collection(postCommentsSubCollection).orderBy("dateTime", descending: false).snapshots().map(
          (querySnap) => querySnap.docs
              .map(
                (queryDoc) => CommentModel.fromDocument(
                  queryDoc,
                ),
              )
              .toList(),
        );
  }
}
