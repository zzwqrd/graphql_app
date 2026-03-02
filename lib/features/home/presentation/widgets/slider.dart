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

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GenericBloc<int> dotIndex = GenericBloc(0);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final sliders = state.homeResponse?.sliders ?? [];

        if (sliders.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 142.h,
          width: 328.w,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              /// ================= SLIDER =================
              CarouselSlider.builder(
                itemCount: sliders.length,
                itemBuilder: (context, index, _) {
                  final slider = sliders[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomImage(
                      slider.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ).center;
                },
                options: CarouselOptions(
                  height: 142.h,
                  viewportFraction: 1,
                  autoPlay: true,
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
                      dotsCount: sliders.length,
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

// class SliderWidget extends StatelessWidget {
//   const SliderWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     GenericBloc<int> dotIndex = GenericBloc(0);
//     return Container(
//       height: 142.h,
//       width: 328.w,
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           CarouselSlider.builder(
//             itemCount: 5,
//             itemBuilder: (context, index, _) {
//               return CustomImage(
//                 "https://greenup.com.sa/media/magiccart/magicslider/f/i/file_1_1.png",
//               ).center;
//             },
//             options: CarouselOptions(
//               height: 142.h,
//               viewportFraction: 1,
//               autoPlay: true,
//               enlargeCenterPage: true,
//               disableCenter: true,
//               onPageChanged: (index, reason) {
//                 dotIndex.onUpdateData(index);
//               },
//             ),
//           ).center,

//           BlocBuilder<GenericBloc<int>, GenericState<int>>(
//             bloc: dotIndex,
//             builder: (context, state) {
//               return Positioned(
//                 bottom: 10,
//                 child: DotsIndicator(
//                   dotsCount: 5,
//                   position: state.data.toDouble(),
//                   decorator: DotsDecorator(
//                     spacing: EdgeInsets.only(left: 5.w),
//                     shape: const CircleBorder(
//                       side: BorderSide(color: Colors.black),
//                       eccentricity: 0.8,
//                     ),
//                     color: Colors.transparent,
//                     activeColor: Colors.black,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
