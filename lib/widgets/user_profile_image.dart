import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  final double radius;
  final String profileImageURl;
  final File profileImage;

  const UserProfileImage(
      {@required this.radius,
      @required this.profileImageURl,
      this.profileImage});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: profileImage != null
          ? FileImage(profileImage)
          : profileImageURl.isNotEmpty
              ? CachedNetworkImageProvider(profileImageURl)
              : null,
      child: _noProfileIcon(),
    );
  }

  Icon _noProfileIcon() {
    if (profileImage == null && profileImageURl.isEmpty)
      return Icon(
        Icons.account_circle,
        color: Colors.grey[400],
        size: radius * 2,
      );
    return null;
  }
}
