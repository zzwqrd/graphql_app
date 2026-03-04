import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../commonWidget/custom_image.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';

import '../../../../di/service_locator.dart';
import '../../../../gen/assets.gen.dart';
import '../../data/models/wishlist_model.dart';
import '../controller/controller.dart';
import '../controller/state.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistItemModel item;

  const WishlistItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    return BlocBuilder<WishlistCubit, WishlistState>(
      bloc: sl<WishlistCubit>(),
      buildWhen: (previous, current) =>
          previous.loadingProductIds != current.loadingProductIds ||
          previous.itemId != current.itemId,
      builder: (context, state) {
        final isLoading = state.loadingProductIds.contains(product.uid);

        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImage(
                      product.smallImage?.displayImageUrl ?? '',
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.localizedName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '${product.priceRange.minimumPrice.finalPrice.currency} ${product.priceRange.minimumPrice.finalPrice.value}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Remove Button
                  IconButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            sl<WishlistCubit>().toggleWishlist(
                              product.uid,
                              product.sku,
                            );
                          },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: context.mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MyAssets.lottie.loadingA
                      .lottie(fit: BoxFit.contain, width: 100.w)
                      .center,
                ),
              ),
          ],
        );
      },
    );
  }
}
