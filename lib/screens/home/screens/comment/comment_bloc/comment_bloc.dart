import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_insta_clone/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_insta_clone/models/comment_model.dart';
import 'package:flutter_insta_clone/models/failure_model.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/repositories/post/post_repository.dart';
import 'package:meta/meta.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  CommentBloc({@required PostRepository postRepository, @required AuthBloc authBloc})
      : _postRepository = postRepository,
        _authBloc = authBloc,
        super(
          CommentState.initial(),
        );

  StreamSubscription<List<Future<CommentModel>>> _commentSubscription;

  @override
  Future<void> close() {
    _commentSubscription.cancel();
    return super.close();
  }

  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    if (event is FetchCommentEvent) {
      yield* _mapFetchCommentEventToState(event);
    } else if (event is UpdateCommentsEvent) {
      yield* _mapUpdateCommentsEventToState(event);
    } else if (event is PostCommentsEvent) {
      yield* _mapPostCommentsEventToState(event);
    }
  }

  Stream<CommentState> _mapFetchCommentEventToState(FetchCommentEvent event) async* {
    yield state.copyWith(status: CommentStatus.loading);
    try {
      _commentSubscription?.cancel();
      _commentSubscription = _postRepository.getPostComment(postId: event.postModel.id).listen(
        (comments) async {
          final allComments = await Future.wait(comments);
          add(UpdateCommentsEvent(commentList: allComments));
        },
      );

      yield state.copyWith(postModel: event.postModel, status: CommentStatus.loaded);
    } on FirebaseException catch (e) {
      yield state.copyWith(
        status: CommentStatus.error,
        failure: Failure(message: e.message),
      );
      print("Firebase Error: ${e.message}");
    } catch (e) {
      yield state.copyWith(
        status: CommentStatus.error,
        failure: const Failure(message: "We were unable to load this post's comments"),
      );
      print("Something Unknown Error: $e");
    }
  }

  Stream<CommentState> _mapUpdateCommentsEventToState(UpdateCommentsEvent event) async* {
    yield state.copyWith(status: CommentStatus.loading);
    try {
      yield state.copyWith(commentList: event.commentList);
    } on FirebaseException catch (e) {
      yield state.copyWith(
        status: CommentStatus.error,
        failure: Failure(message: e.message),
      );
      print("Firebase Error: ${e.message}");
    } catch (e) {
      yield state.copyWith(
        status: CommentStatus.error,
        failure: const Failure(message: 'cannot update comments! try again'),
      );
      print("Something Unknown Error: $e");
    }
  }

  Stream<CommentState> _mapPostCommentsEventToState(PostCommentsEvent event) async* {
    yield state.copyWith(status: CommentStatus.submitting);
    try {
      final authorId = UserModel.empty.copyWith(id: _authBloc.state.user.uid);
      final comment = CommentModel(
        postId: state.postModel.id,
        content: event.content,
        author: authorId,
        dateTime: DateTime.now(),
      );
      await _postRepository.createComment(commentModel: comment);
      yield state.copyWith(
        status: CommentStatus.loaded,
      );
    } on FirebaseException catch (e) {
      yield state.copyWith(
        status: CommentStatus.error,
        failure: Failure(message: e.message),
      );
      print("Firebase Error: ${e.message}");
    } catch (e) {
      yield state.copyWith(
        status: CommentStatus.error,
        failure: const Failure(message: 'cannot post comment! try again'),
      );
      print("Something Unknown Error: $e");
    }
  }
}
