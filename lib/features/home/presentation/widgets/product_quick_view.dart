import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../core/general_bloc/generic_cubit.dart';
import '../../../../core/utils/flash_helper.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../commonWidget/textwidget.dart';
import '../../../../core/auth/auth_manager.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../core/utils/extensions_app/html/html_extensions.dart';
import '../../../../di/service_locator.dart';
import '../../../product_details/presentation/controller/controller.dart';
import '../../../product_details/presentation/controller/state.dart';
import '../../../product_details/presentation/pages/widgets/bottom_action_bar.dart';

class ProductQuickView extends StatelessWidget {
  final String sku;
  final String productName;

  const ProductQuickView({
    super.key,
    required this.sku,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    final isGuest = AuthManager.isGuest;
    final GenericBloc<int> quantity = GenericBloc(1);
    return BlocProvider(
      create: (context) => sl<ProductDetailsCubit>()..getProductDetails(sku),
      child: Stack(
        children: [
          // Semi-transparent background overlay
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 1.0, end: 0.0),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    value * MediaQuery.of(context).size.height * 0.85,
                  ),
                  child: child,
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Close Button
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    // Content
                    Expanded(
                      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                        builder: (context, state) {
                          if (state.requestState == RequestState.loading) {
                            return _buildShimmerLoading();
                          } else if (state.requestState == RequestState.error) {
                            return Center(child: Text(state.msg));
                          } else if (state.product == null) {
                            return const Center(
                              child: Text('المنتج غير موجود'),
                            );
                          }

                          final product = state.product!;

                          return SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Image & Info Row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product Image
                                    Container(
                                      width: 100.w,
                                      height: 100.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            product.displayImageUrl.isNotEmpty
                                                ? product.displayImageUrl
                                                : '',
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),

                                    // Product Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Product Name
                                          Text(
                                            product.name,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8.h),

                                          // Unit
                                          Text(
                                            'Kilogram',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          SizedBox(height: 12.h),

                                          // Price
                                          Row(
                                            children: [
                                              if (product
                                                      .priceRange
                                                      .minimumPrice
                                                      .regularPrice
                                                      .value !=
                                                  product
                                                      .priceRange
                                                      .minimumPrice
                                                      .finalPrice
                                                      .value)
                                                Text(
                                                  '\$${product.priceRange.minimumPrice.regularPrice.value.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                '\$${product.priceRange.minimumPrice.finalPrice.value.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: context.mainColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24.h),

                                // Quantity Section
                                Text(
                                  ':الكمية',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 12.h),

                                // Quantity Controls
                                BlocBuilder(
                                  bloc: quantity,
                                  builder: (context, state) {
                                    return Row(
                                      children: [
                                        Row(
                                          children: [
                                            _buildQuantityButton(
                                              context: context,
                                              icon: Icons.remove,
                                              onTap: quantity.state.data > 1
                                                  ? () {
                                                      quantity.onUpdateData(
                                                        quantity.state.data - 1,
                                                      );
                                                    }
                                                  : null,
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              '${quantity.state.data}',
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
                                                quantity.onUpdateData(
                                                  quantity.state.data + 1,
                                                );
                                              },
                                            ),
                                          ],
                                        ).container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 7.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: context.grayColor
                                                .withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                        ),
                                        if (product.stockStatus == "instock")
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(12.w),
                                              decoration: BoxDecoration(
                                                color: Colors.green[50],
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                    );
                                  },
                                ),
                                SizedBox(height: 24.h),

                                // Action Buttons
                                BlocBuilder(
                                  bloc: quantity,
                                  builder: (context, state) {
                                    return Row(
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: BottomActionBarNew(
                                            quantity: quantity.state.data,
                                            isOutOfStock:
                                                product.stockStatus ==
                                                'OUT_OF_STOCK',
                                            product: product.toProductModel(),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Flexible(
                                          flex: 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (isGuest) {
                                                FlashHelper.showToast(
                                                  "يجب عليك تسجيل الدخول اولا",
                                                );
                                              } else {
                                                FlashHelper.showToast(
                                                  "تمت إضافة المنتج إلى المفضلة",
                                                  type: MessageTypeTost.success,
                                                );
                                              }
                                              // setState(() {
                                              //   isFavorite = !isFavorite;
                                              // });
                                            },
                                            child: Container(
                                              height: 50.h,
                                              // width: 50.w,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.08),
                                                    spreadRadius: 0.2,
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.grey,
                                                    size: 24.sp,
                                                  ).px1,
                                                  "المفضلة"
                                                      .h6WithoutStyle(
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                      .px1,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 24.h),

                                // Description
                                if (product.description.isNotEmpty) ...[
                                  HtmlWidget(product.description.fullPlainText),
                                  SizedBox(height: 24.h),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: context.mainColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(icon, size: 12.sp, color: context.white),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Info & Image Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Shimmer
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 150.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: 100.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: 120.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Quantity Title
            Container(
              width: 80.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 12.h),

            // Quantity Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Buttons
            Row(
              children: [
                Container(
                  width: 60.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Description Lines
            ...List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Container(
                  width: double.infinity,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
