import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_insta_clone/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/repositories/repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepo _userRepo;
  final AuthBloc _authBloc;
  //for posts
  final PostRepository _postRepository;
  StreamSubscription<List<Future<PostModel>>> _postsSubscription;

  /// we are using user repo and auth repo to compare currently login user and profile reviewing
  /// if both match we confirm we are looking to own profile

  ProfileBloc({@required UserRepo userRepo, @required AuthBloc authBloc, @required PostRepository postRepository})
      : _authBloc = authBloc,
        _userRepo = userRepo,
        _postRepository = postRepository,
        super(ProfileState.initial());

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadEvent) {
      yield* _mapProfileLoadEventToState(event);
    } else if (event is ProfileToggleGridViewEvent) {
      yield* _mapProfileToggleGridViewEventToState(event);
    } else if (event is ProfileUpdatePostsEvent) {
      yield* _mapProfileUpdatePostsEventToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadEventToState(ProfileLoadEvent event) async* {
    if (state.status == ProfileStatus.loaded) {
      yield state.copyWith(status: ProfileStatus.loaded);
    } else {
      yield state.copyWith(status: ProfileStatus.loading);
    }

    try {
      final user = await _userRepo.getUserWithId(userId: event.userId);
      final currentUserId = _authBloc.state.user.uid;
      // ProfileLoadEvent is Fired from tab navigator with auth_uid
      //ans return userId to event
      final isCurrentUser = currentUserId == event.userId;
      // for posts
      _postsSubscription?.cancel();
      _postsSubscription = _postRepository.getUserPosts(userId: event.userId).listen((futurePostList) async {
        final allPosts = await Future.wait(futurePostList);
        add(
          ProfileUpdatePostsEvent(postList: allPosts),
        );
      });
      yield state.copyWith(
        userModel: user,
        isCurrentUser: isCurrentUser,
        status: ProfileStatus.loaded,
      );
    } on FirebaseException catch (e) {
      print("Firebase Error: ${e.message}");
      yield state.copyWith(
        status: ProfileStatus.failure,
        failure: const Failure(message: "Unable to load this profile"),
      );
    } catch (e) {
      print("Something Unknown Error: $e");
      yield state.copyWith(
        status: ProfileStatus.failure,
        failure: const Failure(message: "Unable to load this profile"),
      );
    }
  }

  Stream<ProfileState> _mapProfileToggleGridViewEventToState(ProfileToggleGridViewEvent event) async* {
    yield state.copyWith(isGridView: event.isGridView);
  }

  Stream<ProfileState> _mapProfileUpdatePostsEventToState(ProfileUpdatePostsEvent event) async* {
    yield state.copyWith(posts: event.postList);
  }
}
