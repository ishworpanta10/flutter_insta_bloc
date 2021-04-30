import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/cubit/bottom_nav_toggle_cubit/bottom_nav_toggle_cubit.dart';
import 'package:flutter_insta_clone/enums/navbar_items.dart';
import 'package:flutter_insta_clone/screens/home/navbar/bottom_nav_bar.dart';
import 'package:flutter_insta_clone/screens/home/navbar/tab_navigator.dart';

class NavBar extends StatelessWidget {
  static const String routeName = "/navbar";

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<BottomNavToggleCubit>(
        // create: (context) => BottomNavBloc(),
        create: (context) => BottomNavToggleCubit(),
        child: NavBar(),
      ),
    );
  }

  // 1. creating map with NavItems and  navigation keys which helps us to reference the navigation keys
  //for each of our bottom nav items
  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
    BottomNavItem.search: GlobalKey<NavigatorState>(),
    BottomNavItem.create: GlobalKey<NavigatorState>(),
    BottomNavItem.notification: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, IconData> items = {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search,
    BottomNavItem.create: Icons.add,
    BottomNavItem.notification: Icons.favorite_border,
    BottomNavItem.profile: Icons.account_circle,
  };

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<BottomNavBloc, BottomNavItem>(
    return BlocBuilder<BottomNavToggleCubit, BottomNavToggleState>(
      builder: (context, state) {
        return Scaffold(
          //2. Building stack for navigation
          body: Stack(
            children: items
                .map(
                  (item, _) => MapEntry(
                    item,
                    _buildOffstageNavigator(
                      item,
                      item == state.selectedItem,
                    ),
                  ),
                )
                .values
                .toList(),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            items: items,
            onTap: (index) {
              //with cubit
              final selectedItem = BottomNavItem.values[index];

              //3. selecting the current updated tab
              _selecteBottomNavItem(context, selectedItem, selectedItem == state.selectedItem);
              //with bloc
              // BlocProvider.of<BottomNavBloc>(context).add(index);
            },
            selectedItem: state.selectedItem,
            // selectedIndex: state.index,
          ),
          // body: _buildBody(state),
        );
      },
    );
  }

  void _selecteBottomNavItem(BuildContext context, BottomNavItem selectedItem, bool isSameItem) {
    if (isSameItem) {
      //pop the screen to first of stack of same bottom nav tab
      navigatorKeys[selectedItem].currentState.popUntil((route) => route.isFirst);
    }
    context.read<BottomNavToggleCubit>().updateSelectedItem(selectedItem);
  }

  Widget _buildOffstageNavigator(BottomNavItem currentItem, bool isSelecetd) {
    return Offstage(
      offstage: !isSelecetd,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem],
        item: currentItem,
      ),
    );
  }
}
