import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/repositories/repositories.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserRepo _userRepo;
  SearchCubit({@required UserRepo userRepo})
      : _userRepo = userRepo,
        super(SearchState.initial());

  void searchUser({@required String query}) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final userList = await _userRepo.searchUsers(query: query);
      emit(
        state.copyWith(userList: userList, status: SearchStatus.loaded),
      );
    } catch (err) {
      print("Error during search ${err.toString()}");
      emit(state.copyWith(status: SearchStatus.error, failure: Failure(message: "something went wrong, please try again.")));
    }
  }

  void clearSearch() {
    emit(state.copyWith(userList: [], status: SearchStatus.initial));
    // emit(SearchState.initial());
  }
}
