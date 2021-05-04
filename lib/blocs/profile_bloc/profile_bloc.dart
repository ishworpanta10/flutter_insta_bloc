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

  /// we are using user repo and auth repo to compare currently login user and profile reviewing
  /// if both match we confirm we are looking to own profile

  ProfileBloc({@required UserRepo userRepo, @required AuthBloc authBloc})
      : _authBloc = authBloc,
        _userRepo = userRepo,
        super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadEvent) {
      yield* _mapProfileLoadEventToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadEventToState(ProfileLoadEvent event) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    try {
      final user = await _userRepo.getUserWithId(userId: event.userId);
      final currentUserId = await _authBloc.state.user.uid;
      final isCurrentUser = currentUserId == event.userId;

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
      print("Something Unknown Error: ${e}");
      yield state.copyWith(
        status: ProfileStatus.failure,
        failure: const Failure(message: "Unable to load this profile"),
      );
    }
  }
}
