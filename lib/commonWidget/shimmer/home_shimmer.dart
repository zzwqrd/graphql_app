import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/utils/extensions_app/extensions_init.dart';
import 'categories_shimmer.dart';
import 'product_grid_item_shimmer.dart';
import 'slider_shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Slider Shimmer
          const SliderSectionShimmer().center.py6,

          // 2. Categories Shimmer
          const _SectionTitleShimmer().px4,
          const CategoriesSectionShimmer().px4.py4,

          // 3. Best Seller Section Shimmer
          const _SectionTitleShimmer().px4.pt5,
          const _HorizontalProductListShimmer().px4.py4,

          // 4. Banner 1 Shimmer
          const _BannerShimmer().px4.py4,

          // 5. Most Searched Section Shimmer
          const _SectionTitleShimmer().px4.pt5,
          const _HorizontalProductListShimmer().px4.py4,

          // 6. Banner 2 Shimmer
          const _BannerShimmer().px4.py4,

          // 7. New Arrivals Section Shimmer
          const _SectionTitleShimmer().px4.pt5,
          const _HorizontalProductListShimmer().px4.py4,

          SizedBox(height: 120.h),
        ],
      ),
    );
  }
}

class _SectionTitleShimmer extends StatelessWidget {
  const _SectionTitleShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[300]!,
      child: Container(
        height: 24.h,
        width: 150.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.w),
        ),
      ),
    );
  }
}

class _HorizontalProductListShimmer extends StatelessWidget {
  const _HorizontalProductListShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 253.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 9.3.w),
            child: const ProductGridItemShimmer(),
          );
        },
      ),
    );
  }
}

class _BannerShimmer extends StatelessWidget {
  const _BannerShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[300]!,
      child: Container(
        height: 150.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.w),
        ),
      ),
    );
  }
}
