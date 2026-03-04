import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonWidget/custom_image.dart';
import '../../../../features/product_list/data/models/product_model.dart';
import '../../../../di/service_locator.dart';
import '../../../../features/cart/presentation/controller/controller.dart';
import '../../../../features/cart/presentation/controller/state.dart';
import '../../../../features/wishlist/presentation/controller/controller.dart';
import '../../../../features/wishlist/presentation/controller/state.dart';
import 'package:flutter/material.dart';

import '../../../../commonWidget/textwidget.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/locale_keys.g.dart';
import 'product_quick_view.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key, required this.product, this.onCardTap});

  final ProductModel product;
  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) {
    final price = product.priceRange.minimumPrice;
    final hasDiscount = product.hasDiscount;
    final isOutOfStock = product.stockStatus == 'OUT_OF_STOCK';
    final isNew = product.isNew;

    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: 156.w,
        height: 260.h,
        decoration: BoxDecoration(
          color: context.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.borderColor, width: 0.75.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Product Image
                  CustomImage(
                    product.smallImage.displayImageUrl,
                    height: 140.h,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),

                  if (hasDiscount)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          '-${price.discount.percentOff > 0 ? price.discount.percentOff.toStringAsFixed(0) : (((price.regularPrice.value - (product.specialPrice ?? price.finalPrice.value)) / price.regularPrice.value) * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  if (isNew)
                    Positioned(
                      top: 0,
                      left: hasDiscount ? 0 : 36.w, // Adjust if heart is there
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          trValue(ar: "جديد", en: "New"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    left: 6.w,
                    top: 6.h,
                    child: BlocBuilder<WishlistCubit, WishlistState>(
                      bloc: sl<WishlistCubit>(),
                      builder: (context, state) {
                        final isLoading = state.loadingProductIds.contains(
                          product.uid,
                        );
                        final isInWishlist =
                            state.wishlist?.items.any(
                              (item) => item.product.uid == product.uid,
                            ) ??
                            false;

                        return InkWell(
                          onTap: isLoading
                              ? null
                              : () {
                                  sl<WishlistCubit>().toggleWishlist(
                                    product.uid,
                                    product.sku,
                                  );
                                },
                          child: Container(
                            height: 24.r,
                            width: 24.r,
                            decoration: BoxDecoration(
                              color: context.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isLoading
                                  ? SizedBox(
                                      height: 24.r,
                                      width: 24.w,
                                      child: Center(
                                        child: MyAssets.lottie.loadingA.lottie(
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : CustomImage(
                                      isInWishlist
                                          ? MyAssets.icons.filledHeart.path
                                          : MyAssets.icons.heart.path,
                                      height: 14.h,
                                      width: 14.w,
                                      color: isInWishlist ? Colors.red : null,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Positioned(
                    right: 6.w,
                    bottom: 6.h,
                    child: BlocBuilder<CartCubit, CartState>(
                      builder: (context, state) {
                        final isLoading =
                            state.addToCart.isLoading &&
                            state.itemId == product.uid;

                        if (isOutOfStock) {
                          return Container(
                            decoration: BoxDecoration(
                              color: context.redColor,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            child: TextWidget(
                              text: LocaleKeys.product_list_out_of_stock
                                  .tr(), // Or "Not Available"
                              color: context.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: isLoading
                              ? null
                              : () {
                                  showModalBottomSheet(
                                    context: context,
                                    isDismissible: true,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return ProductQuickView(
                                        sku: product.sku,
                                        productName: product.name,
                                      );
                                    },
                                  );
                                  // context.read<CartCubit>().addToCart(
                                  //   product,
                                  //   1,
                                  // );
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isLoading
                                  ? Colors.transparent
                                  : context.primaryColor,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    height: 24.h,
                                    width: 40.w,
                                    child: Center(
                                      child: MyAssets.lottie.loadingA.lottie(
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomImage(
                                        MyAssets.icons.bag2.path,
                                        height: 12.h,
                                        width: 12.w,
                                      ),
                                      SizedBox(width: 4.w),
                                      TextWidget(
                                        text: LocaleKeys.add.tr(),
                                        color: context.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 32.h,
                      child: TextWidget(
                        text: product.localizedName,
                        color: context.textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    // Price
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          TextWidget(
                            text: price.finalPrice.formatted,
                            color: context.primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),

                          if (hasDiscount) ...[
                            SizedBox(width: 8.w),
                            TextWidget(
                              text: price.regularPrice.formatted,
                              color: context.black,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ],
                          TextWidget(
                            text: price.finalPrice.currency,
                            color: context.primaryColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ).px1,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
