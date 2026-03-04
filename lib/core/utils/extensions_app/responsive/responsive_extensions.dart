import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../context/context_extensions.dart';

extension ResponsiveExtensions on BuildContext {
  // Grid Logic helper
  int get gridColumnCount {
    final w = MediaQuery.of(this).size.width;
    if (w < 600) return 2;
    if (w < 900) return 3;
    if (w < 1200) return 4;
    return 6;
  }

  // Sidebar Width helper for Categories
  double get sidebarWidth {
    if (isPhone) return 90.w;
    if (isTablet) return 150.w;
    return 200.w;
  }

  // Adaptive Value (Non-linear scaling)
  double adaptive(double mobile, {double? tablet, double? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? mobile * 1.5;
    if (isTablet) return tablet ?? mobile * 1.25;
    return mobile;
  }

  // Responsive Layout Helper
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }
}

extension WidgetResponsive on Widget {
  /// Makes a widget responsive by constraining its width based on device type
  Widget constrained([double maxWidth = 1200]) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: this,
      ),
    );
  }

  /// Adds responsive padding that grows with screen size
  Widget responsivePadding(BuildContext context) {
    final padding = context.isPhone ? 16.w : (context.isTablet ? 32.w : 64.w);
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }
}
