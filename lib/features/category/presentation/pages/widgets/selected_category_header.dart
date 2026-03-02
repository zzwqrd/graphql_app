import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedCategoryHeader extends StatelessWidget {
  final String categoryName;
  final int productCount;

  const SelectedCategoryHeader({
    super.key,
    required this.categoryName,
    required this.productCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$categoryName ($productCount)',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // Expanded(
          //   child: Padding(
          //     padding: EdgeInsets.only(right: 16.w),
          //     child: AppCustomForm(
          //       hintText: "بحث...",
          //       readOnly: true,
          //       onTap: () {
          //         // Navigate to search or expand
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
