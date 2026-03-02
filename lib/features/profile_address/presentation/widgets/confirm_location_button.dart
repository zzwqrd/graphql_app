import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Confirm Location Button Widget
/// Bottom button to confirm selected location
class ConfirmLocationButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onConfirm;

  const ConfirmLocationButton({
    super.key,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading
              ? const Color(0xFFBDBDBD)
              : const Color(0xFF4CAF50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'تأكيد الموقع',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
