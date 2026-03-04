import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../commonWidget/custom_image.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/routes/app_routes_fun.dart';
import '../../../../../core/utils/extensions_app/padding/padding_extensions.dart';
import '../../../../../gen/locale_keys.g.dart';
import '../../../data/models/models.dart';

class CategoryProductsPreview extends StatelessWidget {
  final CategoryItem category;
  final bool showHeader;
  final List<ProductItem>? products;

  const CategoryProductsPreview({
    super.key,
    required this.category,
    this.showHeader = true,
    this.products,
  });

  @override
  Widget build(BuildContext context) {
    final displayProducts = (products ?? category.products.items).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.localizedName,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ).paddingOnly(left: 16.w, right: 16.w),
              TextButton(
                onPressed: () {
                  push(
                    NamedRoutes.i.productList,
                    arguments: {
                      'categoryUid': category.id.toString(),
                      'categoryName': category.localizedName,
                    },
                  );
                },
                child: Text(
                  LocaleKeys.see_more.tr(),
                  style: TextStyle(fontSize: 12.sp, color: Colors.green),
                ),
              ),
            ],
          ),
        if (showHeader) SizedBox(height: 8.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
          ),
          itemCount: displayProducts.length,
          itemBuilder: (context, index) {
            final product = displayProducts[index];
            return InkWell(
              onTap: () {
                push(
                  NamedRoutes.i.productDetails,
                  arguments: {
                    'sku': product.sku,
                    'name': product.localizedName,
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomImage(
                        product.displayImageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      product.localizedName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        ).paddingOnly(bottom: 16.h, left: 16.w, right: 16.w),
      ],
    );
  }
}
