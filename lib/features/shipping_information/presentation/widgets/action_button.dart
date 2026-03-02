import 'package:flutter/material.dart';

/// Custom widget for add/edit action buttons
class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const ActionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor = const Color(0xFF01BE5F),
    this.textColor = Colors.white,
    this.icon,
  });

  factory ActionButton.add({required VoidCallback onTap}) {
    return ActionButton(
      text: 'اضافة',
      onTap: onTap,
      backgroundColor: const Color(0xFF01BE5F),
      textColor: Colors.white,
      icon: Icons.add,
    );
  }

  factory ActionButton.edit({required VoidCallback onTap}) {
    return ActionButton(
      text: 'تعديل',
      onTap: onTap,
      backgroundColor: const Color(0xFFE6FFF0),
      textColor: const Color(0xFF01BE5F),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
