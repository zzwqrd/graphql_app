import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/product_model.dart';

class FilterModal extends StatelessWidget {
  final List<Aggregation> aggregations;
  final Map<String, List<String>> initialFilters;
  final Function(Map<String, List<String>>) onApply;

  const FilterModal({
    super.key,
    required this.aggregations,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    if (aggregations.isEmpty) {
      return Container(
        height: 200.h,
        color: Colors.white,
        child: const Center(child: Text('No filters available')),
      );
    }

    // Initialize state variables for StatefulBuilder
    Map<String, List<String>> selectedFilters = Map.from(initialFilters);
    // Ensure lists are mutable
    for (var key in selectedFilters.keys) {
      selectedFilters[key] = List.from(selectedFilters[key]!);
    }
    int selectedAggregationIndex = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: 0.8.sh, // Take up 80% of screen height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedFilters.clear();
                        });
                      },
                      child: Text(
                        'مسح',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ),
                    Text(
                      'تصفية',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Body
              Expanded(
                child: Row(
                  children: [
                    // Categories List (Right Side)
                    Container(
                      width: 120.w,
                      color: Colors.grey[100],
                      child: ListView.builder(
                        itemCount: aggregations.length,
                        itemBuilder: (context, index) {
                          final agg = aggregations[index];
                          final isSelected = selectedAggregationIndex == index;
                          final hasFilter =
                              selectedFilters.containsKey(agg.attributeCode) &&
                              selectedFilters[agg.attributeCode]!.isNotEmpty;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedAggregationIndex = index;
                              });
                            },
                            child: Container(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[100],
                              padding: EdgeInsets.symmetric(
                                vertical: 16.h,
                                horizontal: 12.w,
                              ),
                              child: Row(
                                children: [
                                  if (hasFilter)
                                    Container(
                                      width: 6.w,
                                      height: 6.w,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0057b7),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  if (hasFilter) SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      agg.label,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? const Color(0xFF0057b7)
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Options List (Left Side)
                    Expanded(
                      child: ListView.builder(
                        itemCount: aggregations[selectedAggregationIndex]
                            .options
                            .length,
                        itemBuilder: (context, index) {
                          final option = aggregations[selectedAggregationIndex]
                              .options[index];
                          final attributeCode =
                              aggregations[selectedAggregationIndex]
                                  .attributeCode;
                          final isChecked =
                              selectedFilters[attributeCode]?.contains(
                                option.value,
                              ) ??
                              false;

                          return CheckboxListTile(
                            value: isChecked,
                            activeColor: const Color(0xFF0057b7),
                            title: Text(
                              "${option.label} (${option.count})",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  if (!selectedFilters.containsKey(
                                    attributeCode,
                                  )) {
                                    selectedFilters[attributeCode] = [];
                                  }
                                  selectedFilters[attributeCode]!.add(
                                    option.value,
                                  );
                                } else {
                                  selectedFilters[attributeCode]?.remove(
                                    option.value,
                                  );
                                  if (selectedFilters[attributeCode]?.isEmpty ??
                                      false) {
                                    selectedFilters.remove(attributeCode);
                                  }
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Footer
              Padding(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onApply(selectedFilters);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0057b7),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'تطبيق',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
