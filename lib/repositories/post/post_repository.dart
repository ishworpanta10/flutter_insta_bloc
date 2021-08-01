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
    final postCollection = FirebaseConstants.post;
    await _firebaseFirestore.collection(postCollection).add(
          postModel.toDocuments(),
        );
  }

  @override
  Future<void> createComment({@required CommentModel commentModel}) async {
    final commentCollection = FirebaseConstants.comment;
    final postCommentCollection = FirebaseConstants.postComments;
    await _firebaseFirestore.collection(commentCollection).doc(commentModel.postId).collection(postCommentCollection).add(
          commentModel.toDocuments(),
        );
  }

  @override
  Stream<List<Future<PostModel>>> getUserPosts({@required String userId}) {
    final userCollection = FirebaseConstants.user;
    final postCollection = FirebaseConstants.post;
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
    final commentCollection = FirebaseConstants.comment;
    final postCommentsSubCollection = FirebaseConstants.postComments;
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

  @override
  Future<List<PostModel>> getUserFeed({@required String userId, String lastPostId}) async {
    final feeds = FirebaseConstants.feeds;
    final userFeed = FirebaseConstants.userFeed;
    //paginating logic
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore.collection(feeds).doc(userId).collection(userFeed).orderBy("dateTime", descending: true).limit(15).get();
    } else {
      final lastPostDoc = await _firebaseFirestore.collection(feeds).doc(userId).collection(userFeed).doc(lastPostId).get();
      if (!lastPostDoc.exists) {
        return [];
      }
      postsSnap = await _firebaseFirestore.collection(feeds).doc(userId).collection(userFeed).orderBy("dateTime", descending: true).startAfterDocument(lastPostDoc).limit(15).get();
    }

    // final postSnap = await _firebaseFirestore.collection(feeds).doc(userId).collection(userFeed).orderBy("dateTime", descending: true).get();
    //here if use does not use future.wait we get only List<Future<PostModel>>
    final futurePostList = Future.wait(postsSnap.docs.map((post) => PostModel.fromDocument(post)).toList());
    return futurePostList;
  }
}
