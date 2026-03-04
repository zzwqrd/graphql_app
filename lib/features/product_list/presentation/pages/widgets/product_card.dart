import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../../commonWidget/custom_image.dart';
import '../../../../../core/routes/app_routes_fun.dart';
import '../../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../../di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../cart/presentation/widgets/add_to_cart_icon.dart';
import '../../../../wishlist/presentation/controller/controller.dart';
import '../../../../wishlist/presentation/controller/state.dart';
import '../../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final price = product.priceRange.minimumPrice;
    final regularPrice = price.regularPrice.value;
    final finalPrice = price.finalPrice.value;
    final hasDiscount = price.discount.percentOff > 0;
    final isOutOfStock = product.stockStatus == 'OUT_OF_STOCK';
    // debugPrint('ProductCard: ${product.name}, UID: ${product.uid}, SKU: ${product.sku}');

    return InkWell(
      onTap: () {
        push(
          NamedRoutes.i.productDetails,
          arguments: {'sku': product.sku, 'name': product.name},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and Badges
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: product.smallImage!.displayImageUrl.isNotEmpty
                          ? Builder(
                              builder: (context) {
                                debugPrint(
                                  'ProductCard Image: ${product.smallImage!.displayImageUrl}',
                                );
                                return CustomImage(
                                  product.smallImage!.displayImageUrl,
                                  fit: BoxFit.contain,
                                );
                              },
                            )
                          : const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: BlocBuilder<WishlistCubit, WishlistState>(
                      bloc: sl<WishlistCubit>(),
                      builder: (context, state) {
                        final isInWishlist =
                            state.wishlist?.items.any(
                              (item) => item.product.uid == product.uid,
                            ) ??
                            false;

                        final isLoading = state.loadingProductIds.contains(
                          product.uid,
                        );

                        if (product.uid.isEmpty) {
                          return Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                            size: 20.w,
                          );
                        }

                        if (isLoading) {
                          return SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          );
                        }

                        return InkWell(
                          onTap: () async {
                            await sl<WishlistCubit>().toggleWishlist(
                              product.uid,
                              product.sku,
                            );
                          },
                          child: Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isInWishlist
                                ? Colors.red
                                : context.mainColor,
                            size: 20.w,
                          ),
                        );
                      },
                    ),
                  ),
                  if (isOutOfStock)
                    Positioned(
                      bottom: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.mainColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          LocaleKeys.product_list_out_of_stock.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  if (hasDiscount)
                    Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${price.discount.percentOff.toStringAsFixed(1)}${LocaleKeys.product_list_discount_off.tr()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.localizedName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${LocaleKeys.product_list_currency_symbol.tr()} ${finalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              if (hasDiscount)
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${LocaleKeys.product_list_currency_symbol.tr()} ${regularPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        AddToCartIcon(product: product),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
