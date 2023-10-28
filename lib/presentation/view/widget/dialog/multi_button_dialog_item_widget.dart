import 'package:flutter/material.dart';

class MultiButtonDialogItemWidget extends StatelessWidget {
  const MultiButtonDialogItemWidget({Key? key, required this.context, required this.listener, required this.iconData, required this.buttonText}) : super(key: key);

  final BuildContext context;
  final Function() listener;
  final IconData iconData;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        listener();
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 44,
        width: double.infinity,
        child: Row(
          children: [
            Icon(iconData),
            const SizedBox(width: 12),
            Text(
              buttonText,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontFamily: 'Roboto',
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
