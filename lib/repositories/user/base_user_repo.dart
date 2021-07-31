import 'package:flutter_insta_clone/models/models.dart';

abstract class BaseUserRepo {
  Future<UserModel> getUserWithId({String userId});
  Future<void> updateUser({UserModel userModel});
  Future<List<UserModel>> searchUsers({String query});
}
