import 'package:flutter_bloc/flutter_bloc.dart';

class GenderChangeBloc extends Bloc<int, String> {
  GenderChangeBloc() : super("");

  @override
  Stream<String> mapEventToState(int event) async* {
    if (event == -1) {
      yield "";
    }
  }
}
