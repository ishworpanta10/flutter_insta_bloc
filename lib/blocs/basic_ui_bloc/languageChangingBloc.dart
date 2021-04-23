import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageChangingBloc extends Bloc<String, String> {
  LanguageChangingBloc() : super(null);

  @override
  Stream<String> mapEventToState(String event) async* {
    yield event;
  }
}
