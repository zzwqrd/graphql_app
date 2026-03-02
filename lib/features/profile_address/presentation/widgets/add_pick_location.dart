// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// // ==================== 1. MAP LOCATION PICKER SCREEN ====================

// class AddPickLocationView extends StatefulWidget {
//   final Map<String, dynamic>? existingAddress;
//   const AddPickLocationView({super.key, this.existingAddress});

//   @override
//   State<AddPickLocationView> createState() => _AddPickLocationViewState();
// }

// class _AddPickLocationViewState extends State<AddPickLocationView> {
//   GoogleMapController? _mapController;
//   LatLng _currentPosition = const LatLng(30.0444, 31.2357); // Cairo default
//   String _selectedAddress = "جاري تحديد الموقع...";
//   bool _isLoading = true;
//   bool _isLoadingAddress = false;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   // ✅ Get Current Location
//   Future<void> _getCurrentLocation() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       // Check permission
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         _showPermissionDialog();
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//       });

//       // Move camera to current location
//       if (_mapController != null) {
//         _mapController!.animateCamera(
//           CameraUpdate.newLatLngZoom(_currentPosition, 16),
//         );
//       }

//       // Get address
//       await _getAddressFromLatLng(_currentPosition);

//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error getting location: $e');
//       setState(() {
//         _isLoading = false;
//         _selectedAddress = "فشل تحديد الموقع";
//       });
//     }
//   }

//   // ✅ Get Address from Coordinates (Reverse Geocoding)
//   Future<void> _getAddressFromLatLng(LatLng position) async {
//     try {
//       setState(() {
//         _isLoadingAddress = true;
//       });

//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         String address = '';

//         if (place.street != null && place.street!.isNotEmpty) {
//           address += place.street!;
//         }
//         if (place.subLocality != null && place.subLocality!.isNotEmpty) {
//           address += address.isEmpty
//               ? place.subLocality!
//               : ', ${place.subLocality!}';
//         }
//         if (place.locality != null && place.locality!.isNotEmpty) {
//           address += address.isEmpty ? place.locality! : ', ${place.locality!}';
//         }
//         if (place.country != null && place.country!.isNotEmpty) {
//           address += address.isEmpty ? place.country! : ', ${place.country!}';
//         }

//         setState(() {
//           _selectedAddress = address.isEmpty ? "موقع غير معروف" : address;
//           _isLoadingAddress = false;
//         });
//       } else {
//         setState(() {
//           _selectedAddress = "موقع غير معروف";
//           _isLoadingAddress = false;
//         });
//       }
//     } catch (e) {
//       print('Error getting address: $e');
//       setState(() {
//         _selectedAddress = "فشل تحديد العنوان";
//         _isLoadingAddress = false;
//       });
//     }
//   }

//   void _onCameraMove(CameraPosition position) {
//     setState(() {
//       _currentPosition = position.target;
//     });
//   }

//   // ✅ Called when camera stops moving
//   void _onCameraIdle() {
//     _getAddressFromLatLng(_currentPosition);
//   }

//   void _goToMyLocation() {
//     _getCurrentLocation();
//   }

//   void _showPermissionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         title: const Text('إذن الموقع مطلوب', textAlign: TextAlign.right),
//         content: const Text(
//           'يجب السماح بالوصول إلى الموقع لاستخدام هذه الميزة',
//           textAlign: TextAlign.right,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Geolocator.openAppSettings();
//             },
//             child: const Text('فتح الإعدادات'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _confirmLocation() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => AddAddressBottomSheet(
//         address: _selectedAddress,
//         latitude: _currentPosition.latitude,
//         longitude: _currentPosition.longitude,
//         onSave: (addressData) {
//           Navigator.pop(context);
//           Navigator.pop(context, addressData);
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Google Map
//             GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: _currentPosition,
//                 zoom: 16,
//               ),
//               zoomControlsEnabled: false,
//               myLocationEnabled: false,
//               myLocationButtonEnabled: false,
//               compassEnabled: false,
//               mapToolbarEnabled: false,
//               onMapCreated: (controller) {
//                 _mapController = controller;
//               },
//               onCameraMove: _onCameraMove,
//               onCameraIdle: _onCameraIdle,
//             ),

//             // Center Marker
//             Center(
//               child: _isLoadingAddress
//                   ? Container(
//                       padding: EdgeInsets.all(12.r),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 8,
//                           ),
//                         ],
//                       ),
//                       child: const CircularProgressIndicator(strokeWidth: 2),
//                     )
//                   : Icon(
//                       Icons.location_on,
//                       size: 50.sp,
//                       color: const Color(0xFF4CAF50),
//                       shadows: [
//                         Shadow(
//                           color: Colors.black.withOpacity(0.3),
//                           blurRadius: 10,
//                         ),
//                       ],
//                     ),
//             ),

//             // Top Search Bar
//             Positioned(
//               top: 10.h,
//               left: 10.w,
//               right: 10.w,
//               child: _buildTopSearchBar(context),
//             ),

//             // My Location Button
//             Positioned(
//               bottom: 160.h,
//               right: 16.w,
//               child: FloatingActionButton(
//                 mini: true,
//                 backgroundColor: Colors.white,
//                 onPressed: _goToMyLocation,
//                 child: _isLoading
//                     ? SizedBox(
//                         width: 20.w,
//                         height: 20.h,
//                         child: const CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : Icon(
//                         Icons.my_location,
//                         color: Theme.of(context).primaryColor,
//                       ),
//               ),
//             ),

//             // Confirm Button
//             Positioned(
//               bottom: 16.h,
//               left: 16.w,
//               right: 16.w,
//               child: _buildConfirmButton(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTopSearchBar(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Back Button
//           IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pop(context),
//           ),

//           // Search Field
//           Expanded(
//             child: InkWell(
//               onTap: () async {
//                 final result = await showDialog<LatLng>(
//                   context: context,
//                   builder: (context) => const LocationSearchDialog(),
//                 );

//                 if (result != null) {
//                   setState(() {
//                     _currentPosition = result;
//                   });

//                   _mapController?.animateCamera(
//                     CameraUpdate.newLatLngZoom(result, 16),
//                   );

//                   _getAddressFromLatLng(result);
//                 }
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//                 child: Row(
//                   children: [
//                     Icon(Icons.location_on, size: 24.sp, color: Colors.grey),
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: Text(
//                         _selectedAddress,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: const Color(0xFF212121),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                     Icon(Icons.search, size: 24.sp, color: Colors.grey),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildConfirmButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 52.h,
//       child: ElevatedButton(
//         onPressed: _isLoadingAddress ? null : _confirmLocation,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _isLoadingAddress
//               ? const Color(0xFFBDBDBD)
//               : const Color(0xFF4CAF50),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(24.r),
//           ),
//           elevation: 0,
//         ),
//         child: Text(
//           'تأكيد الموقع',
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ==================== 2. LOCATION SEARCH DIALOG WITH GOOGLE PLACES ====================

// class LocationSearchDialog extends StatefulWidget {
//   const LocationSearchDialog({super.key});

//   @override
//   State<LocationSearchDialog> createState() => _LocationSearchDialogState();
// }

// class _LocationSearchDialogState extends State<LocationSearchDialog> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Map<String, dynamic>> _searchResults = [];
//   bool _isSearching = false;

//   // ✅ Search using Google Places API
//   Future<void> _search(String query) async {
//     if (query.isEmpty) {
//       setState(() {
//         _searchResults = [];
//       });
//       return;
//     }

//     setState(() {
//       _isSearching = true;
//     });

//     try {
//       // Get coordinates from address
//       List<Location> locations = await locationFromAddress(query);

//       List<Map<String, dynamic>> results = [];
//       for (var location in locations) {
//         // Get detailed address
//         List<Placemark> placemarks = await placemarkFromCoordinates(
//           location.latitude,
//           location.longitude,
//         );

//         if (placemarks.isNotEmpty) {
//           Placemark place = placemarks.first;
//           String address = '';

//           if (place.street != null && place.street!.isNotEmpty) {
//             address += place.street!;
//           }
//           if (place.locality != null && place.locality!.isNotEmpty) {
//             address += address.isEmpty
//                 ? place.locality!
//                 : ', ${place.locality!}';
//           }
//           if (place.country != null && place.country!.isNotEmpty) {
//             address += address.isEmpty ? place.country! : ', ${place.country!}';
//           }

//           results.add({
//             'name': place.name ?? query,
//             'address': address,
//             'latitude': location.latitude,
//             'longitude': location.longitude,
//           });
//         }
//       }

//       setState(() {
//         _searchResults = results;
//         _isSearching = false;
//       });
//     } catch (e) {
//       print('Search error: $e');
//       setState(() {
//         _isSearching = false;
//         _searchResults = [];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
//       child: Container(
//         constraints: BoxConstraints(maxHeight: 500.h),
//         padding: EdgeInsets.all(16.r),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Title
//             Text(
//               'ابحث عن موقع',
//               style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
//             ),
//             SizedBox(height: 16.h),

//             // Search Field
//             TextField(
//               controller: _searchController,
//               autofocus: true,
//               textAlign: TextAlign.right,
//               decoration: InputDecoration(
//                 hintText: 'أدخل اسم المدينة أو العنوان',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//               ),
//               onSubmitted: _search,
//               onChanged: (value) {
//                 if (value.length > 2) {
//                   _search(value);
//                 }
//               },
//             ),
//             SizedBox(height: 16.h),

//             // Loading or Results
//             if (_isSearching)
//               const Center(child: CircularProgressIndicator())
//             else if (_searchResults.isEmpty &&
//                 _searchController.text.isNotEmpty)
//               Padding(
//                 padding: EdgeInsets.all(20.r),
//                 child: Column(
//                   children: [
//                     Icon(Icons.search_off, size: 48.sp, color: Colors.grey),
//                     SizedBox(height: 8.h),
//                     const Text('لم يتم العثور على نتائج'),
//                   ],
//                 ),
//               )
//             else
//               Expanded(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: _searchResults.length,
//                   itemBuilder: (context, index) {
//                     final result = _searchResults[index];
//                     return ListTile(
//                       leading: const Icon(Icons.location_on, color: Colors.red),
//                       title: Text(
//                         result['name'],
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       subtitle: Text(
//                         result['address'],
//                         style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//                       ),
//                       onTap: () {
//                         Navigator.pop(
//                           context,
//                           LatLng(result['latitude'], result['longitude']),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ==================== 3. ADD ADDRESS BOTTOM SHEET ====================

// class AddAddressBottomSheet extends StatefulWidget {
//   final String address;
//   final double latitude;
//   final double longitude;
//   final Function(Map<String, dynamic>) onSave;

//   const AddAddressBottomSheet({
//     super.key,
//     required this.address,
//     required this.latitude,
//     required this.longitude,
//     required this.onSave,
//   });

//   @override
//   State<AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
// }

// class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
//   final TextEditingController _apartmentController = TextEditingController();
//   final TextEditingController _floorController = TextEditingController();
//   final TextEditingController _buildingController = TextEditingController();
//   String _selectedLabel = 'Home';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(20.r),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Title
//               Text(
//                 'تفاصيل العنوان',
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.w700,
//                   color: const Color(0xFF212121),
//                 ),
//               ),
//               SizedBox(height: 20.h),

//               // Selected Address
//               Container(
//                 padding: EdgeInsets.all(12.r),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF5F5F5),
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.location_on,
//                       color: Theme.of(context).primaryColor,
//                       size: 24.sp,
//                     ),
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: Text(
//                         widget.address,
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: const Color(0xFF212121),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),

//               // Label Selection
//               Text(
//                 'نوع العنوان',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   color: const Color(0xFF212121),
//                 ),
//               ),
//               SizedBox(height: 12.h),
//               Row(
//                 children: [
//                   _buildLabelChip('Home', 'المنزل'),
//                   SizedBox(width: 12.w),
//                   _buildLabelChip('Work', 'العمل'),
//                   SizedBox(width: 12.w),
//                   _buildLabelChip('Other', 'أخرى'),
//                 ],
//               ),
//               SizedBox(height: 20.h),

//               // Apartment
//               TextField(
//                 controller: _apartmentController,
//                 textAlign: TextAlign.right,
//                 decoration: InputDecoration(
//                   labelText: 'رقم الشقة/الجناح',
//                   alignLabelWithHint: true,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.h),

//               // Floor
//               TextField(
//                 controller: _floorController,
//                 textAlign: TextAlign.right,
//                 decoration: InputDecoration(
//                   labelText: 'الطابق',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.h),

//               // Building
//               TextField(
//                 controller: _buildingController,
//                 textAlign: TextAlign.right,
//                 decoration: InputDecoration(
//                   labelText: 'رقم المبنى',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24.h),

//               // Save Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 52.h,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     final addressData = {
//                       'label': _selectedLabel,
//                       'address': widget.address,
//                       'apartment': _apartmentController.text,
//                       'floor': _floorController.text,
//                       'building': _buildingController.text,
//                       'latitude': widget.latitude,
//                       'longitude': widget.longitude,
//                     };
//                     widget.onSave(addressData);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).primaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     'حفظ العنوان',
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLabelChip(String value, String label) {
//     final isSelected = _selectedLabel == value;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => _selectedLabel = value),
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 12.h),
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? Theme.of(context).primaryColor
//                 : const Color(0xFFF5F5F5),
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(
//               color: isSelected
//                   ? Theme.of(context).primaryColor
//                   : Colors.transparent,
//             ),
//           ),
//           child: Center(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//                 color: isSelected ? Colors.white : const Color(0xFF757575),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ==================== 4. PROFILE ADDRESS VIEW ====================

// class ProfileAddressView extends StatefulWidget {
//   const ProfileAddressView({super.key});

//   @override
//   State<ProfileAddressView> createState() => _ProfileAddressViewState();
// }

// class _ProfileAddressViewState extends State<ProfileAddressView> {
//   List<Map<String, dynamic>> addresses = [];

//   Future<void> _addNewAddress() async {
//     final result = await Navigator.push<Map<String, dynamic>>(
//       context,
//       MaterialPageRoute(builder: (context) => const AddPickLocationView()),
//     );

//     if (result != null) {
//       setState(() => addresses.add(result));

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('تم إضافة العنوان بنجاح'),
//           backgroundColor: const Color(0xFF4CAF50),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//         ),
//       );
//     }
//   }

//   void _deleteAddress(int index) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         title: const Text('حذف العنوان', textAlign: TextAlign.right),
//         content: Text(
//           'هل أنت متأكد من حذف عنوان "${addresses[index]['label']}"؟',
//           textAlign: TextAlign.right,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() => addresses.removeAt(index));
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('تم حذف العنوان بنجاح')),
//               );
//             },
//             child: const Text('حذف', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: addresses.isEmpty ? _buildEmptyState() : _buildAddressList(),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(32.r),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.location_off_outlined, size: 80.sp, color: Colors.grey),
//             SizedBox(height: 16.h),
//             const Text(
//               'لا توجد عناوين',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
//             ),
//             SizedBox(height: 8.h),
//             const Text(
//               'قم بإضافة عنوان التوصيل الخاص بك',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//             SizedBox(height: 24.h),
//             ElevatedButton.icon(
//               onPressed: _addNewAddress,
//               icon: const Icon(Icons.add),
//               label: const Text('إضافة عنوان'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressList() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.r),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'عناويني',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
//                 ),
//                 GestureDetector(
//                   onTap: _addNewAddress,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 12.w,
//                       vertical: 8.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFD3FFE5),
//                       borderRadius: BorderRadius.circular(17.r),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.add_circle,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         SizedBox(width: 6.w),
//                         const Text('إضافة جديدة'),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: addresses.length,
//             itemBuilder: (context, index) {
//               final address = addresses[index];
//               return Container(
//                 margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                 padding: EdgeInsets.all(12.r),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF5F5F5),
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       address['label'] == 'Home' ? Icons.home : Icons.work,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             address['label'],
//                             style: const TextStyle(fontWeight: FontWeight.w700),
//                           ),
//                           Text(address['address'], maxLines: 2),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => _deleteAddress(index),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
