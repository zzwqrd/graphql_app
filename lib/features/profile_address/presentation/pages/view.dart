import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/app_routes_fun.dart';

import '../../../../commonWidget/custom_image.dart';
import '../../../../core/routes/routes.dart';
import '../../../../gen/assets.gen.dart';

// ==================== 1. ADDRESS ITEM CARD COMPONENT ====================

class AddressItemCard extends StatelessWidget {
  final String label;
  final String address;
  final String? apartment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String homeIcon;
  final String workIcon;
  final String otherIcon;
  final String locationIcon;
  final String editIcon;
  final String deleteIcon;

  const AddressItemCard({
    super.key,
    required this.label,
    required this.address,
    this.apartment,
    required this.onEdit,
    required this.onDelete,
    required this.homeIcon,
    required this.workIcon,
    required this.otherIcon,
    required this.locationIcon,
    required this.editIcon,
    required this.deleteIcon,
  });

  String _getIcon() {
    if (label == 'Home') return homeIcon;
    if (label == 'Work' || label == 'Office') return workIcon;
    return otherIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      padding: EdgeInsets.all(12.r),
      height: 90.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Icons Column (Left)
          SizedBox(
            width: 40.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomImage(
                  _getIcon(),
                  width: 20.w,
                  height: 20.h,
                  fit: BoxFit.contain,
                ),
                CustomImage(
                  locationIcon,
                  width: 20.w,
                  height: 20.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Address Details (Center)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  apartment != null && apartment!.isNotEmpty
                      ? '$apartment, $address'
                      : address,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF757575),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Actions Column (Right)
          SizedBox(
            width: 40.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Edit Button
                InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: CustomImage(
                      editIcon,
                      width: 20.w,
                      height: 20.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Delete Button
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: CustomImage(
                      deleteIcon,
                      width: 20.w,
                      height: 20.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 2. ADD NEW ADDRESS BUTTON ====================

class AddNewAddressButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color primaryColor;

  const AddNewAddressButton({
    super.key,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFD3FFE5),
          borderRadius: BorderRadius.circular(17.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle, size: 18.sp, color: primaryColor),
            SizedBox(width: 6.w),
            Text(
              'إضافة جديدة',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 3. EMPTY STATE COMPONENT ====================

class EmptyAddressState extends StatelessWidget {
  final VoidCallback onAddAddress;

  const EmptyAddressState({super.key, required this.onAddAddress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 80.sp,
              color: const Color(0xFFBDBDBD),
            ),
            SizedBox(height: 16.h),
            Text(
              'لا توجد عناوين',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF212121),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'قم بإضافة عنوان التوصيل الخاص بك',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF757575),
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onAddAddress,
              icon: const Icon(Icons.add),
              label: const Text('إضافة عنوان'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showDeleteConfirmationDialog({
  required BuildContext context,
  required String addressLabel,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        'حذف العنوان',
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
      ),
      content: Text(
        'هل أنت متأكد من حذف عنوان "$addressLabel"؟',
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF757575)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF757575)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(
            'حذف',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFFE53935),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

// ==================== 5. PROFILE ADDRESS VIEW (MAIN SCREEN) ====================

class ProfileAddressView extends StatefulWidget {
  const ProfileAddressView({super.key});

  @override
  State<ProfileAddressView> createState() => _ProfileAddressViewState();
}

class _ProfileAddressViewState extends State<ProfileAddressView> {
  // Sample data - استبدلها بالـ data الحقيقية
  List<Map<String, dynamic>> addresses = [
    {
      'label': 'Home',
      'address': 'Mirpur 2, Dhaka Bangladesh, 239',
      'apartment': 'Apartment 5A',
    },
    {
      'label': 'Work',
      'address': 'Gulshan 1, Dhaka Bangladesh, 696',
      'apartment': null,
    },
    {
      'label': 'Other',
      'address': 'Dhanmondi 15, Dhaka Bangladesh, 1209',
      'apartment': 'House 25',
    },
  ];

  void _addNewAddress() {
    push(NamedRoutes.i.addPickLocation);
  }

  void _editAddress(int index) {
    // TODO: Navigate to edit address screen
    print('Edit address: ${addresses[index]['label']}');
    // Navigator.push(context, MaterialPageRoute(builder: (_) => EditAddressScreen(address: addresses[index])));
  }

  void _deleteAddress(int index) {
    showDeleteConfirmationDialog(
      context: context,
      addressLabel: addresses[index]['label'],
      onConfirm: () {
        setState(() {
          addresses.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم حذف العنوان بنجاح'),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: addresses.isEmpty
          ? EmptyAddressState(onAddAddress: _addNewAddress)
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header with Title and Add Button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'عناويني',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        AddNewAddressButton(
                          onTap: _addNewAddress,
                          primaryColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Address List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return AddressItemCard(
                        label: address['label'],
                        address: address['address'],
                        apartment: address['apartment'],
                        onEdit: () => _editAddress(index),
                        onDelete: () => _deleteAddress(index),
                        // استخدم الـ assets paths بتوعك
                        homeIcon: MyAssets.icons.homeSvg.path,
                        workIcon: MyAssets.icons.work.path,
                        otherIcon: MyAssets.icons.other.path,
                        locationIcon: MyAssets.icons.menuLocation.path,
                        editIcon: MyAssets.icons.menuEdit.path,
                        deleteIcon: MyAssets.icons.delete.path,
                      );
                    },
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
    );
  }
}
