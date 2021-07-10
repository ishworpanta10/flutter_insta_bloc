import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/blocs/blocs.dart';
import 'package:flutter_insta_clone/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, profileState) {
        if (profileState.status == ProfileStatus.failure) {
          //closing the existing dialog if exits during loading
          Navigator.of(context, rootNavigator: true).pop();

          BotToast.closeAllLoading();
          BotToast.showText(text: profileState.failure.message);
          //showing the error dialog if error exists
          showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                title: "Error signing in",
                message: profileState.failure.message,
              );
            },
          );
        }
      },
      builder: (context, profileState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(profileState.userModel.username),
            centerTitle: true,
            actions: [
              if (profileState.isCurrentUser)
                IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          AuthLogOutRequestedEvent(),
                        );
                  },
                  icon: Icon(Icons.exit_to_app),
                )
            ],
          ),
          body: Center(
            child: Container(
              child: Text("Profile Screen"),
            ),
          ),
        );
      },
    );
  }
}
