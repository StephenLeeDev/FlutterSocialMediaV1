import 'package:flutter/material.dart';

import '../../../../../data/constant/error.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({Key? key, required this.listener})
      : super(key: key);

  final Function() listener;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            wentSomethingWrong,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          IconButton(
            onPressed: listener,
            icon: const Icon(Icons.refresh, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
