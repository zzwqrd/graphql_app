import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Location Search Bar Widget
/// Top search bar with back button and address display
class LocationSearchBar extends StatelessWidget {
  final String address;
  final VoidCallback onSearch;
  final VoidCallback onBack;

  const LocationSearchBar({
    super.key,
    required this.address,
    required this.onSearch,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),

          // Search Field
          Expanded(
            child: InkWell(
              onTap: onSearch,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 24.sp, color: Colors.grey),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF212121),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.search, size: 24.sp, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
