import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../../core/utils/extensions_app/html/html_extensions.dart'
    show HtmlStringExtension;

class DescriptionTab extends StatelessWidget {
  final dynamic description;

  const DescriptionTab({super.key, required this.description});
  @override
  Widget build(BuildContext context) {
    final text = description?.toString().plainText ?? '';
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Html(data: text),
    );
  }
}
