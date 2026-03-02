import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Checkout Order Summary Widget
/// Displays order totals and breakdown
class CheckoutOrderSummary extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double shippingCharge;
  final double discount;
  final double total;

  const CheckoutOrderSummary({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.shippingCharge,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEFF0F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملخص الطلب',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F1F39),
            ),
          ),
          SizedBox(height: 16.h),

          // Subtotal
          _buildRow('المجموع الفرعي', subtotal),
          SizedBox(height: 12.h),

          // Tax
          _buildRow('الضريبة', tax),
          SizedBox(height: 12.h),

          // Shipping
          _buildRow('رسوم التوصيل', shippingCharge),
          SizedBox(height: 12.h),

          // Discount
          if (discount > 0) ...[
            _buildRow('الخصم', -discount, isDiscount: true),
            SizedBox(height: 12.h),
          ],

          Divider(color: const Color(0xFFEFF0F6)),
          SizedBox(height: 12.h),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F1F39),
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF01BE5F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6E7191),
          ),
        ),
        Text(
          '\$${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDiscount
                ? const Color(0xFF01BE5F)
                : const Color(0xFF1F1F39),
          ),
        ),
      ],
    );
  }
}
