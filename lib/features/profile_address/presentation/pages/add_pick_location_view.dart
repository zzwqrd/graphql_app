// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import '../../domain/entities/address_entity.dart';
// import '../widgets/map_view_widget.dart';
// import '../widgets/location_search_bar.dart';
// import '../widgets/my_location_button.dart';
// import '../widgets/confirm_location_button.dart';
// import '../widgets/address_details_bottom_sheet.dart';
// import '../widgets/location_search_dialog.dart';

// /// Add/Pick Location View - Refactored with Custom Widgets
// class AddPickLocationView extends StatefulWidget {
//   final AddressEntity? existingAddress; // For edit mode

//   const AddPickLocationView({super.key, this.existingAddress});

//   @override
//   State<AddPickLocationView> createState() => _AddPickLocationViewState();
// }

// class _AddPickLocationViewState extends State<AddPickLocationView> {
//   // GoogleMapController? _mapController;
//   // LatLng _currentPosition = const LatLng(30.0444, 31.2357); // Cairo default
//   String _selectedAddress = "جاري تحديد الموقع...";
//   bool _isLoading = true;
//   bool _isLoadingAddress = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.existingAddress != null) {
//       // Edit mode - use existing address
//       _currentPosition = LatLng(
//         widget.existingAddress!.latitude,
//         widget.existingAddress!.longitude,
//       );
//       _selectedAddress = widget.existingAddress!.street;
//       _isLoading = false;
//     } else {
//       // Add mode - get current location
//       _getCurrentLocation();
//     }
//   }

//   @override
//   void dispose() {
//     _mapController?.dispose();
//     super.dispose();
//   }

//   /// Get Current Location
//   Future<void> _getCurrentLocation() async {
//     try {
//       setState(() => _isLoading = true);

//       // Check permission
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         _showPermissionDialog();
//         setState(() => _isLoading = false);
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
//       _mapController?.animateCamera(
//         CameraUpdate.newLatLngZoom(_currentPosition, 16),
//       );

//       // Get address
//       await _getAddressFromLatLng(_currentPosition);

//       setState(() => _isLoading = false);
//     } catch (e) {
//       print('Error getting location: $e');
//       setState(() {
//         _isLoading = false;
//         _selectedAddress = "فشل تحديد الموقع";
//       });
//     }
//   }

//   /// Get Address from Coordinates (Reverse Geocoding)
//   Future<void> _getAddressFromLatLng(LatLng position) async {
//     try {
//       setState(() => _isLoadingAddress = true);

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

//   void _onCameraIdle() {
//     _getAddressFromLatLng(_currentPosition);
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

//   Future<void> _showSearchDialog() async {
//     final result = await showDialog<LatLng>(
//       context: context,
//       builder: (context) => const LocationSearchDialog(),
//     );

//     if (result != null) {
//       setState(() {
//         _currentPosition = result;
//       });

//       _mapController?.animateCamera(CameraUpdate.newLatLngZoom(result, 16));

//       _getAddressFromLatLng(result);
//     }
//   }

//   void _confirmLocation() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => AddressDetailsBottomSheet(
//         address: _selectedAddress,
//         latitude: _currentPosition.latitude,
//         longitude: _currentPosition.longitude,
//         existingAddress: widget.existingAddress,
//         onSave: (addressEntity) {
//           Navigator.pop(context); // Close bottom sheet
//           Navigator.pop(context, addressEntity); // Return to previous screen
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
//             MapViewWidget(
//               initialPosition: _currentPosition,
//               onCameraMove: _onCameraMove,
//               onCameraIdle: _onCameraIdle,
//               onMapCreated: (controller) {
//                 _mapController = controller;
//               },
//             ),

//             // Center Marker
//             CenterMarkerWidget(isLoading: _isLoadingAddress),

//             // Top Search Bar
//             Positioned(
//               top: 10.h,
//               left: 10.w,
//               right: 10.w,
//               child: LocationSearchBar(
//                 address: _selectedAddress,
//                 onSearch: _showSearchDialog,
//                 onBack: () => Navigator.pop(context),
//               ),
//             ),

//             // My Location Button
//             Positioned(
//               bottom: 160.h,
//               right: 16.w,
//               child: MyLocationButton(
//                 isLoading: _isLoading,
//                 onTap: _getCurrentLocation,
//               ),
//             ),

//             // Confirm Button
//             Positioned(
//               bottom: 16.h,
//               left: 16.w,
//               right: 16.w,
//               child: ConfirmLocationButton(
//                 isLoading: _isLoadingAddress,
//                 onConfirm: _confirmLocation,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
