import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/repositories/notification/notification_repo.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepo _notificationRepo;
  final AuthBloc _authBloc;
  NotificationBloc({@required NotificationRepo notificationRepo, @required AuthBloc authBloc})
      : _notificationRepo = notificationRepo,
        _authBloc = authBloc,
        super(NotificationState.initial()) {
    _notificationSubscription?.cancel();
    _notificationSubscription = _notificationRepo.getUserNotifications(userId: _authBloc.state.user.uid).listen((notifications) async {
      final allNotification = await Future.wait(notifications);
      add(
        UpdateNotificationsEvent(notificationList: allNotification),
      );
    });
  }

  StreamSubscription<List<Future<NotificationModel>>> _notificationSubscription;

  @override
  Future<void> close() {
    _notificationSubscription.cancel();
    return super.close();
  }

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is UpdateNotificationsEvent) {
      yield* _mapUpdateNotificationsEventToState(event);
    }
  }

  Stream<NotificationState> _mapUpdateNotificationsEventToState(UpdateNotificationsEvent event) async* {
    yield state.copyWith(status: NotificationStatus.loading);
    try {
      yield state.copyWith(notificationList: event.notificationList, status: NotificationStatus.loaded);
    } on FirebaseException catch (e) {
      yield state.copyWith(
        status: NotificationStatus.error,
        failure: Failure(message: "${e.message}"),
      );
      print("Firebase Error: ${e.message}");
    } catch (e) {
      yield state.copyWith(
        status: NotificationStatus.error,
        failure: const Failure(message: "something went wrong !"),
      );
      print("Something Unknown Error: ${e.toString()}");
    }
  }
}
