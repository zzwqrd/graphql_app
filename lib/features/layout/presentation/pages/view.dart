import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonWidget/appbar.dart';
import '../../../../di/service_locator.dart';

import '../../../../gen/assets.gen.dart';
import 'widgets/floating_bottom_bar.dart';
import '../controller/controller.dart';
import '../controller/state.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = sl<LayoutCubit>();
    // context.locale;
    return BlocBuilder<LayoutCubit, LayoutState>(
      buildWhen: (previous, current) => previous != current,
      bloc: bloc,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
            ),
            child: Scaffold(
              backgroundColor: const Color.fromARGB(255, 238, 238, 238),
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(48.h),
                child: AppBarWidget(
                  isSearch: true,
                  favoritesIcon: MyAssets.icons.favorite.path,
                  svgIcon: MyAssets.icons.search.path,
                  title: bloc.getSelectedTitle(state.currentIndex).toString(),
                  onTap: () {
                    // push(NamedRoutes.error);
                  },
                ),
              ),
              key: ValueKey(context.locale.languageCode),
              extendBody: true,
              body: bloc.currentPage,
              bottomNavigationBar: FloatingBottomBar(
                currentIndex: state.currentIndex,
                onTap: (index) {
                  bloc.changeBottomNavIndex(index);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
