import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String username;
  final String email;
  final String imageUrl;
  final int followers;
  final int following;
  final String bio;

  const UserModel({
    this.id,
    this.username,
    this.email,
    this.imageUrl,
    this.followers,
    this.following,
    this.bio,
  });

  //if user model does not exist in firebase we return empty model
  static const empty = UserModel(
    id: '',
    username: '',
    email: '',
    imageUrl: '',
    followers: 0,
    following: 0,
    bio: '',
  );

  //to store map to firebase document

  Map<String, dynamic> toDocument() {
    return {
      'username': username,
      'email': email,
      'imageUrl': imageUrl,
      'followers': followers,
      'following': following,
      'bio': bio,
    };
  }

  //to fetch data from firebase
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      following: (data['following'] ?? 0).toInt(),
      followers: (data['followers'] ?? 0).toInt(),
      bio: data['bio'] ?? '',
    );
  }

  @override
  List<Object> get props => [
        id,
        username,
        email,
        imageUrl,
        followers,
        following,
        bio,
      ];

  UserModel copyWith({
    String id,
    String username,
    String email,
    String imageUrl,
    int followers,
    int following,
    String bio,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
    );
  }
}
