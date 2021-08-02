import 'package:flutter_insta_clone/models/models.dart';

abstract class BaseNotificationRepo {
  Stream<List<Future<NotificationModel>>> getUserNotifications({String userId});
}
