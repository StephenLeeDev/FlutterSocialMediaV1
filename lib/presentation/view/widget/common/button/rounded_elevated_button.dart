import 'package:flutter/material.dart';

class RoundedElevatedButton extends StatelessWidget {
  const RoundedElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.minimumSize = 50.0,
    this.borderRadius = 10,
    this.color = Colors.black,
  }) : super(key: key);

  final String text;
  final Function onPressed;
  final bool isEnabled;
  final double minimumSize;
  final double borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        isEnabled ? onPressed() : null;
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(width: 1, color: color),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(
            color: color
        ),
      ),
    );
  }
}