import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_insta_clone/repositories/auth/auth_repo.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;
  StreamSubscription<auth.User> _userSubscription;

  AuthBloc({@required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(AuthUnknownState()) {
    //for listening continues change of user
    _userSubscription = _authRepo.user.listen(
      (user) => add(
        AuthUserChangedEvent(user: user),
      ),
    );
  }

  @override
  Future<void> close() {
    //if userSubscription is null we does not end calling cancel on null so used ?.
    _userSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthUserChangedEvent) {
      yield* _mapAuthUserChangeToState(event);
    } else if (event is AuthLogOutRequestedEvent) {
      await _authRepo.logOut();
    }
  }

  Stream<AuthState> _mapAuthUserChangeToState(AuthUserChangedEvent event) async* {
    yield event.user != null
        ? AuthAuthenticatedState(
            user: event.user,
          )
        : AuthUnauthenticatedState(
            status: AuthStatus.unauthenticated,
          );
    // if (event is AuthAuthenticatedState) {
    //   yield AuthLoadingState();
    //   try {
    //     event.user != null
    //         ? AuthAuthenticatedState(user: event.user)
    //         : AuthUnauthenticatedState(
    //             status: AuthStatus.authenticated,
    //           );
    //   } catch (err) {
    //     print("error");
    //   }
    // }
  }
}
