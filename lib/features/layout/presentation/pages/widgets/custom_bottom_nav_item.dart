// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../../../commonWidget/custom_image.dart';
// import '../../../../../core/utils/app_colors.dart';
// import '../../../../../core/utils/extensions.dart';
// import '../../../../../di/service_locator.dart';
// import '../../../../../gen/assets.gen.dart';
// import '../../controller/controller.dart';
// import '../../controller/state.dart';

// BottomNavigationBarItem buildBottomNavigationBarItem({
//   String? label,
//   required String icon,
//   required bool isActive,
// }) {
//   return BottomNavigationBarItem(
//     label: label ?? "",
//     icon: Container(
//       decoration: BoxDecoration(
//         // color: isActive ? Colors.blue : Colors.transparent,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 9.8),
//       child: Image(image: AssetImage(icon), width: 25),
//     ),
//     activeIcon: Container(
//       decoration: BoxDecoration(
//         // color: Colors.blue,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 9.8),
//       child: Image(image: AssetImage(icon), width: 25),
//     ),
//   );
// }

// Widget buildNavItem({
//   required BuildContext context,
//   required int index,
//   required dynamic icon,
//   required dynamic tittle,
//   required bool isActive,
// }) {
//   return Expanded(
//     child: GestureDetector(
//       onTap: () => sl<LayoutCubit>().changeBottomNavIndex(index),
//       // child: Icon(
//       //   icon,
//       //   color: isActive == true ? AppColors.accentColor : Colors.grey,
//       // ),
//       child: Column(
//         children: [
//           CustomImage(
//             icon.toString(),
//             width: 22.w,
//             // fit: BoxFit.contain,
//             color: isActive == true
//                 ? AppColors.primaryColor
//                 : AppColors.deSelectedColor.withOpacity(0.5),
//           ).withPadding(vertical: 3.h),
//           Text(
//             tittle!,
//             maxLines: 1,
//             style: TextStyle(
//               fontSize: 10.sp,
//               color: isActive
//                   ? AppColors.primaryColor
//                   : AppColors.deSelectedColor,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// class BottomNavItem extends StatelessWidget {
//   final String? imageData;
//   final String? tittle;
//   final VoidCallback? onTap;
//   final bool isSelected;
//   final int index;
//   const BottomNavItem({
//     super.key,
//     this.imageData,
//     this.tittle,
//     this.onTap,
//     this.index = 0,
//     this.isSelected = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: InkWell(
//         // onTap: onTap,
//         onTap: () => sl<LayoutCubit>().changeBottomNavIndex(index),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SvgPicture.asset(
//               imageData!,
//               colorFilter: ColorFilter.mode(
//                 isSelected ? AppColors.primaryColor : AppColors.deSelectedColor,
//                 BlendMode.srcIn,
//               ),
//               width: 20.w,
//             ).withPadding(vertical: 3.h),
//             Text(
//               tittle!,
//               maxLines: 1,
//               style: TextStyle(
//                 fontSize: 10.sp,
//                 color: isSelected
//                     ? AppColors.primaryColor
//                     : AppColors.deSelectedColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget buildCustomBottomNavigationBar(BuildContext context, LayoutState state) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       buildNavItem(
//         context: context,
//         tittle: "Home",
//         index: 0,
//         icon: state.currentIndex == 0
//             ? MyAssets.icons.homePng.path
//             : MyAssets.icons.homeActive.path,
//         isActive: state.currentIndex == 0,
//       ),
//       buildNavItem(
//         tittle: "Category",
//         context: context,
//         index: 1,
//         icon: state.currentIndex == 1
//             ? MyAssets.icons.categoryPng.path
//             : MyAssets.icons.categoryActive.path,
//         isActive: state.currentIndex == 1,
//       ),
//       const Expanded(child: SizedBox()),
//       buildNavItem(
//         context: context,
//         tittle: "Wishlist",
//         index: 3,
//         icon: state.currentIndex == 3
//             ? MyAssets.icons.wishlistPng.path
//             : MyAssets.icons.wishlistActive.path,
//         isActive: state.currentIndex == 3,
//       ),
//       buildNavItem(
//         context: context,
//         tittle: "Profile",
//         index: 4,
//         icon: state.currentIndex == 4
//             ? MyAssets.icons.profilePng.path
//             : MyAssets.icons.profileActive.path,
//         isActive: state.currentIndex == 4,
//       ),
//     ],
//   );
// }
