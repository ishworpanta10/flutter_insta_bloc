part of 'bottom_nav_toggle_cubit.dart';

class BottomNavToggleState extends Equatable {
  final BottomNavItem selectedItem;
  const BottomNavToggleState({@required this.selectedItem});

  @override
  List<Object> get props => [selectedItem];
}
