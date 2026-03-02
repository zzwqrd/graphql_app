import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../commonWidget/custom_image.dart';
import '../../../../commonWidget/textwidget.dart';
import '../../../../core/auth/auth_manager.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions_app/color/color_extensions.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/flash_helper.dart';
import '../../../../di/service_locator.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/controller.dart';
import '../controller/state.dart';

class MyAccountView extends StatelessWidget {
  const MyAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Show appropriate view based on auth status
    return BlocProvider(
      create: (context) =>
          sl<MyAccountController>()..getDashboardData(skipIfGuest: true),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          appBar: AppBar(title: const Text('حسابي')),
          body: BlocConsumer<MyAccountController, MyAccountState>(
            listener: (context, state) {
              if (state.requestState == RequestState.error) {
                FlashHelper.showToast(
                  state.errorMessage ?? '',
                  type: MessageTypeTost.fail,
                );
              }
            },
            builder: (context, state) {
              // 👤 Guest User - Show limited view with login prompt
              if (AuthManager.isGuest) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Guest info card
                        Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: context.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: context.black.withOpacity(0.04),
                                offset: Offset(0, 6.r),
                                blurRadius: 32.r,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 64.sp,
                                color: context.primaryColor,
                              ),
                              SizedBox(height: 16.h),
                              TextWidget(
                                text: 'مرحباً بك كزائر',
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: context.textColor,
                              ),
                              SizedBox(height: 8.h),
                              TextWidget(
                                text: 'سجل الدخول للوصول إلى جميع الميزات',
                                fontSize: 14.sp,
                                color: context.deSelectedColor,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20.h),
                              ElevatedButton(
                                onPressed: () => push(NamedRoutes.i.login),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: context.primaryColor,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32.w,
                                    vertical: 12.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: TextWidget(
                                  text: 'تسجيل الدخول',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Order history section for guests
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: 'طلباتك كزائر',
                              color: context.textColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            InkWell(
                              onTap: () {
                                push(NamedRoutes.i.orderHistory);
                              },
                              child: TextWidget(
                                text: 'عرض الكل',
                                color: context.primaryColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        TextWidget(
                          text: 'يمكنك عرض الطلبات التي قمت بتتبعها',
                          fontSize: 14.sp,
                          color: context.deSelectedColor,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // 🔐 Authenticated User - Show full dashboard
              if (state.requestState == RequestState.loading &&
                  state.dashboardData == null) {
                return Center(
                  child: SpinKitFadingCircle(color: context.primary),
                );
              }

              final data = state.dashboardData;
              final totalOrders = data?.totalOrders ?? 0;
              final totalCompleted = data?.totalCompleted ?? 0;
              final totalReturned = data?.totalReturned ?? 0;
              final walletBalance =
                  data?.walletBalance.toStringAsFixed(2) ?? "0.00";

              return RefreshIndicator(
                color: context.primary,
                onRefresh: () async {
                  await context.read<MyAccountController>().getDashboardData();
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 16.h,
                      left: 16.w,
                      right: 16.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatCard(
                              context: context,
                              title: 'مجموع الطلبات',
                              value: '$totalOrders',
                              iconPath: MyAssets.icons.bag2.path,
                              iconColor: context.tealColor,
                              onTap: () {
                                push(NamedRoutes.i.orderHistory);
                              },
                            ),
                            _buildStatCard(
                              context: context,
                              title: 'مجموع المكتملة',
                              value: '$totalCompleted',
                              iconPath: MyAssets.icons.bag3.path,
                              iconColor: context.deepGreenColor,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatCard(
                              context: context,
                              title: 'مجموع المرجعة',
                              value: '$totalReturned',
                              iconPath: MyAssets.icons.refresh.path,
                              iconColor: context.returnColor,
                            ),
                            _buildStatCard(
                              context: context,
                              title: 'رصيد المحفظة',
                              value: walletBalance,
                              iconPath: MyAssets.icons.wallet.path,
                              iconColor: context.blueColor1,
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        // Snippet for order history or link to it
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: 'تاريخ الطلبات',
                              color: context.textColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            InkWell(
                              onTap: () {
                                push(NamedRoutes.i.orderHistory);
                              },
                              child: TextWidget(
                                text: 'عرض الكل',
                                color: context.primaryColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Center(child: Text("انقر فوق عرض الكل لمشاهدة طلباتك")),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required String iconPath,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160.h,
        width: 156.w,
        decoration: BoxDecoration(
          color: context.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: context.black.withOpacity(0.04),
              offset: Offset(0, 6.r),
              blurRadius: 32.r,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.25),
                      offset: const Offset(0, 6),
                      blurRadius: 15.r,
                    ),
                  ],
                ),
                child: Center(
                  child: CustomImage(iconPath, height: 20.h, width: 20.w),
                ),
              ),
              SizedBox(height: 20.h),
              TextWidget(
                text: value,
                color: iconColor,
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 15.h),
              TextWidget(
                text: title,
                color: context.deSelectedColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
