import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  //for routing
  static const String routeName = "/home";

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Text("HomePage"),
        ),
      ),
    );
  }
}
