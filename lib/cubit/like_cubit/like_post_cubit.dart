import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_insta_clone/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/repositories/post/post_repository.dart';

part 'like_post_state.dart';

class LikePostCubit extends Cubit<LikePostState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  LikePostCubit({@required PostRepository postRepository, @required AuthBloc authBloc})
      : _postRepository = postRepository,
        _authBloc = authBloc,
        super(LikePostState.initial());

  //we can use this method to fetch initial like post while loading initial feed
  void updateLikedPosts({@required Set<String> postIds}) {
    emit(state.copyWith(
      likedPostIds: Set<String>.from(state.likedPostIds)..addAll(postIds),
    ));
  }

  void likePost({@required PostModel postModel}) {
    _postRepository.createLike(postModel: postModel, userId: _authBloc.state.user.uid);
    emit(state.copyWith(
      likedPostIds: Set<String>.from(state.likedPostIds)..add(postModel.id),
      recentlyLikedPostsIds: Set<String>.from(state.recentlyLikedPostsIds)..add(postModel.id),
    ));
  }

  void unLikePost({@required PostModel postModel}) {
    _postRepository.deleteLike(postId: postModel.id, userId: _authBloc.state.user.uid);
    emit(state.copyWith(
      likedPostIds: Set<String>.from(state.likedPostIds)..remove(postModel.id),
      recentlyLikedPostsIds: Set<String>.from(state.recentlyLikedPostsIds)..remove(postModel.id),
    ));
  }

  void clearAllLikedPost() {
    emit(LikePostState.initial());
  }
}
