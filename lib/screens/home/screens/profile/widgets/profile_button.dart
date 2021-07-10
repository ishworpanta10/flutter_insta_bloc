import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/screens/home/screens/profile/edit_profile.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButton(
      {Key key, @required this.isCurrentUser, @required this.isFollowing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () => Navigator.of(context).pushNamed(
              EditProfile.routeName,
              arguments: EditProfileArgs(context: context),
            ),
            child: const Text(
              'Edit Profile',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          )
        : TextButton(
            style: TextButton.styleFrom(
              backgroundColor: isFollowing
                  ? Colors.grey[300]
                  : Theme.of(context).primaryColor,
            ),
            onPressed: () {},
            child: Text(
              isFollowing ? 'Unfollow' : 'Follow',
              style: TextStyle(
                  fontSize: 16,
                  color: isFollowing ? Colors.black : Colors.white),
            ),
          );
  }
}
