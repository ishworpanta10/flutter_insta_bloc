import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_insta_clone/models/failure_model.dart';
import 'package:flutter_insta_clone/repositories/auth/auth_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepo _authRepo;
  SignupCubit({@required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(SignupState.initial());

  void usernameChanged(String username) {
    emit(state.copyWith(
      username: username,
      status: SignupStatus.initial,
    ));
  }

  void emailChanged(String email) {
    emit(state.copyWith(
      email: email,
      status: SignupStatus.initial,
    ));
  }

  void passwordChanged(String password) {
    emit(
      state.copyWith(
        password: password,
        status: SignupStatus.initial,
      ),
    );
  }

  void signUpWithEmailAndPassword() async {
    if (!state.isFormValid || state.status == SignupStatus.loading) return;
    emit(state.copyWith(status: SignupStatus.loading));
    try {
      await _authRepo.signUpWithEmailAndPassword(
        username: state.username,
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(
        status: SignupStatus.success,
      ));
    } on Failure catch (err) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          failure: Failure(code: err.code, message: err.message),
        ),
      );
    }
  }
}
