import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/auth/auth_manager.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/utils/flash_helper.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/state.dart';
import '../controller/controller.dart';
import '../widgets/wishlist_item_card.dart';
import '../../../../gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<WishlistCubit>().loadMoreWishlist();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔐 Check if user is guest
    if (AuthManager.isGuest) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(title: Text(LocaleKeys.wishlist_page_title.tr())),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Icon(
                  Icons.favorite_border,
                  size: 80.w,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 24.h),

                // Title
                Text(
                  trValue(
                    ar: 'احفظ منتجاتك المفضلة',
                    en: 'Save your favorites',
                  ),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),

                // Description
                Text(
                  trValue(
                    ar: 'سجل دخول لحفظ المنتجات التي تعجبك\nوالوصول إليها في أي وقت',
                    en: 'Log in to save your favorite products\nand access them anytime',
                  ),
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => push(NamedRoutes.i.login),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      trValue(ar: 'تسجيل الدخول', en: 'Login'),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ✅ Authenticated user - show wishlist
    return BlocProvider.value(
      value: sl<WishlistCubit>()..getWishlist(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(title: Text(LocaleKeys.wishlist_page_title.tr())),
        body: BlocConsumer<WishlistCubit, WishlistState>(
          listener: (context, state) {
            if (state.msg.isNotEmpty) {
              FlashHelper.showToast(state.msg);
            }
          },
          builder: (context, state) {
            if (state.requestState == RequestState.loading &&
                state.wishlist == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.requestState == RequestState.error &&
                state.wishlist == null) {
              return Center(child: Text(state.msg));
            } else if (state.wishlist == null ||
                state.wishlist!.items.isEmpty) {
              return MyAssets.lottie.emptyBox.lottie(width: 150.w).center;
            }

            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount:
                  state.wishlist!.items.length +
                  (state.isPaginationLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.wishlist!.items.length) {
                  // Pagination loading indicator
                  return _buildPaginationLoader();
                }

                final item = state.wishlist!.items[index];
                return WishlistItemCard(item: item);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaginationLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[300]!,
        child: Container(
          height: 120.h,
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
