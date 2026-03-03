import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../core/utils/enums.dart';
import '../controller/controller.dart';
import '../controller/state.dart';

class CmsBlockWidget extends StatelessWidget {
  final String identifier;

  const CmsBlockWidget({super.key, required this.identifier});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.cmsBlocksRequestState == RequestState.loading) {
          return const SizedBox.shrink(); // Could add a shimmer here if desired
        }

        if (state.cmsBlocksRequestState == RequestState.done &&
            state.cmsBlocksData != null &&
            state.cmsBlocksData!.items.isNotEmpty) {
          final block = state.cmsBlocksData!.items.firstWhere(
            (item) => item.identifier == identifier,
            orElse: () => state.cmsBlocksData!.items.first,
          );

          if (block.content != null && block.content!.isNotEmpty) {
            return HtmlWidget(
              block.content!,
              textStyle: TextStyle(fontSize: 14.sp),
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
  }
}
