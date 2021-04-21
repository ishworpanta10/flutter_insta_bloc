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
    final EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 20.0);
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: SafeArea(
        child: Container(
          padding: defaultPadding,
          child: Center(
            child: Text("Template Page test 1"),
          ),
        ),
      ),
    );
  }
}
