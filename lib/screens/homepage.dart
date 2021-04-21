import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  //for routing
  static const String routeName = "/home";

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: HomePage.routeName),
      builder: (_) => HomePage(),
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
