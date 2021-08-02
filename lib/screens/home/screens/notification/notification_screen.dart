import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/blocs/blocs.dart';
import 'package:flutter_insta_clone/widgets/centered_text.dart';
import 'package:flutter_insta_clone/widgets/widgets.dart';

import 'widgets/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, notificationState) {
          switch (notificationState.status) {
            case NotificationStatus.error:
              return CenteredText(text: notificationState.failure.message);
            case NotificationStatus.loaded:
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 60),
                itemCount: notificationState.notificationList.length,
                itemBuilder: (context, index) {
                  final notificationModel = notificationState.notificationList[index];
                  return NotificationTile(notificationModel: notificationModel);
                },
              );

            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
