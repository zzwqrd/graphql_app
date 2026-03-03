import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonWidget/shimmer/home_shimmer.dart';
import '../../../../commonWidget/title.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../gen/locale_keys.g.dart';
import '../controller/controller.dart';
import '../controller/state.dart';
import '../../../../di/service_locator.dart';
import '../widgets/category.dart';
import '../widgets/cms_block_widget.dart';
import '../widgets/fragrances_uae_arabic_widget.dart';
import '../widgets/home_banner_slider_widget.dart';
import '../widgets/new_arrivals_slider_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<HomeCubit>()
        ..getHome()
        ..getHomeBanners('home')
        ..getProductCmsBlocks(['home-usp'])
        ..getCraftingMemoriesBlock()
        ..getEnhancedSliderProducts('new-arrivals-qatar'),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.requestState.isLoading) {
            return const HomeShimmer();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const HomeBannerSliderWidget().center.py6,
                const CmsBlockWidget(identifier: 'home-usp').px4,
                const FragrancesUaeArabicWidget().px4.py6,
                const NewArrivalsSliderWidget(),
                TitleWidget(text: LocaleKeys.home_categories.tr()).px4.pt6,
                CategoryWidget().px4.pt2,
                SizedBox(height: 120.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

//  showModalBottomSheet(
//                             context: context,
//                             isDismissible: true,
//                             backgroundColor: Colors.transparent,
//                             isScrollControlled: true,
//                             builder: (context) {
//                               return ProductDetailsScreen();
//                             },
//                           );


    // showModalBottomSheet(
    //                         context: context,
    //                         isDismissible: true,
    //                         backgroundColor: Colors.transparent,
    //                         isScrollControlled: true,
    //                         builder: (context) {
    //                           return ProductDetailsScreen(
    //                             sku: state
    //                                 .homeResponse!
    //                                 .bestSellerProducts[index]
    //                                 .sku,
    //                             productName: state
    //                                 .homeResponse!
    //                                 .bestSellerProducts[index]
    //                                 .name,
    //                           );
    //                         },
    //                       );