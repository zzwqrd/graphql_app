import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/utils/extensions_app/extensions_init.dart';

// ignore: must_be_immutable
class TitleWidget extends StatelessWidget {
  TitleWidget({super.key, required this.text});
  String? text;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: TextStyle(
        color: context.black,
        fontWeight: FontWeight.w900,
        fontSize: 15.sp,
      ),
    );
  }
}
