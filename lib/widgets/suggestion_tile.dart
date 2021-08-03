import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/screens/home/screens/profile/profile_screen.dart';
import 'package:flutter_insta_clone/widgets/user_profile_image.dart';

class SuggestionTile extends StatelessWidget {
  final UserModel user;

  const SuggestionTile({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ProfileScreen.routeName,
        arguments: ProfileScreenArgs(userId: user.id),
      ),
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                UserProfileImage(
                  radius: 46,
                  profileImageURl: user.imageUrl,
                ),
                const SizedBox(height: 8),
                Text(
                  user.username,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
