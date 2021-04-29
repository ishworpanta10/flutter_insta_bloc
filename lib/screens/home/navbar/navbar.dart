import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/blocs/bottom_nav_bar_change_bloc/bottom_nav_bar_change_bloc.dart';
import 'package:flutter_insta_clone/enums/navbar_items.dart';
import 'package:flutter_insta_clone/screens/home/navbar/bottom_nav_bar.dart';

class NavBar extends StatelessWidget {
  static const String routeName = "/navbar";

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (context) => BottomNavBloc(),
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
    return BlocBuilder<BottomNavBloc, BottomNavItem>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: CustomBottomNavBar(
            items: items,
            onTap: (index) {
              BlocProvider.of<BottomNavBloc>(context).add(index);
            },
            selectedItem: state,
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(BottomNavItem state) {
    if (state == BottomNavItem.feed) {
      return Container(
        color: Colors.green,
        child: Center(
          child: Text("Feed"),
        ),
      );
    } else if (state == BottomNavItem.search) {
      return Container(
        color: Colors.yellow,
        child: Center(
          child: Text("Search"),
        ),
      );
    } else if (state == BottomNavItem.create) {
      return Container(
        color: Colors.lightGreen,
        child: Center(
          child: Text("Create"),
        ),
      );
    } else if (state == BottomNavItem.notification) {
      return Container(
        color: Colors.lightBlue,
        child: Center(
          child: Text("Notification"),
        ),
      );
    } else if (state == BottomNavItem.profile) {
      return Container(
        color: Colors.grey,
        child: Center(
          child: Text("Profile"),
        ),
      );
    }
    return Container();
  }
}
