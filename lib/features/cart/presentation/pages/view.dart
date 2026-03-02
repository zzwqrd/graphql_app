import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/utils/extensions_app/color/color_extensions.dart';
import '../../../../core/utils/extensions_app/widget/widget_extensions.dart';
import '../../../../commonWidget/app_field.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart'
    show PaddingExtensions, AlignmentExtensions;
import '../../../../core/utils/enums.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/controller.dart';
import '../controller/state.dart';
import '../widgets/cart_item_widget.dart';
import '../../../../di/service_locator.dart';
import '../../../../commonWidget/shimmer/cart_shimmer.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartCubit = sl<CartCubit>();
    return BlocConsumer<CartCubit, CartState>(
      bloc: cartCubit..getCart(),
      buildWhen: (previous, current) =>
          previous.requestState != current.requestState ||
          previous.updateCount != current.updateCount ||
          previous.removeFromCart != current.removeFromCart ||
          previous.addToCart != current.addToCart,
      listener: (context, state) {},
      builder: (context, state) {
        return Builder(
          builder: (context) {
            if (state.requestState == RequestState.loading &&
                state.items.isEmpty) {
              return const CartShimmer();
            }

            final items = state.items;
            final totalAmount = state.totalAmount;
            final updatingItemId = state.itemId;

            if (items.isEmpty && state.requestState != RequestState.loading) {
              return MyAssets.lottie.emptyBox.lottie(width: 150.w).center;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 15.h),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return AbsorbPointer(
                        absorbing:
                            state.updateCount == RequestState.loading ||
                            state.removeFromCart == RequestState.loading,
                        child:
                            CartItemWidget(
                              item: item,
                              isLoading:
                                  (state.updateCount == RequestState.loading ||
                                      state.removeFromCart ==
                                          RequestState.loading) &&
                                  updatingItemId == item.id,
                              onIncrement: () {
                                context.read<CartCubit>().updateQuantity(
                                  item.id,
                                  item.quantity + 1,
                                );
                              },
                              onDecrement: () {
                                context.read<CartCubit>().updateQuantity(
                                  item.id,
                                  item.quantity - 1,
                                );
                              },
                              onDelete: () {
                                context.read<CartCubit>().removeFromCart(
                                  item.id,
                                );
                              },
                            ).inkWell(
                              onTap: () {
                                push(
                                  NamedRoutes.i.productDetails,
                                  arguments: {
                                    'sku': item.product.sku,
                                    'name': item.product.name,
                                  },
                                );
                              },
                            ),
                      );
                    },
                  ),
                ),
                _buildOrderSummary(
                  context,
                  totalAmount,
                  state.updateCount == RequestState.loading ||
                      state.removeFromCart == RequestState.loading,
                  items,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    double totalAmount,
    bool isUpdating,
    List<dynamic> items,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppCustomForm(
                  hintText: "اكتب كود الخصم",
                  controller: TextEditingController(text: ""),
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: context.mainColor,
                  border: Border.all(color: context.mainColor),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    "تفعيل",
                    style: TextStyle(
                      color: context.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ).pb5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع الفرعي (${items.length} منتج)',
                style: TextStyle(fontSize: 12.sp),
              ),
              Text(
                'EGP ${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: context.mainColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المجموع شامل الضريبة', style: TextStyle(fontSize: 12.sp)),
              Text(
                'EGP ${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: context.mainColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  push(NamedRoutes.i.shippingInformation);
                },
                child: Container(
                  height: 50.h,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: context.mainColor,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child:
                      state.requestState == RequestState.loading &&
                          state.itemId ==
                              null // General loading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'EGP ${totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'إتمام الشراء',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '(${items.length} منتج)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ],
      ).paddingOnly(bottom: 80),
    );
  }
}
