part of 'like_post_cubit.dart';

class LikePostState extends Equatable {
  final Set<String> likedPostIds;
  final Set<String> recentlyLikedPostsIds;

  const LikePostState({@required this.likedPostIds, @required this.recentlyLikedPostsIds});

  factory LikePostState.initial() {
    return LikePostState(
      likedPostIds: {},
      recentlyLikedPostsIds: {},
    );
  }

  LikePostState copyWith({
    Set<String> likedPostIds,
    Set<String> recentlyLikedPostsIds,
  }) {
    return new LikePostState(
      likedPostIds: likedPostIds ?? this.likedPostIds,
      recentlyLikedPostsIds: recentlyLikedPostsIds ?? this.recentlyLikedPostsIds,
    );
  }

  @override
  List<Object> get props => [likedPostIds, recentlyLikedPostsIds];
}
