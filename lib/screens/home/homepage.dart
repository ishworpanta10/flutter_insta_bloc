import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/repositories/auth/auth_repo.dart';

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
          child: Column(
            children: [
              Center(
                child: Text("Template Page test 1"),
              ),
              ElevatedButton(
                onPressed: () {
                  RepositoryProvider.of<AuthRepo>(context).logOut();
                },
                child: Text("LogOut"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
