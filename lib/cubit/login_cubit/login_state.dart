part of 'login_cubit.dart';

// abstract class LoginState extends Equatable {
//   @override
//   List<Object> get props => [];
// }
//
// class LoginInitialState extends LoginState {}
//
// class LoginProgressState extends LoginState {}
//
// class LoginSuccessState extends LoginState {
//   final String username;
//   final String password;
//
//   LoginSuccessState({@required this.username, @required this.password});
//
//   @override
//   List<Object> get props => [username, password];
// }
//
// class LoginFailureState extends LoginState {
//   final Failure failure;
//
//   LoginFailureState({@required this.failure});
//
//   @override
//   List<Object> get props => [failure];
// }

/// from tutorial
enum LoginStatus { initial, progress, success, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final Failure failure;

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  const LoginState({
    @required this.email,
    @required this.password,
    @required this.status,
    @required this.failure,
  });

  factory LoginState.initial() {
    return LoginState(
      email: "",
      password: "",
      status: LoginStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [email, password, status, failure];

  //copy with method allow us to modify the login state as required
  LoginState copyWith({
    String email,
    String password,
    LoginStatus status,
    Failure failure,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
