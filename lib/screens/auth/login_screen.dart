import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/assets/assets.dart';
import 'package:flutter_insta_clone/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_insta_clone/blocs/basic_ui_bloc/basic_ui_blocs_export.dart';
import 'package:flutter_insta_clone/blocs/basic_ui_bloc/email_change_bloc.dart';
import 'package:flutter_insta_clone/blocs/basic_ui_bloc/languageChangingBloc.dart';
import 'package:flutter_insta_clone/constants/const_size_boxes.dart';
import 'package:flutter_insta_clone/repositories/auth/auth_repo.dart';
import 'package:flutter_insta_clone/screens/screens.dart';
import 'package:flutter_insta_clone/styles/decorations/custom_decoration.dart';

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

  final List<String> languageList = ["English (United Kingdom) ", "Espanol", "Hindi", "Deutsch"];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LanguageChangingBloc>(context).add(languageList[0]);
    final EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 20.0);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthLoadingState) {
          Center(
            child: CircularProgressIndicator(),
          );
        } else if (authState is AuthUnauthenticatedState) {
          print("unauth");
          BotToast.showText(
            text: "Unauntenticated",
          );
          Navigator.pushNamed(context, LoginScreen.routeName);
        } else if (authState is AuthAuthenticatedState) {
          print("auth");
          BotToast.showText(
            text: "Authenticated Success",
          );
          Navigator.pushNamed(context, HomePage.routeName);
        }
      },
      child: Scaffold(
        // backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Container(
            padding: defaultPadding,
            child: Form(
              key: _formKey,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLanguageDropDownBtn(context),
                  sbH200,
                  _buildInstaImg(),
                  sbH40,
                  _buildFormFields(context),
                  sbH20,
                  _buildLogInBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogInBtn() {
    return BlocBuilder<EmailChangeBloc, bool>(
      builder: (context, emailState) {
        return BlocBuilder<PasswordChangeBloc, bool>(
          builder: (context, passwordState) {
            return FractionallySizedBox(
              widthFactor: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  onSurface: !(emailState && passwordState) ? Colors.blue : null,
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                ),
                // style: ButtonStyle(),
                child: Text(
                  "Log In",
                ),
                onPressed: !(emailState && passwordState)
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          // _formKey.currentState.save();
                          print("Email :" + _usernameTextEditingController.text);
                          print("Password :" + _passwordTextEditingController.text);
                          RepositoryProvider.of<AuthRepo>(context).logInWithEmailAndPassword(
                            email: _usernameTextEditingController.text,
                            password: _passwordTextEditingController.text,
                          );
                        }
                      },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _usernameTextEditingController,
            validator: (value) {
              if (value.isEmpty || value == null || value.length < 3) {
                return "Invalid username/email";
              } else
                return null;
            },
            decoration: customInputDecoration.copyWith(
              hintText: "Phone number, email address or username",
              hintStyle: Theme.of(context).textTheme.caption,
            ),
            onChanged: (email) {
              BlocProvider.of<EmailChangeBloc>(context).add(email);
            },
          ),
          sbH20,
          BlocBuilder<PasswordShowHideToggleBtn, bool>(
            builder: (context, passwordState) {
              return TextFormField(
                controller: _passwordTextEditingController,
                obscureText: passwordState ? true : false,
                validator: (value) {
                  if (value.isEmpty || value == null || value.length < 6) {
                    return "Invalid Password";
                  } else
                    return null;
                },
                decoration: customInputDecoration.copyWith(
                  hintText: "Password",
                  hintStyle: Theme.of(context).textTheme.caption,
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordState ? Icons.visibility_off : Icons.visibility,
                      color: passwordState ? Colors.grey : null,
                    ),
                    onPressed: () {
                      BlocProvider.of<PasswordShowHideToggleBtn>(context).add(!passwordState);
                    },
                  ),
                ),
                onChanged: (password) {
                  BlocProvider.of<PasswordChangeBloc>(context).add(password);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInstaImg() {
    return Center(
      child: Image.asset(
        Assets.instaLogo,
        height: 86.0,
      ),
    );
  }

  Widget _buildLanguageDropDownBtn(BuildContext context) {
    return Center(
      child: BlocBuilder<LanguageChangingBloc, String>(
        builder: (context, currentGender) {
          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              elevation: 0,
              value: currentGender,
              onChanged: (value) {
                BlocProvider.of<LanguageChangingBloc>(context).add(value);
                print("Selected Gender :" + value);
              },
              items: languageList
                  .map<DropdownMenuItem<String>>(
                    (language) => DropdownMenuItem<String>(
                      value: language,
                      child: Text(
                        '$language',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}