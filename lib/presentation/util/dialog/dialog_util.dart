import 'package:flutter/foundation.dart';
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

/// Text input dialog
void showModalBottomKeyboard({
  required BuildContext context,
  required String initialMessage,
  required String hint,
  int minLines = 1,
  int maxLines = 4,
  int maxLength = 200,
  required Function(String) textEditedListener,
  required Function(String) completeListener,
  required ValueListenable<bool> valueListenable,
}) {
  final FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController(text: initialMessage);

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext buildContext) {
      Future.delayed(Duration.zero, () {
        FocusScope.of(buildContext).requestFocus(focusNode);
      });
      return
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(buildContext).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// Text input
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: hint,
                      border: const OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 4,
                    maxLength: 200,
                    onChanged: (newStatusMessage) {
                      textEditedListener(newStatusMessage);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                /// Complete button
                ValueListenableBuilder<bool>(
                  valueListenable: valueListenable,
                  builder: (buildContext, isValid, _) {
                    return IconButton(
                      onPressed: () async {
                        isValid ? completeListener(textEditingController.text) : null;
                      },
                      icon: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Icon(
                          Icons.send,
                          color: isValid ? Colors.black : Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
    },
  );
}