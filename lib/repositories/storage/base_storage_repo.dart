import 'dart:io';

abstract class BaseStorgaeRepo {
  Future<String> uploadProfileImageAndGiveUrl({String url, File image});
  Future<String> uploadPostImageAndGiveUrl({File image});
}
