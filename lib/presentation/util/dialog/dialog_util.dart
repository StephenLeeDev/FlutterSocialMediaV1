import 'package:flutter/material.dart';

void showTwoButtonDialog({
  required BuildContext context,
  required String title,
  String? content,
  /// First button
  required String firstButtonText,
  required Function() firstButtonListener,
  /// Second button
  String? secondButtonText,
  Function()? secondButtonListener,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext buildContext) {
      return AlertDialog(
        title: Text(title),
        content: (content != null && content != "") ? Text(content) : null,
        actions: [
          /// Second button
          if (secondButtonText != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(buildContext);
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
              Navigator.pop(buildContext);
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