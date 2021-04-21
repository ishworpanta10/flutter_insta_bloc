part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

// class AuthState extends Equatable {
//   final auth.User user;
//   final AuthStatus status;
//
//   const AuthState({this.user, this.status = AuthStatus.unknown});
//
//   factory AuthState.unknown() => const AuthState();
//
//   factory AuthState.authenticated({@required auth.User user}) {
//     return AuthState(user: user, status: AuthStatus.authenticated);
//   }
//
//   factory AuthState.unauthenticated() => const AuthState(
//         status: AuthStatus.unauthenticated,
//       );
//
//   @override
//   bool get stringify => true;
//
//   @override
//   List<Object> get props => [user, status];
// }

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthLoadingState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final auth.User user;

  AuthAuthenticatedState({@required this.user});

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticatedState extends AuthState {
  final AuthStatus status;

  AuthUnauthenticatedState({this.status = AuthStatus.unauthenticated});

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [status];
}

class AuthUnknownState extends AuthState {}
