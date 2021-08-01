import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_insta_clone/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/repositories/post/post_repository.dart';
import 'package:meta/meta.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  FeedBloc({@required PostRepository postRepository, @required AuthBloc authBloc})
      : _postRepository = postRepository,
        _authBloc = authBloc,
        super(
          FeedState.initial(),
        );

  @override
  Stream<FeedState> mapEventToState(
    FeedEvent event,
  ) async* {
    if (event is FeedFetchPostsEvent) {
      yield* mapFetchFeedEventToState(event);
    } else if (event is FeedPaginatePostsEvent) {
      yield* mapPaginatingFeedEventToState(event);
    }
  }

  Stream<FeedState> mapFetchFeedEventToState(FeedFetchPostsEvent event) async* {
    yield (state.copyWith(postList: [], status: FeedStatus.loading));
    try {
      final postList = await _postRepository.getUserFeed(userId: _authBloc.state.user.uid);
      emit(state.copyWith(postList: postList, status: FeedStatus.loaded));
    } on FirebaseException catch (e) {
      print("Firebase Error: ${e.message}");
      yield (state.copyWith(failure: Failure(message: e.message), status: FeedStatus.error));
    } catch (e) {
      yield (state.copyWith(failure: Failure(message: "unable to fetch feeds"), status: FeedStatus.error));
      print("Something Unknown Error: $e");
    }
  }

  Stream<FeedState> mapPaginatingFeedEventToState(FeedPaginatePostsEvent event) async* {
    yield (state.copyWith(status: FeedStatus.paginating));
    try {
      final lastPostId = state.postList.isNotEmpty ? state.postList.last.id : null;
      final postListPaginated = await _postRepository.getUserFeed(userId: _authBloc.state.user.uid, lastPostId: lastPostId);
      //now updated post = our old fetched post + recently fetched post with pagination;
      final updatedPostList = List<PostModel>.from(state.postList)..addAll(postListPaginated);
      emit(state.copyWith(postList: updatedPostList, status: FeedStatus.loaded));
    } on FirebaseException catch (e) {
      print("Firebase Error: ${e.message}");
      yield (state.copyWith(failure: Failure(message: e.message), status: FeedStatus.error));
    } catch (e) {
      print("Something Unknown Error: $e");
      yield (state.copyWith(failure: Failure(message: "unable to fetch feeds"), status: FeedStatus.error));
      print("Something Unknown Error: $e");
    }
  }
}
