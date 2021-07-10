import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/blocs/blocs.dart';
import 'package:flutter_insta_clone/repositories/repositories.dart';
import 'package:flutter_insta_clone/screens/home/screens/profile/cubit/edit_profile_cubit.dart';

class EditProfileArgs {
  final BuildContext context;

  EditProfileArgs({@required this.context});
}

class EditProfile extends StatelessWidget {
  //for routing
  static const String routeName = "/editProfile";

  static Route route({@required EditProfileArgs args}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: EditProfile.routeName),
      builder: (_) => BlocProvider<EditProfileCubit>(
        create: (context) => EditProfileCubit(
          userRepo: context.read<UserRepo>(),
          storageRepo: context.read<StorageRepo>(),
          profileBloc: args.context.read<ProfileBloc>(),
        ),
        child: EditProfile(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
