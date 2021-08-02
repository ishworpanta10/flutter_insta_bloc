import 'package:flutter_insta_clone/models/models.dart';

abstract class BasePostRepo {
  Future<void> createPost({PostModel postModel});
  Future<void> createComment({PostModel postModel, CommentModel commentModel});
  void createLike({PostModel postModel, String userId});

  Stream<List<Future<PostModel>>> getUserPosts({String userId});
  Stream<List<Future<CommentModel>>> getPostComment({String postId});

  Future<List<PostModel>> getUserFeed({String userId, String lastPostId});
  Future<Set<String>> getLikedPostIds({String userId, List<PostModel> postModel});
  void deleteLike({String postId, String userId});
}
