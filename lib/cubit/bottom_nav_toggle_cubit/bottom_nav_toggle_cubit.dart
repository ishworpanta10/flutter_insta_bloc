import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/enums/navbar_items.dart';

part 'bottom_nav_toggle_state.dart';

class BottomNavToggleCubit extends Cubit<BottomNavToggleState> {
  BottomNavToggleCubit()
      : super(
          BottomNavToggleState(
            selectedItem: BottomNavItem.feed,
          ),
        );

  void updateSelectedItem(BottomNavItem item) {
    if (item != state.selectedItem) {
      emit(BottomNavToggleState(selectedItem: item));
    }
  }
}
