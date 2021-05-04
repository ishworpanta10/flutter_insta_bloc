part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, failure }

class ProfileState extends Equatable {
  final UserModel userModel;
  // final List<Post>posts;
  final bool isCurrentUser;
  final bool isGridView;
  final bool isFollowing;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState({
    @required this.userModel,
    @required this.isCurrentUser,
    @required this.isGridView,
    @required this.isFollowing,
    @required this.status,
    @required this.failure,
  });

  @override
  List<Object> get props => [userModel, isCurrentUser, isGridView, isFollowing, status, failure];

  factory ProfileState.initial() {
    return const ProfileState(
      userModel: UserModel.empty,
      isFollowing: false,
      isCurrentUser: false,
      isGridView: true,
      status: ProfileStatus.initial,
      failure: const Failure(),
    );
  }

  ProfileState copyWith({
    UserModel userModel,
    bool isCurrentUser,
    bool isGridView,
    bool isFollowing,
    ProfileStatus status,
    Failure failure,
  }) {
    return ProfileState(
      userModel: userModel ?? this.userModel,
      isGridView: isGridView ?? this.isGridView,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isFollowing: isFollowing ?? this.isFollowing,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
