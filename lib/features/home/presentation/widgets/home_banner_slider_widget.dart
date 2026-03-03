import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../commonWidget/custom_image.dart';
import '../../../../core/general_bloc/generic_cubit.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart'
    show AlignmentExtensions, ColorExtensions;
import '../controller/controller.dart';
import '../controller/state.dart';

class HomeBannerSliderWidget extends StatelessWidget {
  const HomeBannerSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GenericBloc<int> dotIndex = GenericBloc(0);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final bannerData = state.homeBannerSliderData;

        // While loading we can show a placeholder or empty SizedBox
        if (bannerData == null || bannerData.banners.isEmpty) {
          if (state.bannerRequestState.isLoading) {
            return SizedBox(
              height: 142.h,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          return const SizedBox.shrink();
        }

        final banners = bannerData.banners;

        // Try to parse autoplay settings if provided from back-end slider info
        final sliderConfig = bannerData.slider.isNotEmpty
            ? bannerData.slider.first
            : null;
        final autoPlayTimeoutMs =
            int.tryParse(sliderConfig?.autoplayTimeout ?? '5000') ?? 5000;

        return Container(
          height: 142.h,
          width: 328.w,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              /// ================= SLIDER =================
              CarouselSlider.builder(
                itemCount: banners.length,
                itemBuilder: (context, index, _) {
                  final banner = banners[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: InkWell(
                      onTap: () {
                        // Depending on what banner navigation action is required.
                      },
                      child: CustomImage(
                        banner.image ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ).center;
                },
                options: CarouselOptions(
                  height: 142.h,
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: Duration(milliseconds: autoPlayTimeoutMs),
                  enlargeCenterPage: false,
                  disableCenter: true,
                  onPageChanged: (index, reason) {
                    dotIndex.onUpdateData(index);
                  },
                ),
              ).center,

              /// ================= DOTS =================
              BlocBuilder<GenericBloc<int>, GenericState<int>>(
                bloc: dotIndex,
                builder: (context, dotState) {
                  return Positioned(
                    bottom: 10.h,
                    child: DotsIndicator(
                      dotsCount: banners.length,
                      position: dotState.data.toDouble(),
                      decorator: DotsDecorator(
                        spacing: EdgeInsets.only(left: 5.w),
                        shape: CircleBorder(
                          side: BorderSide(color: context.mainColor),
                          eccentricity: 0.8,
                        ),
                        color: Colors.transparent,
                        activeColor: context.mainColor,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
