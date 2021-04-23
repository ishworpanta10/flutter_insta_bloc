import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/screens/auth/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = "/signup";

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => SignUpScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 20.0);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: defaultPadding,
          child: Center(
            child: Text("SignUp Page"),
          ),
        ),
      ),
      bottomSheet: _buildBottomSheetText(context),
    );
  }

  Widget _buildBottomSheetText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, LoginScreen.routeName);
      },
      child: Material(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 15.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.caption,
                  children: [
                    TextSpan(
                      text: "Log in.",
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontSize: 14.0,
                            color: Colors.blue.withOpacity(
                              0.8,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
