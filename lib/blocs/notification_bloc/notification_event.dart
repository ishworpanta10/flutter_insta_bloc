part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class UpdateNotificationsEvent extends NotificationEvent {
  final List<NotificationModel> notificationList;

  const UpdateNotificationsEvent({@required this.notificationList});

  @override
  List<Object> get props => [notificationList];
}
