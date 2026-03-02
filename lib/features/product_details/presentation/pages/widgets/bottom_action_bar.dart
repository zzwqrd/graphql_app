import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../cart/presentation/widgets/product_details_cart_controls.dart';
import '../../../../product_list/data/models/product_model.dart';

class BottomActionBar extends StatelessWidget {
  final bool isOutOfStock;
  final ProductModel product;

  const BottomActionBar({
    super.key,
    required this.isOutOfStock,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: isOutOfStock
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFC2185B),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Text(
                'غير متوفر بالمخزن',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ProductDetailsCartControls(product: product),
    );
  }
}

class BottomActionBarNew extends StatelessWidget {
  final bool isOutOfStock;
  final ProductModel product;
  final int quantity;

  const BottomActionBarNew({
    super.key,
    required this.isOutOfStock,
    required this.product,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return isOutOfStock
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFC2185B),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Text(
              'غير متوفر بالمخزن',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ProductDetailsCartControlsNew(product: product, quantity: quantity);
  }
}
