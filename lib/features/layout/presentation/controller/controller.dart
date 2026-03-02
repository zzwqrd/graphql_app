import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/presentation/pages/view.dart';
import '../../../category/presentation/pages/view.dart';
import '../../../home/presentation/pages/view.dart';
import '../../../profile/presentation/pages/view.dart';
import 'state.dart';
import '../../../../../../gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutState());

  void changeBottomNavIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Widget get currentPage => getSelectedPage(state.currentIndex);

  dynamic getSelectedTitle(int index) {
    switch (index) {
      case 0:
        return LocaleKeys.layout_home.tr();
      case 1:
        return LocaleKeys.layout_categories.tr();
      case 2:
        return LocaleKeys.layout_cart.tr();
      case 3:
        return LocaleKeys.layout_account.tr();
      default:
        return LocaleKeys.layout_home.tr();
    }
  }

  Widget getSelectedPage(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return CategoryView();
      case 2:
        return CartView();
      case 3:
        return ProfileView();
      default:
        return HomeView();
    }
  }
}
