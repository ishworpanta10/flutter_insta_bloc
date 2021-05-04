import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_insta_clone/screens/auth/login_screen.dart';
import 'package:flutter_insta_clone/screens/home/navbar/navbar.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: SplashScreen.routeName),
      builder: (_) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //forcing not to get back from splash screen in route stack
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // print(state);
          if (state.status == AuthStatus.authenticated) {
            /// go to home screen
            // print("Authenticated");
            Navigator.of(context).pushNamed(NavBar.routeName);
          } else if (state.status == AuthStatus.unauthenticated) {
            /// go to login screen
            // print("UnAuthenticated");
            Navigator.pushNamed(context, LoginScreen.routeName);
          }
        },
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
