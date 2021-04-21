import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  //for routing
  static const String routeName = "/login";

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 20.0);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
        child: Container(
          padding: defaultPadding,
          child: Center(
            child: Text("Login Page"),
          ),
        ),
      ),
    );
  }
}
