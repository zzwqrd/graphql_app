import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// My Location Button Widget
/// FAB for getting current location
class MyLocationButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const MyLocationButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.white,
      onPressed: isLoading ? null : onTap,
      child: isLoading
          ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(Icons.my_location, color: Theme.of(context).primaryColor),
    );
  }
}
