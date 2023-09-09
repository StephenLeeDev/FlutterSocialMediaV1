import 'package:flutter/material.dart';

import '../../../../values/color/color.dart';

class CustomAnimatedButton extends StatelessWidget {
  const CustomAnimatedButton({
    Key? key,
    required this.text,
    required this.onPositiveListener,
    this.onNegativeListener,
    this.isEnabled = true,
    this.minimumSize = 50.0,
    this.borderRadius = 10,
    this.color = lightBlue00A7FF,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  final String text;
  final Function onPositiveListener;
  final Function? onNegativeListener;
  final bool isEnabled;
  final double minimumSize;
  final double borderRadius;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isEnabled ? color : Colors.grey.shade300,
        ),
        child: GestureDetector(
          onTap: () {
            if (isEnabled) {
              onPositiveListener();
            } else {
              onNegativeListener != null ? onNegativeListener!() : null;
            }
          },
          child: Container(
            width: double.infinity,
            height: 50.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: isEnabled ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}