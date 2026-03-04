import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/routes/app_routes_fun.dart';
import '../../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../../gen/locale_keys.g.dart';
import '../../../data/models/models.dart';
import 'category_products_preview.dart';
import 'sub_category_item.dart';

class SubCategorySection extends StatelessWidget {
  final CategoryItem subCategory;
  final List<ProductItem>? fallbackProducts;

  const SubCategorySection({
    super.key,
    required this.subCategory,
    this.fallbackProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subCategory.localizedName,
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
                    'categoryUid': subCategory.id.toString(),
                    'categoryName': subCategory.localizedName,
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
        SizedBox(height: 4.h), // Reduced spacing
        if (subCategory.children.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
            ),
            itemCount: subCategory.children.length,
            itemBuilder: (context, childIndex) {
              return SubCategoryItem(item: subCategory.children[childIndex]);
            },
          )
        else if (subCategory.products.items.isNotEmpty ||
            (fallbackProducts?.isNotEmpty ?? false))
          CategoryProductsPreview(
            category: subCategory,
            showHeader: false,
            products: subCategory.products.items.isNotEmpty
                ? null
                : fallbackProducts,
          )
        else
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              trValue(
                ar: 'لا توجد منتجات في هذا القسم',
                en: 'No items in this section',
              ),
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
