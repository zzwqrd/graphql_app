import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../commonWidget/custom_image.dart';
import '../../../../commonWidget/textwidget.dart';

import '../../../../core/utils/extensions_app/color/color_extensions.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
  });
  final String? text;
  final String? icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 52.h,
        width: double.infinity,
        child: Center(
          child: Row(
            children: [
              CustomImage('$icon', height: 20.h, width: 20.w),
              16.horizontalSpace,
              TextWidget(
                text: '$text',
                color: context.textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
