part of 'comment_bloc.dart';

enum CommentStatus { initial, loading, submitting, loaded, error }

class CommentState extends Equatable {
  final PostModel postModel;
  final List<CommentModel> commentList;
  final CommentStatus status;
  final Failure failure;

  factory CommentState.initial() {
    return const CommentState(
      postModel: null,
      commentList: [],
      status: CommentStatus.initial,
      failure: const Failure(),
    );
  }

  CommentState copyWith({
    PostModel postModel,
    List<CommentModel> commentList,
    CommentStatus status,
    Failure failure,
  }) {
    return CommentState(
      postModel: postModel ?? this.postModel,
      commentList: commentList ?? this.commentList,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  const CommentState({
    @required this.postModel,
    @required this.commentList,
    @required this.status,
    @required this.failure,
  });

  @override
  List<Object> get props => [postModel, commentList, status, failure];
}
