part of 'feed_bloc.dart';

enum FeedStatus { initial, loading, loaded, paginating, error }

class FeedState extends Equatable {
  final List<PostModel> postList;
  final FeedStatus status;
  final Failure failure;

  factory FeedState.initial() {
    return const FeedState(postList: [], status: FeedStatus.initial, failure: Failure());
  }

  FeedState copyWith({
    List<PostModel> postList,
    FeedStatus status,
    Failure failure,
  }) {
    return new FeedState(
      postList: postList ?? this.postList,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  const FeedState({
    @required this.postList,
    @required this.status,
    @required this.failure,
  });

  @override
  List<Object> get props => [postList, status, failure];
}
