import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/extensions.dart';
import '../../../../../core/utils/extensions_app/extensions_init.dart';

class AllCategoriesHeader extends StatelessWidget {
  const AllCategoriesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.eco, color: context.mainColor, size: 20.sp)
            .container(decoration: context.secondaryDecoration)
            .paddingSymmetric(horizontal: 8.w, vertical: 8.h),

        trValue(ar: 'كل الفئات', en: 'All Categories').textCatogory(),
      ],
    ).paddingSymmetric(horizontal: 8.w);
  }
}
