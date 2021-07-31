import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/extensions/extensions.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/screens/home/screens/profile/profile_screen.dart';
import 'package:flutter_insta_clone/widgets/user_profile_image.dart';

class PostView extends StatelessWidget {
  final PostModel postModel;
  final bool isLiked;

  const PostView({Key key, @required this.isLiked, @required this.postModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final author = postModel.author;
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName, arguments: ProfileScreenArgs(userId: author.id)),
            child: Row(
              children: [
                UserProfileImage(radius: 18, profileImageURl: author.imageUrl),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    author.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            //TODO: like functionality
          },
          child: CachedNetworkImage(
            height: MediaQuery.of(context).size.height / 2.25,
            width: double.infinity,
            imageUrl: postModel.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: isLiked ? Icon(Icons.favorite, color: Colors.red) : Icon(Icons.favorite_outline),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.comment),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${postModel.likes} likes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text.rich(TextSpan(children: [
                TextSpan(text: author.username, style: const TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: " "),
                TextSpan(text: postModel.caption),
              ])),
              const SizedBox(height: 4),
              Text(
                '${postModel.dateTime.timeAgoExt()}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
