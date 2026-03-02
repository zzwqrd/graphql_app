import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/utils/extensions_app/color/color_extensions.dart';
import '../../../../core/utils/enums.dart'; // RequestState
import '../../../../core/utils/flash_helper.dart'; // FlashHelper
import '../../../../di/service_locator.dart';
import '../../../my_account/presentation/widgets/order_widget.dart';
import '../controller/controller.dart';
import '../controller/state.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderHistoryController>()..getOrders(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          appBar: AppBar(title: const Text('تاريخ الطلبات')),
          body: BlocConsumer<OrderHistoryController, OrderHistoryState>(
            listener: (context, state) {
              if (state.requestState == RequestState.error) {
                // Handle error
                FlashHelper.showToast(
                  state.errorMessage,
                  type: MessageTypeTost.fail,
                );
              }
            },
            builder: (context, state) {
              if (state.requestState == RequestState.loading &&
                  state.orders.isEmpty) {
                return Center(
                  child: SpinKitFadingCircle(color: context.primary),
                );
              }

              return RefreshIndicator(
                color: context.mainColor, // or context.primary
                onRefresh: () async {
                  await context.read<OrderHistoryController>().getOrders(
                    refresh: true,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      Expanded(
                        child: state.orders.isEmpty
                            ? Center(
                                child: Text(
                                  'لا توجد طلبات',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: state.orders.length,
                                shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(), // Allow scrolling if needed inside Expanded
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: OrderWidget(
                                      order: state.orders[index],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
