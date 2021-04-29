import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordShowHideToggleBtn extends Bloc<bool, bool> {
  PasswordShowHideToggleBtn() : super(true);

  @override
  Stream<bool> mapEventToState(bool event) async* {
    yield event;
  }
}
