import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../commonWidget/custom_image.dart';
import '../../../../commonWidget/textwidget.dart';
import '../../../../core/utils/extensions_app/color/color_extensions.dart';
import '../../../../core/utils/extensions_app/padding/padding_extensions.dart';
import '../../../../di/service_locator.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../features/wishlist/presentation/controller/controller.dart';
import '../../../../features/wishlist/presentation/controller/state.dart';
import '../../data/models/enhanced_slider_model.dart';

class EnhancedProductCard extends StatelessWidget {
  const EnhancedProductCard({super.key, required this.item, this.onCardTap});

  final EnhancedSliderItem item;
  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) {
    final price = item.priceRange.minimumPrice;
    final hasDiscount = price.discount.percentOff > 0;

    // Build the sub-title (category / size / gender)
    final attrs = item.customAttributes;
    final List<String> attrParts = [];
    if (attrs?.displayCategory != null && attrs!.displayCategory!.isNotEmpty) {
      attrParts.add(attrs.displayCategory!);
    }
    if (attrs?.displaySize != null && attrs!.displaySize!.isNotEmpty) {
      attrParts.add(attrs.displaySize!);
    }
    if (attrs?.gender != null && attrs!.gender!.isNotEmpty) {
      attrParts.add(attrs.gender!);
    }
    final subTitle = attrParts.join(' / ');
    final productName = item.localizedName;

    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: 156.w,
        decoration: BoxDecoration(
          color: context.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.borderColor, width: 0.75.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  // Product Image
                  CustomImage(
                    item.image,
                    height: 140.h,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),

                  // Rating Top Left
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 10.w),
                          SizedBox(width: 2.w),
                          TextWidget(
                            text:
                                '(${item.ratings.length}) ${item.averageRating.toStringAsFixed(1)}',
                            color: context.black,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Wishlist Icon Top Right
                  Positioned(
                    right: 0,
                    top: 0,
                    child: BlocBuilder<WishlistCubit, WishlistState>(
                      bloc: sl<WishlistCubit>(),
                      builder: (context, state) {
                        final isLoading = state.loadingProductIds.contains(
                          item.uid,
                        );
                        final isInWishlist =
                            state.wishlist?.items.any(
                              (wItem) => wItem.product.uid == item.uid,
                            ) ??
                            false;

                        return InkWell(
                          onTap: isLoading
                              ? null
                              : () {
                                  sl<WishlistCubit>().toggleWishlist(
                                    item.uid,
                                    item.sku,
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
                                      height: 12.r,
                                      width: 12.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : CustomImage(
                                      isInWishlist
                                          ? MyAssets.icons.filledHeart.path
                                          : MyAssets.icons.heart.path,
                                      height: 14.h,
                                      width: 14.w,
                                      color: isInWishlist
                                          ? context.redColor
                                          : null,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Custom Attributes Subtitle (Category / Size / Gender)
              if (subTitle.isNotEmpty)
                TextWidget(
                  text: subTitle,
                  color: context.textColor.withOpacity(0.7),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

              SizedBox(height: 4.h),

              // Product Name
              TextWidget(
                text: productName,
                color: context.textColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Price
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: price.finalPrice.formatted,
                      color: const Color(
                        0xFFC49A45,
                      ), // Golden matching Ajmal theme
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    if (hasDiscount) ...[
                      SizedBox(width: 6.w),
                      TextWidget(
                        text: price.regularPrice.formatted,
                        color: context.textColor.withOpacity(0.5),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ],
                    SizedBox(width: 4.w),
                    TextWidget(
                      text: price.finalPrice.currency,
                      color: const Color(0xFFC49A45),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ).py2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
