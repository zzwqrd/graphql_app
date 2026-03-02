import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/address_entity.dart';
import 'label_selector_widget.dart';

/// Address Details Bottom Sheet
/// Form for entering apartment, floor, building details
class AddressDetailsBottomSheet extends StatefulWidget {
  final String address;
  final double latitude;
  final double longitude;
  final Function(AddressEntity) onSave;
  final AddressEntity? existingAddress; // For edit mode

  const AddressDetailsBottomSheet({
    super.key,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.onSave,
    this.existingAddress,
  });

  @override
  State<AddressDetailsBottomSheet> createState() =>
      _AddressDetailsBottomSheetState();
}

class _AddressDetailsBottomSheetState extends State<AddressDetailsBottomSheet> {
  late final TextEditingController _apartmentController;
  late final TextEditingController _floorController;
  late final TextEditingController _buildingController;
  late final TextEditingController _telephoneController;
  late final TextEditingController _emailController;
  late String _selectedLabel;

  @override
  void initState() {
    super.initState();
    _apartmentController = TextEditingController(
      text: widget.existingAddress?.apartment,
    );
    _floorController = TextEditingController(
      text: widget.existingAddress?.floor,
    );
    _buildingController = TextEditingController(
      text: widget.existingAddress?.building,
    );
    _telephoneController = TextEditingController(
      text: widget.existingAddress?.telephone,
    );
    _emailController = TextEditingController(
      text: widget.existingAddress?.email,
    );
    _selectedLabel = widget.existingAddress?.label ?? 'Home';
  }

  @override
  void dispose() {
    _apartmentController.dispose();
    _floorController.dispose();
    _buildingController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'تفاصيل العنوان',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF212121),
                ),
              ),
              SizedBox(height: 20.h),

              // Selected Address
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        widget.address,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF212121),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Label Selection
              LabelSelectorWidget(
                selectedLabel: _selectedLabel,
                onLabelSelected: (label) {
                  setState(() => _selectedLabel = label);
                },
              ),
              SizedBox(height: 20.h),

              // Email (Required)
              TextField(
                controller: _emailController,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني (مطلوب)',
                  hintText: '[email protected]',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Apartment
              TextField(
                controller: _apartmentController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: 'رقم الشقة/الجناح',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Floor
              TextField(
                controller: _floorController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: 'الطابق',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Building
              TextField(
                controller: _buildingController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: 'رقم المبنى',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Telephone
              TextField(
                controller: _telephoneController,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'حفظ العنوان',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAddress() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('الرجاء إدخال البريد الإلكتروني'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('الرجاء إدخال بريد إلكتروني صحيح'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final address = AddressEntity(
      id: widget.existingAddress?.id,
      label: _selectedLabel,
      street: widget.address,
      apartment: _apartmentController.text.trim(),
      floor: _floorController.text.trim(),
      building: _buildingController.text.trim(),
      telephone: _telephoneController.text.trim(),
      email: email,
      latitude: widget.latitude,
      longitude: widget.longitude,
      isDefault: widget.existingAddress?.isDefault ?? false,
    );

    widget.onSave(address);
  }
}
