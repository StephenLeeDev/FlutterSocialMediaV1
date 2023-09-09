import 'package:flutter/material.dart';

void showTwoButtonDialog({
  required BuildContext context,
  required String title,
  String? message,
  /// First button
  required String firstButtonText,
  Function()? firstButtonListener,
  /// Second button
  String? secondButtonText,
  Function()? secondButtonListener,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext buildContext) {
      return AlertDialog(
        title: Text(title),
        content: (message != null && message != "") ? Text(message) : null,
        actions: [
          /// Second button
          if (secondButtonText != null)
            TextButton(
              child: Text(secondButtonText),
              onPressed: () {
                Navigator.of(context).pop();
                if (secondButtonListener != null) secondButtonListener();
              },
            ),
          /// First button
          TextButton(
            child: Text(firstButtonText),
            onPressed: () {
              Navigator.of(context).pop();
              if (firstButtonListener != null) firstButtonListener();
            },
          ),
        ],
      );
    },
  );
}

void showTextInputDialogForUpdate({
  required BuildContext context,
  required String title,
  String initialMessage = "",
  /// First button
  required String firstButtonText,
  required Function(String) firstButtonListener,
  /// Second button
  required String secondButtonText,
}) async {
  TextEditingController textController = TextEditingController(text: initialMessage);
  return showDialog<void>(
    context: context,
    builder: (BuildContext buildContext) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          maxLength: 200,
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                textController.clear();
              },
              icon: const Icon(Icons.clear),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(secondButtonText),
          ),
          TextButton(
            onPressed: () {
              firstButtonListener(textController.text);
            },
            child: Text(firstButtonText),
          ),
        ],
      );
    },
  );
}