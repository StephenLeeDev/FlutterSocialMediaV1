import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCustomToastWithTimer({
  required BuildContext context,
  required String message,
  int seconds = 2,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {

      Timer(Duration(seconds: seconds), () {
        if (context.mounted) Navigator.pop(context);
      });

      return GestureDetector(
        onTap: () {
          if (context.mounted) Navigator.pop(context);
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
  );
}
