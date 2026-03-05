import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../commonWidget/textwidget.dart';
import '../../../../commonWidget/title.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../controller/controller.dart';
import '../controller/state.dart';
import '../../../../core/utils/flash_helper.dart';
import 'enhanced_product_card.dart';

class NewArrivalsSliderWidget extends StatefulWidget {
  const NewArrivalsSliderWidget({super.key});

  @override
  State<NewArrivalsSliderWidget> createState() =>
      _NewArrivalsSliderWidgetState();
}

class _NewArrivalsSliderWidgetState extends State<NewArrivalsSliderWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.newArrivalsRequestState == RequestState.loading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleWidget(
                text: state.newArrivalsData?.localizedTitle ?? "",
              ).px4.pt6,
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
              // TitleWidget(text: data.localizedTitle).px4.pt6,
              TitleWidget(
                text: trValue(ar: data.sliderNameArabic, en: data.title),
              ).px4.pt6,

            SizedBox(height: 12.h),
            //  ProductWidget(
            //                                               product: product,
            //                                               onCardTap: () {
            //                                                 push(
            //                                                   NamedRoutes.i.productDetails,
            //                                                   arguments: {
            //                                                     'sku': product.sku,
            //                                                     'name': product.name,
            //                                                   },
            //                                                 );
            //                                               },
            //                                             );
            // Products Carousel
            CarouselSlider.builder(
              itemCount: data.items.length,
              options: CarouselOptions(
                height: 280.h,
                viewportFraction: 0.45,
                pageSnapping: true,
                enableInfiniteScroll: false,
                padEnds: false,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, _) {
                final item = data.items[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: EnhancedProductCard(
                    item: item,
                    onCardTap: () {
                      push(
                        NamedRoutes.i.productDetails,
                        arguments: {'sku': item.sku, 'name': item.name},
                      );
                    },
                  ),
                );
              },
            ).px4,

            SizedBox(height: 16.h),

            // Dots Indicator
            Center(
              child: DotsIndicator(
                dotsCount: data.items.length,
                position: _currentIndex.toDouble(),
                decorator: DotsDecorator(
                  size: const Size.square(8.0),
                  activeSize: const Size(20.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: context.borderColor,
                  activeColor: context.black,
                ),
              ),
            ),

            if (data.discoverAll != null && data.discoverAll!.isNotEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
                  child: OutlinedButton(
                    onPressed: () {
                      final categories = state.homeResponse?.categories ?? [];
                      final slug = data.discoverAll!.toLowerCase();

                      if (categories.isEmpty) {
                        FlashHelper.failToast(
                          trValue(
                            ar: "لا يوجد أقسام لعرضها",
                            en: "No categories available",
                          ),
                        );
                        return;
                      }

                      // البحث عن فئة تطابق الكلمة المفتاحية "perfumes" أو slug المبعوث
                      final category = categories.firstWhere(
                        (c) =>
                            c.urlPath.toLowerCase().contains(slug) ||
                            c.name.toLowerCase().contains(slug),
                        orElse: () => categories.first,
                      );

                      push(
                        NamedRoutes.i.productList,
                        arguments: {
                          'categoryUid': category.id,
                          'categoryName': category.name,
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.primaryColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.w),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 48.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: TextWidget(
                      text: trValue(ar: "إكتشف الكل", en: "Discover All"),
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
