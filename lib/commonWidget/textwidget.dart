import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    this.textAlign,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.maxLines,
    this.overflow,
    this.decoration,
  });
  final String? text;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        decoration: decoration,
        height: 1.h,
        decorationThickness: decoration != null ? 1 : null,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
