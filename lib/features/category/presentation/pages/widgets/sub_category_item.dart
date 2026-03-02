import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../commonWidget/custom_image.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/routes/app_routes_fun.dart';
import '../../../data/models/models.dart';

class SubCategoryItem extends StatelessWidget {
  final CategoryItem item;

  const SubCategoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        push(
          NamedRoutes.i.productList,
          arguments: {
            'categoryUid': item.id.toString(),
            'categoryName': item.name,
          },
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CustomImage(item.displayImageUrl, fit: BoxFit.contain),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.sp, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
