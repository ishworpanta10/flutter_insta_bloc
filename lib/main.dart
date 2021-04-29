import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/blocs/basic_ui_bloc/basic_ui_blocs_export.dart';
import 'package:flutter_insta_clone/blocs/simple_bloc_observer.dart';
import 'package:flutter_insta_clone/config/custom_router.dart';
import 'package:flutter_insta_clone/repositories/auth/auth_repo.dart';
import 'package:flutter_insta_clone/screens/screens.dart';

import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/basic_ui_bloc/password_change_bloc.dart';

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
          BlocProvider(
            create: (context) => LanguageChangingBloc(),
          ),
          BlocProvider(
            create: (context) => UserNameChangeBloc(),
          ),
          BlocProvider(
            create: (context) => EmailChangeBloc(),
          ),
          BlocProvider(
            create: (context) => PasswordChangeBloc(),
          ),
          BlocProvider(
            create: (context) => PasswordShowHideToggleBtn(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Instagram Clone',
          debugShowCheckedModeBanner: false,
          builder: BotToastInit(), //1. call BotToastInit
          navigatorObservers: [
            BotToastNavigatorObserver(),
          ],
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,

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
