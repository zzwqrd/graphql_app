import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Delete Confirmation Dialog
void showDeleteConfirmationDialog({
  required BuildContext context,
  required String addressLabel,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        'حذف العنوان',
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
      ),
      content: Text(
        'هل أنت متأكد من حذف عنوان "$addressLabel"؟',
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF757575)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF757575)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(
            'حذف',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFFE53935),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
