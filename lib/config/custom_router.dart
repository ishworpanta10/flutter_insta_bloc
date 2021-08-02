import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/screens/home/screens/nav/navbar.dart';
import 'package:flutter_insta_clone/screens/home/screens/profile/edit_profile.dart';
import 'package:flutter_insta_clone/screens/home/screens/profile/profile_screen.dart';
import 'package:flutter_insta_clone/screens/home/screens/screens.dart';
import 'package:flutter_insta_clone/screens/screens.dart';

//Custom Route Setting
class CustomRoute {
  static Route onGenerateRoute(RouteSettings settings) {
    print(" Route : ${settings.name}");
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: RouteSettings(name: '/'),
          builder: (_) => InitialRoutePage(),
        );

      // case InitialRoutePage.routeName:
      //   return InitialRoutePage.route();

      case SplashScreen.routeName:
        return SplashScreen.route();

      case LoginScreen.routeName:
        return LoginScreen.route();

      case SignUpScreen.routeName:
        return SignUpScreen.route();

      case NavBar.routeName:
        return NavBar.route();

      case HomePage.routeName:
        return HomePage.route();

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    print("Nested Route : ${settings.name} ");

    switch (settings.name) {
      case EditProfile.routeName:
        return EditProfile.route(args: settings.arguments);

      case ProfileScreen.routeName:
        return ProfileScreen.route(args: settings.arguments);

      case CommentScreen.routeName:
        return CommentScreen.route(args: settings.arguments);

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: RouteSettings(name: '/error'),
      builder: (_) => ErrorRoutePage(),
    );
  }
}

//Initial Route Page
class InitialRoutePage extends StatelessWidget {
  //for routing
  // static const String routeName = "/";
  //
  // static Route route() {
  //   return MaterialPageRoute(
  //     settings: RouteSettings(name: InitialRoutePage.routeName),
  //     builder: (_) => InitialRoutePage(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Initial Route',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

//For Error Route Page
class ErrorRoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Error Route',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
