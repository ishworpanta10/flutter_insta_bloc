import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/screens/screens.dart';

//Custom Route Setting
class CustomRoute {
  static Route onGenerateRoute(RouteSettings settings) {
    print(settings.name);

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: RouteSettings(name: '/'),
          builder: (_) => InitialRoutePage(),
        );

      // case InitialRoutePage.routeName:
      //   return InitialRoutePage.route();

      case HomePage.routeName:
        return HomePage.route();

      case SplashScreen.routeName:
        return SplashScreen.route();

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