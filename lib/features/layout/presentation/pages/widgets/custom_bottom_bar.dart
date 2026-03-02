// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../../../core/utils/app_colors.dart';
// import '../../../../../../gen/assets.gen.dart';
// import '../../../../../../commonWidget/custom_image.dart';

// class StylishBottomBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const StylishBottomBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 80.h,
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           // Background with curve
//           CustomPaint(size: Size(1.sw, 70.h), painter: BottomBarPainter()),
//           // Icons
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             height: 70.h,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildNavItem(0, MyAssets.icons.homePng.path, 'Home'),
//                 _buildNavItem(1, MyAssets.icons.categoryPng.path, 'Category'),
//                 SizedBox(width: 60.w), // Space for FAB
//                 _buildNavItem(
//                   3,
//                   MyAssets.icons.wishlistPng.path,
//                   'Favorite',
//                 ), // Changed to wishlistPng
//                 _buildNavItem(4, MyAssets.icons.profilePng.path, 'Profile'),
//               ],
//             ),
//           ),
//           // FAB
//           Positioned(
//             top: 0,
//             child: GestureDetector(
//               onTap: () => onTap(2),
//               child: Container(
//                 width: 60.w,
//                 height: 60.w,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryColor,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.primaryColor.withOpacity(0.3),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: CustomImage(
//                     MyAssets.icons.cartBag.path, // Changed to cartBag
//                     color: Colors.white,
//                     width: 24.w,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(int index, String iconPath, String label) {
//     final isSelected = currentIndex == index;
//     return GestureDetector(
//       onTap: () => onTap(index),
//       behavior: HitTestBehavior.opaque,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CustomImage(
//             iconPath,
//             width: 24.w,
//             color: isSelected ? AppColors.primaryColor : Colors.grey,
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? AppColors.primaryColor : Colors.grey,
//               fontSize: 12.sp,
//               fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BottomBarPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     final path = Path();
//     path.moveTo(0, 0);
//     path.lineTo(size.width * 0.35, 0);

//     // Curve for FAB
//     path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
//     path.arcToPoint(
//       Offset(size.width * 0.60, 20),
//       radius: const Radius.circular(30),
//       clockwise: false,
//     );
//     path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);

//     path.lineTo(size.width, 0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();

//     canvas.drawShadow(path, Colors.black.withOpacity(0.1), 10, true);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
