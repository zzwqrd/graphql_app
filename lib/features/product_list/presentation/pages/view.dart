import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../commonWidget/custom_image.dart';
import '../../../../commonWidget/app_app_bar.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/utils/enums.dart';
import '../../../home/presentation/widgets/product.dart';
import '../../data/models/product_model.dart';
import '../controller/controller.dart';
import '../controller/state.dart';
import '../../../../commonWidget/shimmer/product_shimmer.dart';
import '../../../../commonWidget/shimmer/product_grid_item_shimmer.dart';

import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/routes/routes.dart';
import '../../../../commonWidget/app_custom_form.dart';
import 'widgets/filter_sort_bottom_sheet.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({
    super.key,
    required this.categoryUid,
    required this.categoryName,
    this.initialSort,
  });

  final String categoryUid;
  final String categoryName;
  final SortOption? initialSort;

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ProductListCubit>()
            ..getProducts(widget.categoryUid, initialSort: widget.initialSort),
      child: _ProductListBody(
        categoryUid: widget.categoryUid,
        categoryName: widget.categoryName,
        initialSort: widget.initialSort,
      ),
    );
  }
}

class _ProductListBody extends StatelessWidget {
  final String categoryUid;
  final String categoryName;
  final SortOption? initialSort;

  const _ProductListBody({
    required this.categoryUid,
    required this.categoryName,
    this.initialSort,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppAppBar(
            title: categoryName,
            actions: [
              CustomImage(
                MyAssets.icons.filter.path,
                height: 24.h,
                width: 24.w,
                color: context.mainColor,
              ).inkWell(
                onTap: () {
                  _showFilterSortSheet(context, state);
                },
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: AppCustomForm(
                      hintText: LocaleKeys.product_list_search_placeholder.tr(),
                      onChanged: (value) {
                        context.read<ProductListCubit>().search(value);
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          if (state.requestState == RequestState.loading &&
                              state.allProducts.isEmpty)
                            const Expanded(child: ProductShimmer())
                          else if (state.requestState == RequestState.error &&
                              state.allProducts.isEmpty)
                            Expanded(child: Center(child: Text(state.msg)))
                          else if (state.requestState == RequestState.done &&
                              state.allProducts.isEmpty)
                            Expanded(
                              child: MyAssets.lottie.emptyBox
                                  .lottie(width: 150.w)
                                  .center,
                            )
                          else
                            Expanded(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (scrollInfo) {
                                  if (scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent &&
                                      !state.hasReachedMax &&
                                      state.requestState !=
                                          RequestState.loading) {
                                    context.read<ProductListCubit>().loadMore();
                                  }
                                  return false;
                                },
                                child: CustomScrollView(
                                  slivers: [
                                    SliverPadding(
                                      padding: EdgeInsets.all(5.w),
                                      sliver: SliverGrid(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  context.gridColumnCount,
                                              childAspectRatio: 0.62,
                                              crossAxisSpacing: 10.w,
                                              mainAxisSpacing: 16.h,
                                            ),
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            if (index >=
                                                state
                                                    .displayedProducts
                                                    .length) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            final product =
                                                state.displayedProducts[index];

                                            return ProductWidget(
                                              product: product,
                                              onCardTap: () {
                                                push(
                                                  NamedRoutes.i.productDetails,
                                                  arguments: {
                                                    'sku': product.sku,
                                                    'name': product.name,
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          childCount:
                                              state.displayedProducts.length,
                                        ),
                                      ),
                                    ),
                                    if (state.requestState ==
                                            RequestState.loading &&
                                        state.allProducts.isNotEmpty)
                                      SliverToBoxAdapter(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.w),
                                          child: Row(
                                            children: List.generate(
                                              context.gridColumnCount,
                                              (index) => Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                  ),
                                                  child:
                                                      const ProductGridItemShimmer(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ).constrained().responsivePadding(context);
            },
          ),
        );
      },
    );
  }

  void _showFilterSortSheet(BuildContext context, ProductListState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FilterSortBottomSheet(
        currentSort: state.sortOption,
        aggregations: state.aggregations,
        activeFilters: state.activeFilters,
        onApply: (sort, filters) {
          final cubit = context.read<ProductListCubit>();
          if (sort != null && sort != state.sortOption) {
            cubit.sort(sort);
          }
          if (filters != state.activeFilters) {
            cubit.filter(filters);
          }
        },
      ),
    );
  }
}
