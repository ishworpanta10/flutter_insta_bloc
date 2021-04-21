part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [];
}

class AuthUserChangedEvent extends AuthEvent {
  final auth.User user;

  const AuthUserChangedEvent({this.user});

  @override
  List<Object> get props => [user];
}

class AuthLogOutRequestedEvent extends AuthEvent {}
