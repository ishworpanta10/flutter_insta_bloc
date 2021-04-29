import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;

  const ErrorDialog({this.title = "Error", @required this.message}) : assert(message != null);
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? _showIOSDialog(context) : _showAndroidDialog(context);
  }

  CupertinoAlertDialog _showIOSDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title ?? ""),
      content: Text(message ?? ""),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: const Text("Ok"),
        ),
      ],
    );
  }

  AlertDialog _showAndroidDialog(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? ""),
      content: Text(message ?? ""),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Ok"),
        )
      ],
    );
  }
}
