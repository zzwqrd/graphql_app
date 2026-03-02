import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/payment_method_entity.dart';

/// Payment Method Card Widget
/// Displays a single payment method with selection state
class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodEntity paymentMethod;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF01BE5F)
                : const Color(0xFFEFF0F6),
            width: isSelected ? 2.r : 1.r,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF01BE5F).withOpacity(0.1),
                    blurRadius: 8.r,
                    offset: Offset(0, 2.h),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Payment Method Icon/Image
            if (paymentMethod.image != null)
              Image.network(
                paymentMethod.image!,
                height: 40.h,
                width: 40.w,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.payment,
                    size: 40.sp,
                    color: const Color(0xFF6E7191),
                  );
                },
              )
            else
              Icon(
                Icons.payment,
                size: 40.sp,
                color: isSelected
                    ? const Color(0xFF01BE5F)
                    : const Color(0xFF6E7191),
              ),

            SizedBox(height: 8.h),

            // Payment Method Name
            Text(
              paymentMethod.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF1F1F39)
                    : const Color(0xFF6E7191),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Selection Indicator
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 4.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF01BE5F),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'محدد',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
