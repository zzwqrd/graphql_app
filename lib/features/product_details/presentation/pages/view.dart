import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../core/utils/extensions_app/html/html_extensions.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/utils/enums.dart';
import '../controller/controller.dart';
import '../controller/state.dart';
import 'widgets/bottom_action_bar.dart';
import 'widgets/description_tab.dart';
import 'widgets/image_slider.dart';
import 'widgets/product_info.dart';
import 'widgets/reviews_tab.dart';
import '../../../../commonWidget/shimmer/product_details_shimmer.dart';
import '../../../../commonWidget/app_app_bar.dart';
import '../../../../commonWidget/responsive_layout.dart';
import '../../../../gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductDetailsView extends StatelessWidget {
  final String sku;
  final String productName;

  const ProductDetailsView({
    super.key,
    required this.sku,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductDetailsCubit>()..getProductDetails(sku),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppAppBar(
          title: LocaleKeys.product_details_page_title.tr(),
          actions: [
            IconButton(
              icon: Icon(Icons.share, color: context.mainColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite_border, color: context.mainColor),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
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

            final product = state.product!;

            return Column(
              children: [
                Expanded(
                  child: ResponsiveLayout(
                    mobile: _buildMobileLayout(context, product),
                    tablet: _buildTabletLayout(context, product),
                  ),
                ),
                BottomActionBar(
                  isOutOfStock: product.stockStatus == 'OUT_OF_STOCK',
                  product: product.toProductModel(),
                ).constrained(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, dynamic product) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageSlider(images: product.mediaGallery),
          SizedBox(height: 16.h),
          ProductInfo(product: product),
          SizedBox(height: 24.h),
          _buildTabs(context, product),
        ],
      ),
    ).constrained().responsivePadding(context);
  }

  Widget _buildTabletLayout(BuildContext context, dynamic product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: ImageSlider(images: product.mediaGallery),
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductInfo(product: product),
                SizedBox(height: 24.h),
                _buildTabs(context, product),
              ],
            ),
          ),
        ),
      ],
    ).constrained().responsivePadding(context);
  }

  Widget _buildTabs(BuildContext context, dynamic product) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: context.mainColor,
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            indicatorColor: context.mainColor,
            tabs: [
              Tab(text: LocaleKeys.product_details_description_tab.tr()),
              Tab(text: LocaleKeys.product_details_reviews_tab.tr()),
            ],
          ),
          SizedBox(
            height: 400.h, // Adjusted height for better content visibility
            child: TabBarView(
              children: [
                DescriptionTab(
                  description: product.description?.toString().plainText,
                ),
                ReviewsTab(product: product),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
