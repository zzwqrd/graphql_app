import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/routes/app_routes_fun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../commonWidget/custom_image.dart';
import '../core/routes/routes.dart';
import '../core/utils/extensions_app/extensions_init.dart';
import '../gen/assets.gen.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    this.onTap,
    this.svgIcon,
    this.title,
    required this.isSearch,
    this.favoritesIcon,
  });

  final void Function()? onTap;
  final String? svgIcon;
  final String? title;
  final bool? isSearch;
  final String? favoritesIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.backgroundColorApp,
      elevation: 0,
      toolbarHeight: 48.h,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          CustomImage(MyAssets.icons.logo.path, width: 73.w),
          Text(
            title ?? "",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: context.mainColor,
            ),
          ).px3,
        ],
      ),
      actions: [
        if (favoritesIcon != null)
          FaIcon(
            FontAwesomeIcons.solidHeart,
            size: 20.w,
            color: context.mainColor,
          ).inkWell(
            onTap: () {
              push(NamedRoutes.i.wishlistView);
            },
          ),
        if (isSearch == true && svgIcon != null)
          Padding(
            padding: EdgeInsets.only(right: 16.w, left: 16.w),
            child: CustomImage(svgIcon!, width: 20.w, color: context.mainColor)
                .inkWell(
                  onTap: () {
                    push(NamedRoutes.i.searchView);
                  },
                ),
          ),
      ],
    );
  }
}
