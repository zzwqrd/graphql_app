import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../commonWidget/textwidget.dart';
import '../../../../commonWidget/title.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions_app/color/color_extensions.dart';
import '../../../../core/utils/extensions_app/padding/padding_extensions.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../controller/controller.dart';
import '../controller/state.dart';
import 'enhanced_product_card.dart';

class NewArrivalsSliderWidget extends StatelessWidget {
  const NewArrivalsSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.newArrivalsRequestState == RequestState.loading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleWidget(text: "جديدنا").px4.pt6,
              SizedBox(height: 12.h),
              SizedBox(
                height: 280.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    return _buildShimmerCard(context);
                  },
                ),
              ),
            ],
          );
        }

        if (state.newArrivalsRequestState == RequestState.error) {
          return const SizedBox.shrink();
        }

        final data = state.newArrivalsData;
        if (data == null || data.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            if (data.displayTitle == 1)
              TitleWidget(
                text: data.title ?? data.sliderNameArabic ?? "جديدنا",
              ).px4.pt6,

            SizedBox(height: 12.h),

            // Products list
            SizedBox(
              height: 280.h, // Adjusted height to fit product card perfectly
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemCount: data.items.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final item = data.items[index];
                  return EnhancedProductCard(
                    item: item,
                    onCardTap: () {
                      push(
                        NamedRoutes.i.productDetails,
                        arguments: {'sku': item.sku, 'name': item.name},
                      );
                    },
                  );
                },
              ),
            ),

            if (data.discoverAll != null && data.discoverAll!.isNotEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.primaryColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: TextWidget(
                      text: "إكتشف الكل",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: context.primaryColor,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 156.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 0.75.w),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140.h,
                width: double.infinity,
                color: Colors.white,
              ),
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 10.h,
                  width: 100.w,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 14.h,
                width: double.infinity,
                color: Colors.white,
              ),
              SizedBox(height: 4.h),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 14.h,
                  width: 80.w,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
