import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HandleError {
  final String titleDebug;
  final dynamic messageDebug;
  String? title;
  String? message;
  final Logger _logger = Logger();

  HandleError(
      {required this.titleDebug,
      required this.messageDebug,
      this.title,
      this.message});

  void showErrorDialog(BuildContext context) {
    _logger.d(messageDebug, error: titleDebug);
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              title ?? 'Error',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            content:
                Text(message ?? 'An error occurred. Please try again latter.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }
}
