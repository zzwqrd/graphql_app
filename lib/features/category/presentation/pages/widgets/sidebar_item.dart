import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../commonWidget/custom_image.dart';
import '../../../../../core/utils/extensions_app/extensions_init.dart';

class SidebarItem extends StatelessWidget {
  final int index;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? imageUrl;

  const SidebarItem({
    super.key,
    required this.index,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80.h,
        color: isSelected
            ? context.mainColor.withValues(alpha: 0.1)
            : Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.mainColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: imageUrl != null
                        ? CustomImage(
                            imageUrl!,
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          )
                        : Icon(
                            Icons.eco,
                            color: isSelected ? context.mainColor : Colors.grey,
                            size: 24,
                          ),
                  ),
                  label.textCatogory(
                    color: isSelected ? context.mainColor : Colors.grey,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 4.w, color: context.mainColor),
              ),
          ],
        ),
      ),
    );
  }
}
