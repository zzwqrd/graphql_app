import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonWidget/custom_image.dart';
import '../../../../commonWidget/textwidget.dart';
import '../../../../core/utils/extensions_app/color/color_extensions.dart';
import '../../../../gen/assets.gen.dart';
import '../../../order_history/data/models/order_model.dart'; // Import OrderModel

class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key, required this.order});
  final OrderModel order; // Use OrderModel

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate or show details
      },
      child: Stack(
        children: [
          Container(
            height: 191.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: context.black.withOpacity(0.04),
                  offset: const Offset(0, 0),
                  blurRadius: 10.r,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: '#${order.orderNumber}', // orderNumber
                    color: context.textColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  TextWidget(
                    text: order.createdAt, // createdAt
                    color: context.deSelectedColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: 'معلومات: ',
                        color: context.textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      TextWidget(
                        text:
                            '${order.totalItemCount} المنتج', // totalItemCount
                        color: context.textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: 'حالة التوصيل: ',
                        color: context.textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      TextWidget(
                        text: order.status, // status
                        color: _getDeliveryStatusColor(order.status, context),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: 'حالة الدفع: ',
                        color: context.textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      // Payment status logic placeholder
                      _buildPaymentStatus(context),
                    ],
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: 'المجموع: ',
                        color: context.textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      TextWidget(
                        text:
                            '\$${order.grandTotal.toStringAsFixed(2)}', // grandTotal
                        color: context.textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16
                .w, // Assuming LTR/RTL handled by directionality or fixed logic
            top: 16.h,
            child: Container(
              height: 30.h,
              width: 30.w,
              decoration: BoxDecoration(
                color: context.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: context.primaryColor.withOpacity(0.25),
                    offset: const Offset(0, 6),
                    blurRadius: 15.r,
                  ),
                ],
              ),
              child: Center(
                child: CustomImage(
                  MyAssets.icons.eye.path, // Assuming you have this icon
                  color: Colors.white,
                  height: 20.h,
                  width: 20.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatus(BuildContext context) {
    // Placeholder logic since we don't have payment_status from API yet
    // Based on grandTotal > 0 or status? Assuming "Not Paid" for now or based on status
    String statusText = 'لم يتم الدفع';
    bool isPaid = false;
    if (order.status.toLowerCase() == 'complete') {
      statusText = 'تم الدفع';
      isPaid = true;
    }

    return Container(
      decoration: BoxDecoration(
        color: _getPaymentStatusColor(statusText, context),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.r),
        child: Wrap(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: TextWidget(
                  text: statusText,
                  color: _getPaymentStatusTextColor(statusText, context),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getDeliveryStatusColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'pending':
        return context.pendingColor;
      case 'on the way':
        return context.onthewayColor;
      case 'returned':
        return context.redColor2;
      case 'complete':
      case 'completed':
        return Colors.green; // Assuming logic
      default:
        return context.black;
    }
  }

  Color? _getPaymentStatusColor(String status, BuildContext context) {
    if (status == 'تم الدفع') {
      return context.paidColor;
    } else {
      return context.unpaidColor;
    }
  }

  Color? _getPaymentStatusTextColor(String status, BuildContext context) {
    if (status == 'تم الدفع') {
      return context.mainColor;
    } else {
      return context.redColor2;
    }
  }
}
