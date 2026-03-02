import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../di/service_locator.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../commonWidget/custom_image.dart';
import '../controller/address_cubit.dart';
import '../controller/address_state.dart';
import '../widgets/add_address_button.dart';
import '../widgets/empty_address_state.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../../domain/entities/address_entity.dart';

/// Profile Address View - Refactored with Clean Architecture
class ProfileAddressView extends StatelessWidget {
  const ProfileAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddressCubit>()..getAddresses(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<AddressCubit, AddressState>(
          listener: (context, state) {
            // Show success message
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: const Color(0xFF4CAF50),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              );
              context.read<AddressCubit>().clearSuccessMessage();
            }

            // Show error message
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: const Color(0xFFE53935),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              );
              context.read<AddressCubit>().clearErrorMessage();
            }
          },
          builder: (context, state) {
            // Loading state
            if (state.getAddressesState == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Empty state
            if (state.addresses.isEmpty) {
              return EmptyAddressState(
                onAddAddress: () => _navigateToAddAddress(context),
              );
            }

            // Addresses list
            return SingleChildScrollView(
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
                        AddAddressButton(
                          onTap: () => _navigateToAddAddress(context),
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
                    itemCount: state.addresses.length,
                    itemBuilder: (context, index) {
                      final address = state.addresses[index];
                      return _AddressItemCard(
                        address: address,
                        onEdit: () => _editAddress(context, address),
                        onDelete: () => _deleteAddress(context, address),
                      );
                    },
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToAddAddress(BuildContext context) async {
    final result = await push(NamedRoutes.i.addPickLocation);
    if (result != null && result is AddressEntity) {
      if (context.mounted) {
        context.read<AddressCubit>().addAddress(result);
      }
    }
  }

  void _editAddress(BuildContext context, AddressEntity address) async {
    final result = await push(
      NamedRoutes.i.addPickLocation,
      arguments: address,
    );
    if (result != null && result is AddressEntity) {
      if (context.mounted) {
        context.read<AddressCubit>().updateAddress(result);
      }
    }
  }

  void _deleteAddress(BuildContext context, AddressEntity address) {
    showDeleteConfirmationDialog(
      context: context,
      addressLabel: address.label,
      onConfirm: () {
        if (address.id != null) {
          context.read<AddressCubit>().deleteAddress(address.id!);
        }
      },
    );
  }
}

/// Address Item Card Widget
class _AddressItemCard extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressItemCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  String _getIcon() {
    if (address.label == 'Home') return MyAssets.icons.homeSvg.path;
    if (address.label == 'Work' || address.label == 'Office') {
      return MyAssets.icons.work.path;
    }
    return MyAssets.icons.other.path;
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
                  MyAssets.icons.menuLocation.path,
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
                  address.label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  address.formattedAddress,
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
                      MyAssets.icons.menuEdit.path,
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
                      MyAssets.icons.delete.path,
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
