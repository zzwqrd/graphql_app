import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Label Selector Widget
/// Allows user to select address label (Home, Work, Other)
class LabelSelectorWidget extends StatelessWidget {
  final String selectedLabel;
  final Function(String) onLabelSelected;

  const LabelSelectorWidget({
    super.key,
    required this.selectedLabel,
    required this.onLabelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'نوع العنوان',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildLabelChip(context, 'Home', 'المنزل'),
            SizedBox(width: 12.w),
            _buildLabelChip(context, 'Work', 'العمل'),
            SizedBox(width: 12.w),
            _buildLabelChip(context, 'Other', 'أخرى'),
          ],
        ),
      ],
    );
  }

  Widget _buildLabelChip(BuildContext context, String value, String label) {
    final isSelected = selectedLabel == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onLabelSelected(value),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF757575),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
