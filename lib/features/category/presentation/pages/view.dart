import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../di/service_locator.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/controller.dart';
import '../controller/state.dart';
import 'widgets/all_categories_header.dart';
import 'widgets/selected_category_header.dart';
import 'widgets/sidebar_item.dart';
import 'widgets/sub_category_section.dart';
import '../../../../commonWidget/shimmer/categories_shimmer.dart';
import '../../../../commonWidget/shimmer/product_shimmer.dart';
import '../../../../gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widgets/category_products_preview.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<CategoryCubit>()..getCategories(),
      child: _CategoryBody(),
    );
  }
}

class _CategoryBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final cubit = context.read<CategoryCubit>();
        return BlocBuilder<CategoryCubit, CategoryState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state.requestState == RequestState.loading) {
              return const CategoriesSectionShimmer();
            } else if (state.requestState == RequestState.error) {
              return Center(child: Text(state.msg));
            }

            final categories = state.sidebarCategories;
            final selectedCategory = state.selectedCategory;
            final products = selectedCategory?.products.items ?? [];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: context.sidebarWidth,
                  color: Colors.grey[100],
                  child: Column(
                    children: [
                      const AllCategoriesHeader().py6,
                      Expanded(
                        child: ListView.builder(
                          itemCount: categories.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return SidebarItem(
                              index: index,
                              label: category.name,
                              imageUrl: category.displayImageUrl,
                              isSelected: selectedCategory?.uid == category.uid,
                              onTap: () {
                                cubit.selectCategory(category);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Main Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectedCategoryHeader(
                        categoryName: selectedCategory?.name ?? '',
                        productCount: products.length,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Container(
                          height: 100.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LocaleKeys.category_banner_title.tr(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: context.primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      LocaleKeys.category_banner_subtitle.tr(),
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: context.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Sub-categories List
                      Expanded(
                        child: state.productRequestState == RequestState.loading
                            ? const SingleChildScrollView(
                                child: ProductShimmer(),
                              )
                            : (selectedCategory?.children.isEmpty ?? true)
                            ? (products.isNotEmpty
                                  ? SingleChildScrollView(
                                      child: CategoryProductsPreview(
                                        category: selectedCategory!,
                                      ),
                                    )
                                  : MyAssets.lottie.emptyBox
                                        .lottie(width: 150.w)
                                        .center)
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                itemCount: selectedCategory!.children.length,
                                itemBuilder: (context, index) {
                                  return SubCategorySection(
                                    subCategory:
                                        selectedCategory.children[index],
                                    fallbackProducts: products,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ).constrained().responsivePadding(context);
          },
        );
      },
    );
  }
}
