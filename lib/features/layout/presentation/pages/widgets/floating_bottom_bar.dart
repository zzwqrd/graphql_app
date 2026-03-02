import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../commonWidget/custom_image.dart';
import '../../../../../core/routes/app_routes_fun.dart';
import '../../../../../core/utils/animation_extension.dart';
import '../../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../../../gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class FloatingBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            0,
            MyAssets.icons.homePng.path,
            LocaleKeys.layout_home.tr(),
          ),
          _buildNavItem(
            1,
            MyAssets.icons.categoryPng.path,
            LocaleKeys.layout_categories.tr(),
          ),
          _buildNavItem(
            2,
            MyAssets.icons.cartBag.path,
            LocaleKeys.layout_cart.tr(),
          ),
          _buildNavItem(
            3,
            MyAssets.icons.profilePng.path,
            LocaleKeys.layout_account.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuad,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? navigatorKey.currentContext!.mainColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),

        width: isSelected ? 80.w : 50.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                child: CustomImage(
                  iconPath,
                  width: 16.w,
                  color: isSelected
                      ? const Color(0xFFffffff)
                      : navigatorKey.currentContext!.mainColor,
                ),
              ),
            ),

            if (isSelected)
              label
                  .withStyle(
                    color: const Color(0xFFffffff),
                    fontSize: _changeFontSizeLanguage(),
                    fontWeight: FontWeight.bold,
                  )
                  .opacityIn(duration: const Duration(milliseconds: 800))
                  .paddingSymmetric(horizontal: 3.h)
                  .center,
          ],
        ).paddingSymmetric(vertical: 12.h),
      ),
    );
  }
}

double _changeFontSizeLanguage() {
  if (navigatorKey.currentContext?.locale.languageCode == 'ar') {
    return 12.sp;
  } else {
    return 7.sp;
  }
}
