import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/assets.gen.dart';

import '../../../../commonWidget/custom_text.dart';
import '../../../../commonWidget/devider.dart';
import '../../../../commonWidget/secondary_button.dart';
import '../../../../commonWidget/shimmer/product_details_shimmer.dart';
import '../../../../commonWidget/textwidget.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../di/service_locator.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../product_details/presentation/controller/controller.dart';
import '../../../product_details/presentation/controller/state.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String sku;
  final String productName;
  const ProductDetailsScreen({
    super.key,
    required this.sku,
    required this.productName,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  bool isFavorite = false;
  String selectedSize = "packet (32)";
  int selectedColorIndex = 0;
  bool showMoreDescription = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ProductDetailsCubit>()..getProductDetails(widget.sku),
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state.requestState == RequestState.loading) {
            return const ProductDetailsShimmer();
          } else if (state.requestState == RequestState.error) {
            return Center(child: Text(state.msg));
          } else if (state.product == null) {
            return Center(
              child: Text(LocaleKeys.product_details_not_found.tr()),
            );
          }
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: BoxDecoration(
                  color: context.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.h), // Space for close button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    state.product?.displayImageUrl ?? "",
                                  ),
                                  fit: BoxFit.contain,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                              ),
                            ),
                            SizedBox(width: 16.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: state.product?.name ?? "",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 4.h),

                                  // Unit/Brand
                                  Row(
                                    children: [
                                      TextWidget(
                                        text: state.product!.uid,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: TextWidget(
                                          text: "الحجم 6",
                                          fontSize: 12.sp,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),

                                  // Prices
                                  Row(
                                    children: [
                                      CustomText(
                                        text: "\$33.25",
                                        size: 20.sp,
                                        weight: FontWeight.bold,
                                        color: context.primaryColor,
                                      ),
                                      SizedBox(width: 8.w),
                                      CustomText(
                                        text: "\$35.00",
                                        size: 16.sp,
                                        weight: FontWeight.w500,
                                        color: Colors.grey[500],
                                        textDecoration:
                                            TextDecoration.lineThrough,
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          "5% تخفيض",
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: "الكمية:",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Container(
                                  width: 120.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (quantity > 1) {
                                            setState(() {
                                              quantity--;
                                            });
                                          }
                                        },
                                        icon: Icon(Icons.remove, size: 20.sp),
                                      ),
                                      TextWidget(
                                        text: quantity.toString(),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (quantity < 10) {
                                            setState(() {
                                              quantity++;
                                            });
                                          }
                                        },
                                        icon: Icon(Icons.add, size: 20.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                if (state.product!.stockStatus == "instock")
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: Colors.green[50],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 16.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: TextWidget(
                                              text: "متوفر في المخزون",
                                              fontSize: 12.sp,
                                              color: Colors.green[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),

                        // Action Buttons
                        Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: SecondaryButton(
                                height: 50.h,
                                text: "أضف إلى السلة",
                                icon: MyAssets.icons.cartBag.path,
                                buttonColor: context.primaryColor,
                                onTap: () {},
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                },
                                child: Container(
                                  height: 50.h,
                                  // width: 50.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        spreadRadius: 0.2,
                                        blurRadius: 8,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.grey,
                                        size: 24.sp,
                                      ).px1,
                                      "المفضلة"
                                          .h6WithoutStyle(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                          .px1,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),

                        const DeviderWidget(),
                        SizedBox(height: 20.h),

                        // Product Description
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  text: "وصف المنتج",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showMoreDescription =
                                          !showMoreDescription;
                                    });
                                  },
                                  child: TextWidget(
                                    text: showMoreDescription
                                        ? "عرض أقل"
                                        : "عرض المزيد",
                                    fontSize: 14.sp,
                                    color: context.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            TextWidget(
                              text: showMoreDescription
                                  ? "No job is too big, no pup is too small! Lups diapers with new Paw Patrol designs have your back and their butts. Lups now has up to 12 hours of protection, day and night. Like Chase and Marshall would say, our highly trained paws are at your service. And diaper leaks? We are on the case with nonstop leak protection. Lups Triple Leak guards absorb quickly to help stop diaper leaks before they happen."
                                  : "No job is too big, no pup is too small! Lups diapers with new Paw Patrol designs have your back and their butts...",
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),

              // Close Button
              Positioned(
                top: 16.h,
                right: 16.w,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.close, size: 20.sp),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
