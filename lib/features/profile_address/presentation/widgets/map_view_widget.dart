// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// /// Map View Widget
// /// Displays Google Map with camera controls
// class MapViewWidget extends StatelessWidget {
//   final LatLng initialPosition;
//   final Function(CameraPosition) onCameraMove;
//   final VoidCallback onCameraIdle;
//   final Function(GoogleMapController) onMapCreated;

//   const MapViewWidget({
//     super.key,
//     required this.initialPosition,
//     required this.onCameraMove,
//     required this.onCameraIdle,
//     required this.onMapCreated,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       initialCameraPosition: CameraPosition(target: initialPosition, zoom: 16),
//       zoomControlsEnabled: false,
//       myLocationEnabled: false,
//       myLocationButtonEnabled: false,
//       compassEnabled: false,
//       mapToolbarEnabled: false,
//       onMapCreated: onMapCreated,
//       onCameraMove: onCameraMove,
//       onCameraIdle: onCameraIdle,
//     );
//   }
// }

// /// Center Marker Widget
// /// Shows marker or loading indicator at map center
// class CenterMarkerWidget extends StatelessWidget {
//   final bool isLoading;

//   const CenterMarkerWidget({super.key, required this.isLoading});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: isLoading
//           ? Container(
//               padding: EdgeInsets.all(12.r),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 8,
//                   ),
//                 ],
//               ),
//               child: const CircularProgressIndicator(strokeWidth: 2),
//             )
//           : Icon(
//               Icons.location_on,
//               size: 50.sp,
//               color: const Color(0xFF4CAF50),
//               shadows: [
//                 Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 10),
//               ],
//             ),
//     );
//   }
// }
