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
import '../../../../core/utils/flash_helper.dart';

class AddToCartIcon extends StatelessWidget {
  final ProductModel product;
  const AddToCartIcon({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartCubit = sl<CartCubit>();
    return BlocProvider(
      create: (context) => cartCubit,
      child: _AddToCartIconBody(product: product),
    );
  }
}

class _AddToCartIconBody extends StatelessWidget {
  final ProductModel product;

  const _AddToCartIconBody({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (previous, current) =>
          previous.requestState != current.requestState,

      builder: (context, state) {
        bool isLoading = false;
        if (state.requestState == RequestState.loading &&
            state.itemId == product.uid) {
          isLoading = true;
        }

        return InkWell(
          onTap: isLoading
              ? null
              : () {
                  if (product.stockStatus == 'OUT_OF_STOCK') {
                    FlashHelper.showToast(
                      'سنعلمكم عند توفره',
                      type: MessageTypeTost.warning,
                    );
                    return;
                  }
                  context.read<CartCubit>().addToCart(product, 1);
                },
          child: Container(
            width: 50.w,
            height: 50.w,
            decoration: const BoxDecoration(
              // color: Color(0xFF0057b7),
              shape: BoxShape.circle,
            ),
            child: isLoading
                ? MyAssets.lottie.loadingA.lottie(fit: BoxFit.cover).center
                : MyAssets.icons.addToCart
                      .image(width: 22.w, color: Colors.white)
                      .container(
                        padding: EdgeInsets.all(5.w),
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          color: context.mainColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      )
                      .center,
          ),
        );
      },
    );
  }
}
