import '../../../../commonWidget/custom_image.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final bool isLoading;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.item,
    this.isLoading = false,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 80.w,
                height: 80.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImage(
                    item.product.smallImage?.displayImageUrl ?? '',
                    fit: BoxFit.contain,
                    height: double.infinity,
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              // Product Details
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.product.localizedName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '${item.product.priceRange.minimumPrice.finalPrice.currency} ${item.product.priceRange.minimumPrice.finalPrice.formatted}',
                      style: TextStyle(
                        color: context.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // spacing: 15.w,
                      children: [
                        Row(
                          children: [
                            _buildQuantityButton(
                              context: context,
                              icon: Icons.remove,
                              onTap: () {
                                onDecrement();
                              },
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              '${item.quantity}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            _buildQuantityButton(
                              context: context,
                              icon: Icons.add,
                              onTap: () {
                                onIncrement();
                              },
                            ),
                          ],
                        ).container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: context.grayColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        InkWell(
                          onTap: () {
                            onDelete();
                          },
                          child: Row(
                            children: [
                              CustomImage(
                                MyAssets.icons.delete.path,
                                color: context.redColor,
                                width: 12.sp,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                trValue(ar: 'إزالة', en: 'Remove'),
                                style: TextStyle(
                                  color: context.redColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ).container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: context.redColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ],
                    ).pt6,
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
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
  }

  Widget _buildQuantityButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: context.mainColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(icon, size: 12.sp, color: context.white),
      ),
    );
  }
}
