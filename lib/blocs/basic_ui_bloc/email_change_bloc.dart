import 'package:flutter_bloc/flutter_bloc.dart';

class EmailChangeBloc extends Bloc<String, bool> {
  EmailChangeBloc() : super(false);

  @override
  Stream<bool> mapEventToState(String event) async* {
    if (event == null) {
      yield false;
    } else {
      if (event.isEmpty) {
        yield false;
      } else {
        yield true;
      }
    }
  }
}

class PasswordChangeBloc extends Bloc<String, bool> {
  PasswordChangeBloc() : super(false);

  @override
  Stream<bool> mapEventToState(String event) async* {
    if (event == null) {
      yield false;
    } else {
      if (event.isEmpty) {
        yield false;
      } else {
        yield true;
      }
    }
  }
}

class UserNameChangeBloc extends Bloc<String, bool> {
  UserNameChangeBloc() : super(false);

  @override
  Stream<bool> mapEventToState(String event) async* {
    if (event == null) {
      yield false;
    } else if (event.isEmpty) {
      yield false;
    } else {
      yield true;
    }
  }
}
