// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// /// Location Search Dialog
// /// Allows user to search for locations using geocoding
// class LocationSearchDialog extends StatefulWidget {
//   const LocationSearchDialog({super.key});

//   @override
//   State<LocationSearchDialog> createState() => _LocationSearchDialogState();
// }

// class _LocationSearchDialogState extends State<LocationSearchDialog> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Map<String, dynamic>> _searchResults = [];
//   bool _isSearching = false;

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _search(String query) async {
//     if (query.isEmpty || query.length < 3) {
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
//       for (var location in locations.take(5)) {
//         // Limit to 5 results
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
//             'address': address.isEmpty ? 'موقع غير معروف' : address,
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
