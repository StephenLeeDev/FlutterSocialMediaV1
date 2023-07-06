import 'package:flutter/material.dart';

void showTwoButtonDialog({
  required BuildContext context,
  required String title,
  required String content,
  /// First button
  required String firstButtonText,
  required Function() firstButtonListener,
  /// Second button
  String? secondButtonText,
  Function()? secondButtonListener,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          /// Second button
          if (secondButtonText != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (secondButtonListener != null) secondButtonListener();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                elevation: MaterialStateProperty.all<double>(0),
              ),
              child: Text(secondButtonText),
            ),
          /// First button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              firstButtonListener();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              elevation: MaterialStateProperty.all<double>(0),
            ),
            child: Text(firstButtonText),
          ),
        ],
      );
    },
  );
}