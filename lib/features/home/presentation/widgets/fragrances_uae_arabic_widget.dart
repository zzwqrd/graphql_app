import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../core/utils/extensions_app/html/html_extensions.dart';
import '../controller/controller.dart';
import '../controller/state.dart';

class FragrancesUaeArabicWidget extends StatelessWidget {
  final String identifier = 'fragrances-uae-arabic';

  const FragrancesUaeArabicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.craftingMemoriesRequestState == RequestState.loading) {
          return const SizedBox.shrink(); // Could add a shimmer here
        }

        if (state.craftingMemoriesRequestState == RequestState.done &&
            state.craftingMemoriesData?.data != null) {
          try {
            final block = state.craftingMemoriesData!.data!;

            if (block.content != null && block.content!.isNotEmpty) {
              // Extract text from HTML safely - handle Magento's double-escaped HTML
              String rawHtml = block.content!;
              // The inner HTML is escaped (e.g., &lt;h3&gt;). Let's unescape it simply replacing standard entities.
              String unescapedHtml = rawHtml
                  .replaceAll('&lt;', '<')
                  .replaceAll('&gt;', '>')
                  .replaceAll('&quot;', '"')
                  .replaceAll('&amp;', '&');

              String textContent = unescapedHtml.toPlainText();
              // Clean up the string to remove any extra newlines or spaces created by tags
              textContent = textContent.replaceAll(RegExp(r'\n+'), ' ');
              // Remove the 'أكتشف المزيد' text from the main body since we have a dedicated button
              textContent = textContent.replaceAll('أكتشف المزيد', '').trim();

              final sentences = textContent.split('.');
              final firstPart = sentences.isNotEmpty
                  ? '${sentences[0].trim()}.'
                  : '';
              final secondPart = sentences.length > 1
                  ? sentences.sublist(1).join('.').trim()
                  : '';

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(
                    0xffF7F4EF,
                  ), // Light beige background seen in the screenshot
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      firstPart,
                      style: TextStyle(
                        fontFamily: 'CairoBold',
                        fontSize: 20
                            .sp, // Slightly larger to match the screenshot better
                        fontWeight: FontWeight.w700,
                        color: context.black,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (secondPart.isNotEmpty)
                      Text(
                        secondPart,
                        style: TextStyle(
                          fontFamily: 'CairoRegular',
                          fontSize: 18.sp, // Slightly larger
                          color: context.black,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ).pt1,
                    SizedBox(height: 24.h),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xffB58C69),
                          width: 1.0,
                        ), // Brown border, subtle width
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.w),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 50.w,
                          vertical: 12.h,
                        ), // Wider padding
                      ),
                      onPressed: () {
                        // Extracting the link from HTML (optional, or hardcode based on requirement)
                        // For now, redirecting to a generic collection/product list or the URL from the HTML.
                        // url: https://ar-qa.ajmal.com/Crafting-memories
                        push(NamedRoutes.i.productList); // Placeholder route
                      },
                      child: Text(
                        'أكتشف المزيد',
                        style: TextStyle(
                          fontFamily: 'CairoBold',
                          fontSize: 14.sp,
                          color: const Color(0xffB58C69), // Brown text
                        ),
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 24.w, vertical: 32.h),
              );
            }
          } catch (e) {
            // Handle the case where the identifier was not found in the list safely
            return const SizedBox.shrink();
          }
        }

        return const SizedBox.shrink();
      },
    );
  }
}
