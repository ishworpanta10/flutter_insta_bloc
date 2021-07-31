part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileLoadEvent extends ProfileEvent {
  final String userId;

  ProfileLoadEvent({@required this.userId});
  @override
  List<Object> get props => [userId];
}

class ProfileToggleGridViewEvent extends ProfileEvent {
  final bool isGridView;

  ProfileToggleGridViewEvent({@required this.isGridView});

  @override
  List<Object> get props => [isGridView];
}

class ProfileUpdatePostsEvent extends ProfileEvent {
  final List<PostModel> postList;

  ProfileUpdatePostsEvent({@required this.postList});

  @override
  List<Object> get props => [postList];
}

class ProfileFollowUserEvent extends ProfileEvent {}

class ProfileUnfollowUserEvent extends ProfileEvent {}
