import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../commonWidget/custom_image.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../gen/assets.gen.dart';

import '../../../../commonWidget/devider.dart';
import '../../../../core/auth/auth_manager.dart';
import '../../../../core/routes/routes.dart';
import '../widgets/menu_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isGuest = AuthManager.isGuest;

    return Column(
      children: [
        CustomImage(MyAssets.icons.menuProfile.path, height: 50, width: 50)
            .container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.mainColor),
              ),
            )
            .pt6,

        if (isGuest)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              children: [
                Text(
                  'تسجيل الدخول لرؤية معلوماتك',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: context.mainColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Sign In Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => push(NamedRoutes.i.login),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.mainColor,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Register Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigate to register screen when available
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: BorderSide(color: context.mainColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'التسجيل',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: context.mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ).px4,
              ],
            ),
          ),

        if (!isGuest) ...[
          MenuWidget(
            text: "حسابي".tr(),
            icon: MyAssets.icons.menuProfile.path,
            onTap: () => push(NamedRoutes.i.account),
          ),

          const DeviderWidget(),

          MenuWidget(
            text: "عناويني",
            icon: MyAssets.icons.menuLocation.path,
            onTap: () => push(NamedRoutes.i.profileAddress),
          ),
          const DeviderWidget(),
        ],
        const DeviderWidget(),

        MenuWidget(
          text: "تاريخ الطلبات",
          icon: MyAssets.icons.menuBag.path,
          onTap: () => push(NamedRoutes.i.orderHistory),
        ),
        MenuWidget(
          text: "تغيير اللغة",
          icon: MyAssets.icons.language.path,
          onTap: () => push(NamedRoutes.i.changeLanguage),
        ),
        const DeviderWidget(),

        if (!isGuest) ...[
          MenuWidget(
            text: "تعديل الحساب",
            icon: MyAssets.icons.menuEdit.path,
            onTap: () {},
          ),
          const DeviderWidget(),

          MenuWidget(
            text: "تغيير كلمة المرور",
            icon: MyAssets.icons.menuKey.path,
            onTap: () {},
          ),
          const DeviderWidget(),

          MenuWidget(
            text: "تسجيل الخروج",
            icon: MyAssets.icons.menuLogout.path,
            onTap: () => _handleLogout(context),
          ),
        ],
      ],
    ).px4;
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthManager.logout();
      if (context.mounted) {
        pushAndRemoveUntil(NamedRoutes.i.layout);
      }
    }
  }
}
