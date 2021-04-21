import 'package:flutter/material.dart';

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
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
