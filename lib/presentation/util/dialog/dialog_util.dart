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