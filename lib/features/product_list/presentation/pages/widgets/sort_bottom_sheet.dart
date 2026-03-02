import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/models/product_model.dart';

class SortBottomSheet extends StatelessWidget {
  final SortOption? currentSort;
  final Function(SortOption) onSortSelected;

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.product_list_sort_title.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSortOption(
            LocaleKeys.product_list_sort_name_asc.tr(),
            SortOption.nameAsc,
            context,
          ),
          _buildSortOption(
            LocaleKeys.product_list_sort_name_desc.tr(),
            SortOption.nameDesc,
            context,
          ),
          _buildSortOption(
            LocaleKeys.product_list_sort_price_asc.tr(),
            SortOption.priceAsc,
            context,
          ),
          _buildSortOption(
            LocaleKeys.product_list_sort_price_desc.tr(),
            SortOption.priceDesc,
            context,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    String label,
    SortOption option,
    BuildContext context,
  ) {
    final isSelected = currentSort == option;
    return InkWell(
      onTap: () {
        onSortSelected(option);
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFF0057b7) : Colors.black,
              size: 20.sp,
            ),
            SizedBox(width: 16.w),
            Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
