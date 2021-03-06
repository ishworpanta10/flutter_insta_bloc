import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/assets/assets.dart';
import 'package:flutter_insta_clone/blocs/basic_ui_bloc/basic_ui_blocs_export.dart';
import 'package:flutter_insta_clone/blocs/basic_ui_bloc/email_change_bloc.dart';
import 'package:flutter_insta_clone/blocs/basic_ui_bloc/languageChangingBloc.dart';
import 'package:flutter_insta_clone/constants/const_size_boxes.dart';
import 'package:flutter_insta_clone/cubit/login_cubit/login_cubit.dart';
import 'package:flutter_insta_clone/repositories/auth/auth_repo.dart';
import 'package:flutter_insta_clone/screens/home/screens/nav/navbar.dart';
import 'package:flutter_insta_clone/screens/screens.dart';
import 'package:flutter_insta_clone/styles/decorations/custom_decoration.dart';
import 'package:flutter_insta_clone/widgets/error_dialog.dart';
import 'package:flutter_insta_clone/widgets/loading_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  //for routing
  static const String routeName = "/login";

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, __, ___) => BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(
          authRepo: context.read<AuthRepo>(),
        ),
        child: LoginScreen(),
      ),
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

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, loginState) {
        if (loginState.status == LoginStatus.error) {
          //closing the existing dialog if exits during loading
          Navigator.of(context, rootNavigator: true).pop();

          BotToast.closeAllLoading();
          BotToast.showText(text: loginState.failure.message);
          //showing the error dialog if error exists
          showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                title: "Error signing in",
                message: loginState.failure.message,
              );
            },
          );
        } else if (loginState.status == LoginStatus.success) {
          BotToast.closeAllLoading();
          BotToast.showText(text: "Login Success");
          Navigator.pushReplacementNamed(context, NavBar.routeName);
        } else if (loginState.status == LoginStatus.progress) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return LoadingDialog(
                loadingMessage: "login in, please wait ....",
              );
            },
          );
          // BotToast.showLoading();
        } else if (loginState.status == LoginStatus.initial) {}
      },
      builder: (context, loginState) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            // backgroundColor: Colors.grey[50],
            body: WillPopScope(
              onWillPop: () async {
                return await _resetAllBloc(context);
              },
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
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
                          _buildLogInBtn(context, loginState.status == LoginStatus.progress),
                          sbH10,
                          _buildForgetPasswordRichText(context),
                          sbH10,
                          _buildORDivider(context),
                          sbH20,
                          _buildContinueWithFacebook(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            bottomSheet: _buildBottomSheetText(context),
          ),
        );
      },
    );
  }

  _resetAllBloc(BuildContext context) {
    BlocProvider.of<LanguageChangingBloc>(context).add(null);
    BlocProvider.of<EmailChangeBloc>(context).add(null);
    BlocProvider.of<PasswordChangeBloc>(context).add(null);
    BlocProvider.of<PasswordShowHideToggleBtn>(context).add(true);
  }

  Widget _buildContinueWithFacebook(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print("Continue with facebook");
      },
      child: Container(
        color: Colors.grey[50],
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 12.0,
              child: Icon(
                FontAwesomeIcons.facebookF,
                size: 15.0,
              ),
            ),
            TextButton(
              onPressed: () {
                // print("Continue with facebook");
              },
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.grey[50],
                ),
              ),
              child: Text(
                'Continue as Ishwor Panta',
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildORDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1.6,
          ),
        ),
        SizedBox(
          width: 6.0,
        ),
        Text(
          "OR",
          style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: Theme.of(context).textTheme.subtitle2.color.withOpacity(0.5),
              ),
        ),
        SizedBox(
          width: 6.0,
        ),
        Expanded(
          child: Divider(
            thickness: 1.6,
          ),
        )
      ],
    );
  }

  Widget _buildForgetPasswordRichText(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Forgotten your login details? ",
        style: Theme.of(context).textTheme.caption,
        children: [
          TextSpan(
            text: "Get help with logging in.",
            style: Theme.of(context).textTheme.caption.copyWith(
                  color: Theme.of(context).textTheme.subtitle2.color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _resetAllBloc(context);
        Navigator.pushNamed(context, SignUpScreen.routeName);
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
                  text: 'Don\'t have an account? ',
                  style: Theme.of(context).textTheme.caption,
                  children: [
                    TextSpan(
                      text: "Sign up.",
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 14.0,
                            color: Theme.of(context).textTheme.subtitle2.color,
                            fontWeight: FontWeight.bold,
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

  Widget _buildLogInBtn(BuildContext context, bool isSubmitting) {
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
                        if (_formKey.currentState.validate() && !isSubmitting) {
                          context.read<LoginCubit>().loginWithCredential();
                        }
                      },
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
  }

  Widget _buildFormFields(BuildContext context) {
    final node = FocusScope.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _usernameTextEditingController,
            validator: (value) {
              if (value.isEmpty || value == null || value.length < 3 || !value.contains("@")) {
                return "Invalid username/email";
              } else
                return null;
            },
            decoration: customInputDecoration.copyWith(
              hintText: "Phone number, email address or username",
              hintStyle: Theme.of(context).textTheme.caption,
            ),
            onChanged: (email) {
              //for making login btn clickable
              BlocProvider.of<EmailChangeBloc>(context).add(email);
              //for taking the value of email field
              context.read<LoginCubit>().emailChanged(email);
            },
            onEditingComplete: () => node.nextFocus(),
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
                  context.read<LoginCubit>().passwordChanged(password);
                },
                onEditingComplete: () => node.unfocus(),
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
                // print("Selected Gender :" + value);
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
