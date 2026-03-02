import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonWidget/custom_image.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';

import '../../../../core/routes/routes.dart';
import '../controller/controller.dart';
import '../controller/state.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final categories = state.homeResponse?.categories ?? [];

        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 120.h,
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: 120,
              childAspectRatio: 1.2,
              crossAxisSpacing: 3,
              mainAxisSpacing: 6.3,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return InkWell(
                onTap: () {
                  push(
                    NamedRoutes.i.productList,
                    arguments: {
                      'categoryUid': category.id,
                      'categoryName': category.name,
                    },
                  );
                },
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffF7F7FC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.mainColor.withOpacity(0.3),
                      width: 0.3,
                    ),
                  ),
                  child: Column(
                    spacing: 2,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImage(
                        category.displayImageUrl,
                        height: 35.h,
                        width: 45.w,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        category.name,
                        style: TextStyle(
                          color: context.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ).center,
                    ],
                  ).paddingSymmetric(vertical: 12.h, horizontal: 2.w),
                ).paddingSymmetric(vertical: 12.h, horizontal: 2.w),
              );
            },
          ),
        );
      },
    );
  }
}

// class CategoryWidget extends StatelessWidget {
//   const CategoryWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 120.h,
//       width: double.infinity,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         shrinkWrap: true,
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Center(
//             child: InkWell(
//               onTap: () {},
//               child: Container(
//                 height: 84.h,
//                 width: 84.w,
//                 decoration: BoxDecoration(
//                   color: Color(0xffF7F7FC),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     top: 12.h,
//                     bottom: 12.h,
//                     left: 2.w,
//                     right: 2.w,
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CachedNetworkImage(
//                         imageUrl:
//                             'https://greenup.com.sa/media/catalog/product/cache/62c1f47de9148a103a2c23c9c38ab3f2/p/0/p000431.png',
//                         imageBuilder: (context, imageProvider) => Container(
//                           height: 35.h,
//                           width: 45.w,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(8),
//                               topRight: Radius.circular(8),
//                             ),
//                             image: DecorationImage(
//                               image: imageProvider,
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                         ),
//                       ),
//                       "العبوة الاقتصادية".h6WithoutStyle(
                        // style: TextStyle(
                        //   color: context.black,
                        //   fontSize: 12,
                        //   fontWeight: FontWeight.w600,
                        // ),
//                       ),
//                       // Expanded(
//                       //   child: Container(
//                       //     height: 22.h,
//                       //     width: double.infinity,
//                       //     decoration: BoxDecoration(
//                       //       color: AppColor.whiteColor,
//                       //       borderRadius: BorderRadius.only(
//                       //         bottomLeft: Radius.circular(8.r),
//                       //         bottomRight: Radius.circular(8.r),
//                       //       ),
//                       //     ),
//                       //     child: Center(
//                       //       child:
//                       //     ),
//                       //   ),
//                       // )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ).px2;
//         },
//       ),
//     );
//   }
// }
