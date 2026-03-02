import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../features/product_list/data/models/product_model.dart';
import '../../../../../gen/locale_keys.g.dart';

class FilterSortBottomSheet extends StatefulWidget {
  final SortOption? currentSort;
  final List<Aggregation> aggregations;
  final Map<String, List<String>> activeFilters;
  final Function(SortOption?, Map<String, List<String>>) onApply;

  const FilterSortBottomSheet({
    super.key,
    this.currentSort,
    required this.aggregations,
    required this.activeFilters,
    required this.onApply,
  });

  @override
  State<FilterSortBottomSheet> createState() => _FilterSortBottomSheetState();
}

class _FilterSortBottomSheetState extends State<FilterSortBottomSheet> {
  late SortOption? _selectedSort;
  late Map<String, List<String>> _selectedFilters;
  bool _isBrandsExpanded = true;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSort;
    _selectedFilters = Map.from(widget.activeFilters);
  }

  void _onSortChanged(SortOption? value) {
    setState(() {
      _selectedSort = value;
    });
  }

  void _onFilterChanged(String attributeCode, String value, bool isSelected) {
    setState(() {
      if (!_selectedFilters.containsKey(attributeCode)) {
        _selectedFilters[attributeCode] = [];
      }

      if (isSelected) {
        _selectedFilters[attributeCode]!.add(value);
      } else {
        _selectedFilters[attributeCode]!.remove(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Find brand aggregation
    final brandAggregation = widget.aggregations.firstWhere(
      (a) =>
          a.attributeCode == 'manufacturer' ||
          a.label.toLowerCase() == 'brand', // Adjust based on your API
      orElse: () => Aggregation(attributeCode: '', label: '', options: []),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Text(
              "تصفية وفرز", // Filter and Sort
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "الفرز حسب", // Sort By
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      _buildSortOption(LocaleKeys.home_new_arrivals.tr(), null),
                      _buildSortOption(
                        LocaleKeys.product_list_sort_price_asc.tr(),
                        SortOption.priceAsc,
                      ),
                      _buildSortOption(
                        LocaleKeys.product_list_sort_price_desc.tr(),
                        SortOption.priceDesc,
                      ),
                      // Add more options if needed
                    ],
                  ),

                  // Brands Section (Manufacturer)
                  if (brandAggregation.options.isNotEmpty)
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: _isBrandsExpanded,
                        onExpansionChanged: (val) =>
                            setState(() => _isBrandsExpanded = val),
                        title: Text(
                          "العلامات التجارية", // Brands
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        children: brandAggregation.options.map((option) {
                          final isSelected =
                              _selectedFilters[brandAggregation.attributeCode]
                                  ?.contains(option.value) ??
                              false;
                          return CheckboxListTile(
                            value: isSelected,
                            activeColor: const Color(0xFF00C853),
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            title: Text(
                              option.label,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.trailing,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool? value) {
                              if (value != null) {
                                _onFilterChanged(
                                  brandAggregation.attributeCode,
                                  option.value,
                                  value,
                                );
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_selectedSort, _selectedFilters);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    "قدم", // Apply
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    backgroundColor: const Color(0xFFF3F3F3),
                  ),
                  child: Text(
                    "إلغاء", // Cancel
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(String label, SortOption? value) {
    return RadioListTile<SortOption?>(
      value: value,
      groupValue: _selectedSort,
      activeColor: const Color(0xFF00C853),
      title: Text(
        label,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
      onChanged: _onSortChanged,
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: EdgeInsets.zero,
    );
  }
}
