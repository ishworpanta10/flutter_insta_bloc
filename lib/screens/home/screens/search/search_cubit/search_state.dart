part of 'search_cubit.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  final List<UserModel> userList;
  final SearchStatus status;
  final Failure failure;

  SearchState({@required this.userList, @required this.status, @required this.failure});

  factory SearchState.initial() {
    return SearchState(
      userList: [],
      status: SearchStatus.initial,
      failure: const Failure(),
    );
  }

  SearchState copyWith({
    List<UserModel> userList,
    SearchStatus status,
    Failure failure,
  }) {
    return new SearchState(
      userList: userList ?? this.userList,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object> get props => [userList, status, failure];
}
