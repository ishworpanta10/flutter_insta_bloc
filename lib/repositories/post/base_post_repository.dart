import 'package:flutter_insta_clone/models/models.dart';

abstract class BasePostRepo {
  Future<void> createPost({PostModel postModel});
  Future<void> createComment({CommentModel commentModel});

  Stream<List<Future<PostModel>>> getUserPosts({String userId});
  Stream<List<Future<CommentModel>>> getPostComment({String postId});

  Future<List<PostModel>> getUserFeed({String userId, String lastPostId});
}
