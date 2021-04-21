import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_insta_clone/blocs/simple_bloc_observer.dart';
import 'package:flutter_insta_clone/config/custom_router.dart';
import 'package:flutter_insta_clone/repositories/auth/auth_repo.dart';
import 'package:flutter_insta_clone/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepo(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepo: context.read<AuthRepo>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Instagram Clone',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[50],
            appBarTheme: AppBarTheme(
              brightness: Brightness.light,
              color: Colors.white,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              textTheme: const TextTheme(
                headline6: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: CustomRoute.onGenerateRoute,
          // initialRoute: "/",
          initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}
