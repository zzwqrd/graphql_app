import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/product_details_model.dart';

class ReviewsTab extends StatelessWidget {
  final ProductDetailsModel product;

  const ReviewsTab({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    if (product.reviews.isEmpty) {
      return Center(
        child: Text(
          'لا توجد تقييمات بعد',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Summary
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (product.ratingSummary / 20).toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'مراجعات (${product.reviewCount})',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
                // Simple Rating Bars Visualization (Placeholder for complex chart)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(5, (index) {
                    return Row(
                      children: [
                        Container(
                          width: 100.w,
                          height: 6.h,
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: index == 0 ? 0.8 : 0.1, // Dummy data
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF0057b7),
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              Icons.star,
                              size: 12.sp,
                              color: starIndex < (5 - index)
                                  ? const Color(0xFFFFA000)
                                  : Colors.grey[300],
                            );
                          }),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          // Reviews List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: product.reviews.length,
            separatorBuilder: (context, index) => Divider(height: 32.h),
            itemBuilder: (context, index) {
              final review = product.reviews[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review.createdAt.split(' ').first,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      Text(
                        review.nickname,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        Icons.star,
                        size: 16.sp,
                        color: starIndex < (review.averageRating / 20)
                            ? const Color(0xFFFFA000)
                            : Colors.grey[300],
                      );
                    }),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    review.summary,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    review.text,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
