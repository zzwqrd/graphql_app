import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/flash_helper.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../cart/presentation/controller/controller.dart';
import '../../../cart/presentation/controller/state.dart';
import '../../../../core/utils/enums.dart';
import '../../../../di/service_locator.dart';
import '../widgets/delivery_pickup_toggle.dart';
import '../widgets/address_card_item.dart';
import '../widgets/action_button.dart';
import '../widgets/coupon_section.dart';
import '../widgets/order_summary_section.dart';
import '../../../profile_address/domain/entities/address_entity.dart';

class ShippingInformationView extends StatefulWidget {
  const ShippingInformationView({super.key});

  @override
  State<ShippingInformationView> createState() =>
      _ShippingInformationViewState();
}

class _ShippingInformationViewState extends State<ShippingInformationView> {
  // State variables
  bool isDelivery = true;
  int selectedAddressIndex = -1;
  bool isCouponApplied = false;
  double savedAmount = 0.0;

  // Addresses list - will be populated from map selection
  List<Map<String, dynamic>> addresses = [];

  @override
  Widget build(BuildContext context) {
    final cartCubit = sl<CartCubit>();

    return BlocBuilder<CartCubit, CartState>(
      bloc: cartCubit,
      builder: (context, cartState) {
        // Get cart data
        final cartItems = cartState.items;
        final subtotal = cartState.totalAmount;
        final tax = subtotal * 0.1; // 10% tax
        final shippingCharge = isDelivery ? 0.0 : 0.0;
        final discount = isCouponApplied ? savedAmount : 0.0;
        final total = subtotal + tax + shippingCharge - discount;

        // Check if cart is empty
        if (cartItems.isEmpty &&
            cartState.requestState != RequestState.loading) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1F1F39)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'معلومات الشحن',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F1F39),
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Color(0xFF6E7191),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'السلة فارغة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F1F39),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'أضف منتجات للمتابعة',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6E7191)),
                  ),
                ],
              ),
            ),
          );
        }

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1F1F39)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'معلومات الشحن',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F1F39),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery/Pickup Toggle
                    DeliveryPickupToggle(
                      isDelivery: isDelivery,
                      onToggle: (value) {
                        setState(() {
                          isDelivery = value;
                          selectedAddressIndex = -1;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Address section header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isDelivery ? 'عنوان التوصيل' : 'نقطة الاستلام',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F1F39),
                          ),
                        ),
                        Row(
                          children: [
                            if (selectedAddressIndex != -1)
                              ActionButton.edit(
                                onTap: () {
                                  _navigateToAddAddress(
                                    editMode: true,
                                    existingAddress:
                                        addresses[selectedAddressIndex],
                                  );
                                },
                              ),
                            if (selectedAddressIndex != -1)
                              const SizedBox(width: 8),
                            ActionButton.add(
                              onTap: () {
                                _navigateToAddAddress();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Address list
                    if (addresses.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEFF0F6)),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 48,
                              color: Color(0xFF6E7191),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isDelivery
                                  ? 'لم تقم بإضافة عنوان بعد'
                                  : 'لم تقم بتحديد نقطة استلام بعد',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6E7191),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () {
                                _navigateToAddAddress();
                              },
                              icon: const Icon(
                                Icons.add_location_alt,
                                color: Color(0xFF01BE5F),
                              ),
                              label: const Text(
                                'إضافة عنوان من الخريطة',
                                style: TextStyle(
                                  color: Color(0xFF01BE5F),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          return AddressCardItem(
                            label: addresses[index]['label'] ?? 'موقع',
                            address: addresses[index]['address']!,
                            isSelected: selectedAddressIndex == index,
                            onTap: () {
                              setState(() {
                                selectedAddressIndex = index;
                              });
                            },
                          );
                        },
                      ),

                    const SizedBox(height: 24),

                    // Divider
                    const Divider(color: Color(0xFFEFF0F6), thickness: 1),

                    const SizedBox(height: 24),

                    // Coupon section
                    CouponSection(
                      isApplied: isCouponApplied,
                      savedAmount: savedAmount,
                      onTap: () {
                        _showCouponBottomSheet();
                      },
                      onRemove: () {
                        setState(() {
                          isCouponApplied = false;
                          savedAmount = 0.0;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Order summary
                    OrderSummarySection(
                      subtotal: subtotal,
                      tax: tax,
                      shippingCharge: shippingCharge,
                      discount: discount,
                      total: total,
                      onCheckout: () {
                        if (addresses.isEmpty) {
                          FlashHelper.showToast(
                            'الرجاء إضافة عنوان من الخريطة',
                          );
                          return;
                        }
                        if (selectedAddressIndex == -1) {
                          FlashHelper.showToast('الرجاء اختيار عنوان التوصيل');
                          return;
                        }

                        final selectedAddress = addresses[selectedAddressIndex];

                        // Validate Email Presence
                        if (selectedAddress['email'] == null ||
                            selectedAddress['email'].toString().isEmpty) {
                          FlashHelper.showToast(
                            'الرجاء تحديث العنوان لإضافة البريد الإلكتروني',
                            type: MessageTypeTost.fail,
                          );
                          _navigateToAddAddress(
                            editMode: true,
                            existingAddress: selectedAddress,
                          );
                          return;
                        }

                        FlashHelper.showToast('جاري الانتقال للدفع...');

                        // Navigate to checkout
                        push(
                          NamedRoutes.i.checkout,
                          arguments: {
                            'isDelivery': isDelivery,
                            'shippingAddressId': selectedAddress['id']
                                ?.toString(),
                            'billingAddressId': selectedAddress['id']
                                ?.toString(),
                            'outletId': null,
                            // Pass address details
                            'addressStreet':
                                selectedAddress['address'] ?? 'General Street',
                            'addressCity': selectedAddress['city'] ?? 'Riyadh',
                            'addressRegion':
                                selectedAddress['region'] ?? 'Riyadh',
                            'addressPostcode':
                                selectedAddress['postcode'] ?? '11111',
                            'addressTelephone':
                                selectedAddress['telephone'] ?? '0500000000',
                            'addressEmail': selectedAddress['email'],
                            'addressFirstname':
                                selectedAddress['firstname'] ?? 'Guest',
                            'addressLastname':
                                selectedAddress['lastname'] ?? 'User',
                          },
                        );
                      },
                      warningMessage: addresses.isEmpty
                          ? 'الرجاء إضافة عنوان من الخريطة للمتابعة'
                          : (selectedAddressIndex == -1
                                ? 'الرجاء اختيار عنوان التوصيل للمتابعة'
                                : null),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToAddAddress({
    bool editMode = false,
    Map<String, dynamic>? existingAddress,
  }) async {
    // Convert Map to AddressEntity for editing
    AddressEntity? entity;
    if (existingAddress != null) {
      entity = AddressEntity(
        id: existingAddress['id'],
        label: existingAddress['label'] ?? 'Home',
        street: existingAddress['street'] ?? '',
        apartment: existingAddress['apartment'],
        floor: existingAddress['floor'],
        building: existingAddress['building'],
        city: existingAddress['city'],
        country: existingAddress['country_code'],
        region: existingAddress['region'],
        postcode: existingAddress['postcode'],
        telephone: existingAddress['telephone'],
        email: existingAddress['email'],
        latitude: (existingAddress['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (existingAddress['longitude'] as num?)?.toDouble() ?? 0.0,
        isDefault: existingAddress['isDefault'] ?? false,
      );
    }

    // Navigate to AddPickLocationView
    final result = await push(
      NamedRoutes.i.addPickLocation,
      arguments: entity != null ? {'existingAddress': entity} : null,
    );

    // Handle returned address
    if (result != null && mounted) {
      // Check if result is AddressEntity
      if (result is AddressEntity) {
        setState(() {
          if (editMode && existingAddress != null) {
            // Update existing address
            final index = addresses.indexOf(existingAddress);
            if (index != -1) {
              addresses[index] = {
                'id': result.id,
                'label': result.label,
                'address': result.formattedAddress,
                'street': result.street,
                'apartment': result.apartment,
                'floor': result.floor,
                'building': result.building,
                'city': result.city,
                'country_code': result.country,
                'region': result.region,
                'postcode': result.postcode,
                'telephone': result.telephone,
                'email': result.email,
                'latitude': result.latitude,
                'longitude': result.longitude,
                'firstname': 'Test',
                'lastname': 'Mobile',
              };
            }
          } else {
            // Add new address
            addresses.add({
              'id': result.id,
              'label': result.label,
              'address': result.formattedAddress,
              'street': result.street,
              'apartment': result.apartment,
              'floor': result.floor,
              'building': result.building,
              'city': result.city,
              'country_code': result.country,
              'region': result.region,
              'postcode': result.postcode,
              'telephone': result.telephone,
              'email': result.email,
              'latitude': result.latitude,
              'longitude': result.longitude,
              'firstname': 'Test',
              'lastname': 'Mobile',
            });
            // Auto-select the newly added address
            selectedAddressIndex = addresses.length - 1;
          }
        });

        if (mounted) {
          FlashHelper.showToast(
            editMode ? 'تم تحديث العنوان بنجاح' : 'تم إضافة العنوان بنجاح',
          );
        }
      }
    }
  }

  void _showCouponBottomSheet() {
    final couponController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أدخل رمز الكوبون',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F1F39),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: couponController,
                decoration: InputDecoration(
                  hintText: 'أدخل الكود هنا',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFEFF0F6)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFEFF0F6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF01BE5F)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (couponController.text.isNotEmpty) {
                      setState(() {
                        isCouponApplied = true;
                        savedAmount = 50.0;
                      });
                      Navigator.pop(context);
                      FlashHelper.showToast('تم تطبيق الكوبون بنجاح');
                    } else {
                      FlashHelper.showToast('الرجاء إدخال رمز الكوبون');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01BE5F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'تطبيق',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
