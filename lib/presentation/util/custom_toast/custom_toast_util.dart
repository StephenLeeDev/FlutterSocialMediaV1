import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCustomToastWithTimer({
  required BuildContext context,
  required String message,
  int seconds = 3,
}) {

  /// To prevent an occasional issue where the Timer triggers Navigator.pop after the onTap has already executed, resulting in an additional pop, an additional safety measure is implemented using the isClosed flag.
  bool isClosed = false;

  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext buildContext) {

      Timer(Duration(seconds: seconds), () {
        if (buildContext != null && buildContext.mounted && !isClosed) Navigator.pop(buildContext);
      });

      return GestureDetector(
        onTap: () {
          if (buildContext.mounted) {
            isClosed = true;
            Navigator.pop(buildContext);
          }
        },
        child: SafeArea(
          child: Wrap(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).then((value) {
    isClosed = true;
  });
}
