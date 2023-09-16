import 'package:flutter/material.dart';

class NavigationTab extends StatelessWidget {
  const NavigationTab({
    super.key,
    this.text,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    required this.selectedIndex,
  });

  final String? text;
  final bool isSelected;
  final IconData icon;
  final Function onTap;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        enableFeedback: false,
        onTap: () => onTap(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.black
                  : Colors.grey.shade500,
            ),
            if (text != null && text != "")
            Text(
              text ?? "",
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : Colors.grey.shade500,
              ),
            )
          ],
        ),
      ),
    );
  }
}