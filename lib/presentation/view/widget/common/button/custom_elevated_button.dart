import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPositiveListener,
    this.onNegativeListener,
    this.isEnabled = true,
    this.minimumSize = 50.0,
    this.borderRadius = 10,
  }) : super(key: key);

  final String text;
  final Function onPositiveListener;
  final Function? onNegativeListener;
  final bool isEnabled;
  final double minimumSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isEnabled ? Colors.black : Colors.grey.shade300,
      ),
      child: ElevatedButton(
        onPressed: () {
          if (isEnabled) {
            onPositiveListener();
          } else {
            onNegativeListener != null ? onNegativeListener!() : null;
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isEnabled ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}