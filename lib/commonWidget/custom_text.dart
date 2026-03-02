import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.size,
    this.color = const Color(0xFF1F1F39),
    this.decoration,
    this.weight,
    this.textDecoration,
    this.textAlign,
  });

  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final bool? decoration;
  final TextDecoration? textDecoration;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      textAlign: textAlign,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: weight,
        fontStyle: FontStyle.normal,
        decoration: textDecoration,
      ),
    );
  }
}
