import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonWidget/custom_image.dart';
import '../../../../commonWidget/shimmer/home_shimmer.dart';
import '../../../../commonWidget/title.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../gen/locale_keys.g.dart';
import '../controller/controller.dart';
import '../controller/state.dart';
import '../../../../di/service_locator.dart';
import '../widgets/category.dart';
import '../widgets/product.dart';
import '../widgets/product_quick_view.dart';
import '../../data/models/section_model.dart';
import '../widgets/slider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<HomeCubit>()..getHome(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.requestState.isLoading) {
            return const HomeShimmer();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SliderWidget().center.py6,
                TitleWidget(text: LocaleKeys.home_categories.tr()).px4,
                CategoryWidget().px4,
                if (state.homeResponse?.bestSellerProducts.isNotEmpty ??
                    false) ...[
                  TitleWidget(
                    text:
                        state.homeResponse?.getTitle(
                          HomeSectionType.bestSeller,
                          fallback: "الأفضل مبيعاً",
                        ) ??
                        "الأفضل مبيعاً",
                  ).px4.pt5,
                  SizedBox(
                    height: 253.h,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: 160.w,
                        childAspectRatio: 1 / 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 9.3,
                      ),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount:
                          state.homeResponse?.bestSellerProducts.length ?? 0,
                      itemBuilder: (context, index) {
                        return ProductWidget(
                          onCardTap: () {
                            push(
                              NamedRoutes.i.productDetails,
                              arguments: {
                                'sku': state
                                    .homeResponse!
                                    .bestSellerProducts[index]
                                    .sku,
                                'name': state
                                    .homeResponse!
                                    .bestSellerProducts[index]
                                    .name,
                              },
                            );
                          },
                          product:
                              state.homeResponse!.bestSellerProducts[index],
                        );
                      },
                    ).px4.py4,
                  ),
                ],

                // Banner promotionnelle 1
                if (state.homeResponse?.promotionalBanners.isNotEmpty ?? false)
                  CustomImage(
                        borderRadius: BorderRadius.circular(12),
                        fit: BoxFit.contain,
                        state.homeResponse?.promotionalBanners[0].imageUrl ??
                            '',
                      )
                      .inkWell(
                        onTap: () {
                          final banner =
                              state.homeResponse?.promotionalBanners[0];
                          if (banner != null) {
                            push(
                              NamedRoutes.i.productList,
                              arguments: {
                                'categoryUid': banner.categoryId,
                                'categoryName': banner.categoryName,
                              },
                            );
                          }
                        },
                      )
                      .px4
                      .py4,

                if (state.homeResponse?.mostSearchedProducts.isNotEmpty ??
                    false) ...[
                  TitleWidget(
                    text:
                        state.homeResponse?.getTitle(
                          HomeSectionType.mostSearched,
                          fallback: "الأكثر بحثاً",
                        ) ??
                        "الأكثر بحثاً",
                  ).px4.pt5,
                  SizedBox(
                    height: 253.h,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: 160.w,
                        childAspectRatio: 1 / 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 9.3,
                      ),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount:
                          state.homeResponse?.mostSearchedProducts.length ?? 0,
                      itemBuilder: (context, index) {
                        return ProductWidget(
                          onCardTap: () {
                            showModalBottomSheet(
                              context: context,
                              isDismissible: true,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) => ProductQuickView(
                                sku: state
                                    .homeResponse!
                                    .mostSearchedProducts[index]
                                    .sku,
                                productName: state
                                    .homeResponse!
                                    .mostSearchedProducts[index]
                                    .name,
                              ),
                            );
                          },
                          product:
                              state.homeResponse!.mostSearchedProducts[index],
                        );
                      },
                    ).px4.py4,
                  ),
                ],

                // Banner promotionnelle 2
                if ((state.homeResponse?.promotionalBanners.length ?? 0) > 1)
                  CustomImage(
                        borderRadius: BorderRadius.circular(12),
                        fit: BoxFit.contain,
                        state.homeResponse?.promotionalBanners[1].imageUrl ??
                            '',
                      )
                      .inkWell(
                        onTap: () {
                          final banner =
                              state.homeResponse?.promotionalBanners[1];
                          if (banner != null) {
                            push(
                              NamedRoutes.i.productList,
                              arguments: {
                                'categoryUid': banner.categoryId,
                                'categoryName': banner.categoryName,
                              },
                            );
                          }
                        },
                      )
                      .px4
                      .py4,

                if (state.homeResponse?.newArrivalsProducts.isNotEmpty ??
                    false) ...[
                  TitleWidget(
                    text:
                        state.homeResponse?.getTitle(
                          HomeSectionType.newArrivals,
                          fallback: "وصل حديثاً",
                        ) ??
                        "وصل حديثاً",
                  ).px4.pt5,
                  SizedBox(
                    height: 253.h,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: 160.w,
                        childAspectRatio: 1 / 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 9.3,
                      ),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount:
                          state.homeResponse?.newArrivalsProducts.length ?? 0,
                      itemBuilder: (context, index) {
                        return ProductWidget(
                          onCardTap: () {
                            push(
                              NamedRoutes.i.productDetails,
                              arguments: {
                                'sku': state
                                    .homeResponse!
                                    .newArrivalsProducts[index]
                                    .sku,
                                'name': state
                                    .homeResponse!
                                    .newArrivalsProducts[index]
                                    .name,
                              },
                            );
                          },
                          product:
                              state.homeResponse!.newArrivalsProducts[index],
                        );
                      },
                    ).px4.py4,
                  ),
                ],

                // Banner promotionnelle 3
                if ((state.homeResponse?.promotionalBanners.length ?? 0) > 2)
                  CustomImage(
                        borderRadius: BorderRadius.circular(12),
                        fit: BoxFit.contain,
                        state.homeResponse?.promotionalBanners[2].imageUrl ??
                            '',
                      )
                      .inkWell(
                        onTap: () {
                          final banner =
                              state.homeResponse?.promotionalBanners[2];
                          if (banner != null) {
                            push(
                              NamedRoutes.i.productList,
                              arguments: {
                                'categoryUid': banner.categoryId,
                                'categoryName': banner.categoryName,
                              },
                            );
                          }
                        },
                      )
                      .px4
                      .py4,

                if (state.homeResponse?.specialOffersProducts.isNotEmpty ??
                    false) ...[
                  TitleWidget(
                    text:
                        state.homeResponse?.getTitle(
                          HomeSectionType.specialOffers,
                          fallback: "عروض خاصة",
                        ) ??
                        "عروض خاصة",
                  ).px4.pt5,
                  SizedBox(
                    height: 253.h,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: 160.w,
                        childAspectRatio: 1 / 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 9.3,
                      ),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount:
                          state.homeResponse?.specialOffersProducts.length ?? 0,
                      itemBuilder: (context, index) {
                        return ProductWidget(
                          onCardTap: () {
                            push(
                              NamedRoutes.i.productDetails,
                              arguments: {
                                'sku': state
                                    .homeResponse!
                                    .specialOffersProducts[index]
                                    .sku,
                                'name': state
                                    .homeResponse!
                                    .specialOffersProducts[index]
                                    .name,
                              },
                            );
                          },
                          product:
                              state.homeResponse!.specialOffersProducts[index],
                        );
                      },
                    ).px4.py4,
                  ),
                ],
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