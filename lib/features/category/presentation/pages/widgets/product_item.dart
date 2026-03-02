import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../commonWidget/custom_image.dart';
import '../../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../data/models/models.dart' as model;

class ProductItem extends StatelessWidget {
  final model.ProductItem product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: product.smallImage != null
                ? CustomImage(
                    product.smallImage!,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.contain,
                  )
                : Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.name.textCatogory(color: Colors.grey).py1,
            'SKU: ${product.sku}'.textCatogory(color: Colors.grey).py1,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                '\$25'.h7WithoutStyle(),
                "ADD"
                    .textCatogory(color: context.mainColor)
                    .container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: context.mainColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
              ],
            ),
          ],
        ).paddingAll(8),
      ],
    ).container(decoration: context.productItemDecoration);
  }
}
