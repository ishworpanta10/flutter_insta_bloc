part of 'notification_bloc.dart';

enum NotificationStatus { initial, loading, loaded, error }

class NotificationState extends Equatable {
  final List<NotificationModel> notificationList;
  final NotificationStatus status;
  final Failure failure;

  const NotificationState({@required this.notificationList, @required this.status, @required this.failure});

  factory NotificationState.initial() {
    return const NotificationState(
      notificationList: [],
      status: NotificationStatus.initial,
      failure: Failure(),
    );
  }

  NotificationState copyWith({
    List<NotificationModel> notificationList,
    NotificationStatus status,
    Failure failure,
  }) {
    return new NotificationState(
      notificationList: notificationList ?? this.notificationList,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object> get props => [notificationList, status, failure];
}
