import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../data/models/product_details_model.dart';

class ProductInfo extends StatelessWidget {
  final ProductDetailsModel product;

  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final price = product.priceRange.minimumPrice;
    final regularPrice = price.regularPrice.value;
    final finalPrice = price.finalPrice.value;
    final hasDiscount = price.discount.percentOff > 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              product.sku,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            product.name,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: context.mainColor,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (hasDiscount)
                Text(
                  '£E ${regularPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
              SizedBox(width: 8.w),
              Text(
                '£E ${finalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: context.mainColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
