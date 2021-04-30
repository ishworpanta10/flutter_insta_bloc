import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/enums/navbar_items.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Map<BottomNavItem, IconData> items;
  final BottomNavItem selectedItem;
  final Function(int) onTap;
  // final int selectedIndex;

  const CustomBottomNavBar({
    @required this.items,
    @required this.selectedItem,
    @required this.onTap,
    // @required this.selectedIndex,
  });
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: onTap,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: BottomNavItem.values.indexOf(selectedItem),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        // currentIndex: selectedIndex,
        items: items
            .map((item, icon) {
              return MapEntry(
                item,
                BottomNavigationBarItem(
                  icon: Icon(icon, size: 30.0),
                  label: item.toString(),
                  tooltip: item.toString(),
                ),
              );
            })
            .values
            .toList());
  }
}
