import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/cubit/bottom_nav_toggle_cubit/bottom_nav_toggle_cubit.dart';
import 'package:flutter_insta_clone/enums/navbar_items.dart';
import 'package:flutter_insta_clone/screens/home/navbar/bottom_nav_bar.dart';

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
          bottomNavigationBar: CustomBottomNavBar(
            items: items,
            onTap: (index) {
              //with cubit
              final selectedItem = BottomNavItem.values[index];
              context.read<BottomNavToggleCubit>().updateSelectedItem(selectedItem);

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
}
