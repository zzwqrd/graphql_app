// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../../../core/utils/enums.dart';
// import '../controller/controller.dart';
// import '../controller/state.dart';
// import 'dart:async';

// /// Custom widget for map location picker dialog
// class MapLocationDialog extends StatelessWidget {
//   final Function(double lat, double lng, String address) onLocationSelected;

//   const MapLocationDialog({super.key, required this.onLocationSelected});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => MapLocationCubit()..checkAndRequestPermission(),
//       child: _MapLocationDialogContent(onLocationSelected: onLocationSelected),
//     );
//   }
// }

// class _MapLocationDialogContent extends StatefulWidget {
//   final Function(double lat, double lng, String address) onLocationSelected;

//   const _MapLocationDialogContent({required this.onLocationSelected});

//   @override
//   State<_MapLocationDialogContent> createState() =>
//       _MapLocationDialogContentState();
// }

// class _MapLocationDialogContentState extends State<_MapLocationDialogContent> {
//   GoogleMapController? _mapController;
//   Timer? _debounce;

//   // Default location (can be changed to your preferred default)
//   static const LatLng _defaultLocation = LatLng(24.7136, 46.6753); // Riyadh

//   @override
//   void dispose() {
//     _mapController?.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   void _onCameraMove(CameraPosition position) {
//     // Debounce geocoding requests
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       context.read<MapLocationCubit>().updateCameraPosition(position.target);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.zero,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         color: Colors.white,
//         child: BlocConsumer<MapLocationCubit, MapLocationState>(
//           listener: (context, state) {
//             // Handle permission state
//             if (state.permissionState == RequestState.done &&
//                 state.hasPermission) {
//               // Permission granted, get current location
//               context.read<MapLocationCubit>().getCurrentLocation();
//             }
//           },
//           builder: (context, state) {
//             return Column(
//               children: [
//                 // Header
//                 _buildHeader(context, state),

//                 // Map
//                 Expanded(child: _buildMapContent(context, state)),

//                 // Confirm button
//                 _buildConfirmButton(context, state),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, MapLocationState state) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x0F000000),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () => Navigator.pop(context),
//             ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF7F7F7),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.search,
//                       color: Color(0xFF6E7191),
//                       size: 20,
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: state.addressState == RequestState.loading
//                           ? const Text(
//                               'جاري تحميل العنوان...',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Color(0xFF6E7191),
//                               ),
//                             )
//                           : Text(
//                               state.currentAddress ?? 'Unknown Location Found',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Color(0xFF1F1F39),
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                     ),
//                     const Icon(
//                       Icons.location_on,
//                       color: Color(0xFF01BE5F),
//                       size: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMapContent(BuildContext context, MapLocationState state) {
//     // Show loading while checking permissions
//     if (state.permissionState == RequestState.loading) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(color: Color(0xFF01BE5F)),
//             SizedBox(height: 16),
//             Text(
//               'جاري فحص صلاحيات الموقع...',
//               style: TextStyle(fontSize: 16, color: Color(0xFF1F1F39)),
//             ),
//           ],
//         ),
//       );
//     }

//     // Show error if permission denied
//     if (!state.hasPermission) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.location_off,
//                 size: 80,
//                 color: Color(0xFFFF6262),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'صلاحيات الموقع مطلوبة',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1F1F39),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'يرجى منح التطبيق صلاحيات الوصول للموقع لاستخدام هذه الميزة',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Color(0xFF6E7191)),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<MapLocationCubit>().checkAndRequestPermission();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF01BE5F),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 12,
//                   ),
//                 ),
//                 child: const Text(
//                   'طلب الصلاحيات',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     // Show map
//     final initialPosition = state.selectedPosition ?? _defaultLocation;

//     return Stack(
//       children: [
//         // Google Map
//         GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: initialPosition,
//             zoom: 15,
//           ),
//           onMapCreated: (controller) {
//             _mapController = controller;
//             // Move to current location if available
//             if (state.currentPosition != null) {
//               controller.animateCamera(
//                 CameraUpdate.newLatLng(state.currentPosition!),
//               );
//             }
//           },
//           onCameraMove: _onCameraMove,
//           myLocationEnabled: true,
//           myLocationButtonEnabled: false,
//           zoomControlsEnabled: false,
//           mapToolbarEnabled: false,
//           compassEnabled: false,
//         ),

//         // Center marker
//         Center(
//           child: Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: const Color(0xFF01BE5F),
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Color(0x33000000),
//                   blurRadius: 8,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: const Icon(Icons.location_on, color: Colors.white, size: 32),
//           ),
//         ),

//         // Current location button
//         Positioned(
//           bottom: 100,
//           right: 16,
//           child: FloatingActionButton(
//             backgroundColor: Colors.white,
//             onPressed: () {
//               context.read<MapLocationCubit>().getCurrentLocation();
//               if (state.currentPosition != null) {
//                 _mapController?.animateCamera(
//                   CameraUpdate.newLatLng(state.currentPosition!),
//                 );
//               }
//             },
//             child: state.requestState == RequestState.loading
//                 ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(
//                       color: Color(0xFF01BE5F),
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : const Icon(Icons.my_location, color: Color(0xFF01BE5F)),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildConfirmButton(BuildContext context, MapLocationState state) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x0F000000),
//             blurRadius: 4,
//             offset: Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         top: false,
//         child: SizedBox(
//           width: double.infinity,
//           height: 56,
//           child: ElevatedButton(
//             onPressed:
//                 state.selectedPosition != null && state.currentAddress != null
//                 ? () {
//                     widget.onLocationSelected(
//                       state.selectedPosition!.latitude,
//                       state.selectedPosition!.longitude,
//                       state.currentAddress!,
//                     );
//                     Navigator.pop(context);
//                   }
//                 : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF01BE5F),
//               disabledBackgroundColor: const Color(0xFF01BE5F).withOpacity(0.5),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 0,
//             ),
//             child: const Text(
//               'تأكيد الموقع',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
