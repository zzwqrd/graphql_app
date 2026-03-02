import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/controller.dart';
import '../controller/state.dart';
import '../../../../core/utils/enums.dart';
import '../../../product_list/data/models/product_model.dart';
import '../../../../di/service_locator.dart';

class ProductDetailsCartControls extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsCartControls({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return _ProductDetailsCartControlsBody(product: product);
  }
}

class _ProductDetailsCartControlsBody extends StatelessWidget {
  final ProductModel product;

  const _ProductDetailsCartControlsBody({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    int quantity = 1;
    final cartCubit = sl<CartCubit>();

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        bool isLoading = false;
        if (state.addToCart == RequestState.loading &&
            state.itemId == product.uid) {
          isLoading = true;
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                // Quantity Selector
                Row(
                  children: [
                    _buildQuantityButton(
                      context: context,
                      icon: Icons.remove,
                      onTap: quantity > 1
                          ? () {
                              setState(() {
                                quantity--;
                              });
                            }
                          : null,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '$quantity',
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
                        setState(() {
                          quantity++;
                        });
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
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                SizedBox(width: 15.w),
                // Add to Cart Button
                SizedBox(
                  height: 45.h,
                  child: isLoading
                      ? MyAssets.lottie.loadingA
                            .lottie(fit: BoxFit.cover)
                            .container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 22.w,
                                vertical: 5.h,
                              ),
                            )
                      : InkWell(
                          onTap: isLoading
                              ? null
                              : () {
                                  context.read<CartCubit>().addToCart(
                                    product,
                                    quantity,
                                  );
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyAssets.icons.cartBag.svg(color: Colors.white),
                              SizedBox(width: 10.w),
                              Text(
                                "اضف للسلة",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ).container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 22.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: context.mainColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildQuantityButton({
    required BuildContext context,
    required IconData icon,
    required dynamic onTap,
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

class ProductDetailsCartControlsNew extends StatelessWidget {
  final ProductModel product;
  final int quantity;

  const ProductDetailsCartControlsNew({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final cartCubit = sl<CartCubit>();

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        bool isLoading = false;
        if (state.addToCart == RequestState.loading &&
            state.itemId == product.uid) {
          isLoading = true;
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 45.h,
              child: isLoading
                  ? MyAssets.lottie.loadingA
                        .lottie(fit: BoxFit.cover)
                        .container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 22.w,
                            vertical: 5.h,
                          ),
                        )
                  : InkWell(
                      onTap: isLoading
                          ? null
                          : () {
                              context.read<CartCubit>().addToCart(
                                product,
                                quantity,
                              );
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyAssets.icons.cartBag.svg(color: Colors.white),
                          SizedBox(width: 10.w),
                          Text(
                            "اضف للسلة",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ).container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.mainColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuantityButton({
    required BuildContext context,
    required IconData icon,
    required dynamic onTap,
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
