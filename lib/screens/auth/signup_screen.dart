import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 20.0);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
      ),
      body: SafeArea(
        child: Container(
          padding: defaultPadding,
          child: Center(
            child: Text("SignUp Page"),
          ),
        ),
      ),
    );
  }
}
