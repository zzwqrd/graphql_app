import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Add Address Button Widget
class AddAddressButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color? primaryColor;

  const AddAddressButton({super.key, required this.onTap, this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(17.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle, size: 18.sp, color: color),
            SizedBox(width: 6.w),
            Text(
              'إضافة جديدة',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
