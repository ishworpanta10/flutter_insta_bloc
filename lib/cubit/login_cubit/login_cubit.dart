import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/models/failure_model.dart';
import 'package:flutter_insta_clone/repositories/auth/auth_repo.dart';

part 'login_state.dart';

/// from tutorial
class LoginCubit extends Cubit<LoginState> {
  final AuthRepo _authRepo;
  LoginCubit({@required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(LoginState.initial());

  void emailChanged(String email) {
    emit(state.copyWith(
      email: email,
      status: LoginStatus.initial,
    ));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: password,
      status: LoginStatus.initial,
    ));
  }

  void loginWithCredential() async {
    //making sure our login with cred not fired when our status is currently submitting
    //and validate form
    if (state.status == LoginStatus.progress || !state.isFormValid) return;
    //initially loading state
    emit(state.copyWith(status: LoginStatus.progress));
    try {
      await _authRepo.logInWithEmailAndPassword(email: state.email, password: state.password);
      //emitting success state
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      //emitting failure state
      emit(state.copyWith(
        status: LoginStatus.error,
        failure: err,
      ));
    }
  }
}
