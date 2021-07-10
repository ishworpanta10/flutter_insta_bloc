import 'package:flutter/material.dart';

import 'widgets.dart';

class ProfileStat extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final int posts;
  final int following;
  final int followers;

  const ProfileStat({
    @required this.isCurrentUser,
    @required this.isFollowing,
    @required this.posts,
    @required this.following,
    @required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Stats(
                label: 'posts',
                count: posts,
              ),
              _Stats(
                label: 'followers',
                count: followers,
              ),
              _Stats(
                label: 'following',
                count: following,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ProfileButton(
              isCurrentUser: isCurrentUser,
              isFollowing: isFollowing,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final String label;
  final int count;

  const _Stats({Key key, @required this.label, @required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black54),
        )
      ],
    );
  }
}
