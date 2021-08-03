import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/blocs/basic_ui_bloc/email_change_bloc.dart';
import 'package:flutter_insta_clone/blocs/basic_ui_bloc/password_change_bloc.dart';
import 'package:flutter_insta_clone/constants/const_size_boxes.dart';
import 'package:flutter_insta_clone/cubit/signup_cubit/signup_cubit.dart';
import 'package:flutter_insta_clone/repositories/auth/auth_repo.dart';
import 'package:flutter_insta_clone/screens/home/screens/nav/navbar.dart';
import 'package:flutter_insta_clone/styles/decorations/custom_decoration.dart';
import 'package:flutter_insta_clone/widgets/error_dialog.dart';
import 'package:flutter_insta_clone/widgets/loading_dialog.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = "/signup";

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (context) => SignupCubit(
          authRepo: context.read<AuthRepo>(),
        ),
        child: SignUpScreen(),
      ),
    );
  }

  _resetAllBloc(BuildContext context) {
    BlocProvider.of<UserNameChangeBloc>(context).add(null);
    BlocProvider.of<EmailChangeBloc>(context).add(null);
    BlocProvider.of<PasswordChangeBloc>(context).add(null);
    BlocProvider.of<PasswordShowHideToggleBtn>(context).add(true);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 20.0);
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, signupState) {
        if (signupState.status == SignupStatus.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return LoadingDialog(
                loadingMessage: "signing up, please wait ....",
              );
            },
          );
          // BotToast.showLoading();
        } else if (signupState.status == SignupStatus.failure) {
          //closing the loading dialog
          Navigator.of(context, rootNavigator: true).pop();
          BotToast.closeAllLoading();
          BotToast.showText(text: "Error Signing up : ${signupState.failure.message}");
          showDialog(
              context: context,
              builder: (context) {
                return ErrorDialog(
                  title: "Error on signing up",
                  message: signupState.failure.message,
                );
              });
        } else if (signupState.status == SignupStatus.success) {
          BotToast.closeAllLoading();
          Navigator.pushReplacementNamed(context, NavBar.routeName);
          BotToast.showText(text: "Signup Success");
        }
        // else if (signupState.status == SignupStatus.initial) {}
      },
      builder: (context, signupState) {
        return Scaffold(
          body: WillPopScope(
            onWillPop: () async {
              return await _resetAllBloc(context);
            },
            child: SafeArea(
              child: Container(
                padding: defaultPadding,
                child: ListView(
                  children: [
                    sbH200,
                    _buildFormFields(context),
                    sbH20,
                    _buildLogInBtn(context, signupState.status == SignupStatus.loading),
                    sbH10,
                  ],
                ),
              ),
            ),
          ),
          bottomSheet: _buildBottomSheetText(context),
        );
      },
    );
  }

  Widget _buildLogInBtn(BuildContext context, bool isSubmitting) {
    return BlocBuilder<UserNameChangeBloc, bool>(
      builder: (context, userNameState) {
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
                        onSurface: !(emailState && passwordState && userNameState) ? Colors.blue : null,
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      // style: ButtonStyle(),
                      child: Text(
                        "Sign Up",
                      ),
                      onPressed: !(emailState && passwordState && userNameState)
                          ? null
                          : () {
                              if (_formKey.currentState.validate() && !isSubmitting) {
                                context.read<SignupCubit>().signUpWithEmailAndPassword();
                              }
                            }

                      // onPressed: !(emailState && passwordState)
                      //     ? null
                      //     : () {
                      //         if (_formKey.currentState.validate()) {
                      //           // _formKey.currentState.save();
                      //           print("Email :" + _usernameTextEditingController.text);
                      //           print("Password :" + _passwordTextEditingController.text);
                      //           RepositoryProvider.of<AuthRepo>(context).logInWithEmailAndPassword(
                      //             email: _usernameTextEditingController.text,
                      //             password: _passwordTextEditingController.text,
                      //           );
                      //         }
                      //       },

                      ),
                );
              },
            );
          },
        );
      },
    );
  }

  // _handleSignUp(BuildContext context, bool isSubmitting) {
  //   if (_formKey.currentState.validate() && !isSubmitting) {
  //     context.read<SignupCubit>().signUpWithEmailAndPassword();
  //   }
  // }

  Widget _buildFormFields(BuildContext context) {
    final node = FocusScope.of(context);
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _usernameEditingController,
              validator: (value) {
                if (value == null || value.length < 3 || value.trim().isEmpty) {
                  return "Invalid username";
                } else
                  return null;
              },
              decoration: customInputDecoration.copyWith(
                hintText: "Username",
                hintStyle: Theme.of(context).textTheme.caption,
              ),
              textCapitalization: TextCapitalization.words,
              onChanged: (username) {
                BlocProvider.of<UserNameChangeBloc>(context).add(username);
                BlocProvider.of<SignupCubit>(context).usernameChanged(username);
              },
              onEditingComplete: () => node.nextFocus(),
            ),
            sbH20,
            TextFormField(
              controller: _emailEditingController,
              validator: (value) {
                if (value.isEmpty || value == null || value.length < 3 || !value.contains("@")) {
                  return "Invalid email";
                } else
                  return null;
              },
              decoration: customInputDecoration.copyWith(
                hintText: "Email address",
                hintStyle: Theme.of(context).textTheme.caption,
              ),
              onChanged: (email) {
                BlocProvider.of<EmailChangeBloc>(context).add(email);
                context.read<SignupCubit>().emailChanged(email);
              },
              onEditingComplete: () => node.nextFocus(),
            ),
            sbH20,
            BlocBuilder<PasswordShowHideToggleBtn, bool>(
              builder: (context, passwordState) {
                return TextFormField(
                  controller: _passwordEditingController,
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
                    BlocProvider.of<SignupCubit>(context).passwordChanged(password);
                  },
                  // onEditingComplete: () => node.unfocus(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
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
