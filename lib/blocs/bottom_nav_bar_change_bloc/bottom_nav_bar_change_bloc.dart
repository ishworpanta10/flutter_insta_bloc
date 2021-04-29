import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/enums/navbar_items.dart';

class BottomNavBloc extends Bloc<int, BottomNavItem> {
  BottomNavBloc() : super(BottomNavItem.feed);

  @override
  Stream<BottomNavItem> mapEventToState(int event) async* {
    if (event == 0) {
      yield BottomNavItem.feed;
    } else if (event == 1) {
      yield BottomNavItem.search;
    } else if (event == 2) {
      yield BottomNavItem.create;
    } else if (event == 3) {
      yield BottomNavItem.notification;
    } else if (event == 4) {
      yield BottomNavItem.profile;
    }
  }
}
