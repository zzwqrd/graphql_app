import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login/presentation/pages/view.dart';
import '../../features/change_language/presentation/pages/view.dart';
import '../../features/checkout/presentation/pages/view.dart';
import '../../features/layout/presentation/pages/view.dart';
import '../../features/my_account/presentation/pages/view.dart';
import '../../features/order_history/presentation/pages/view.dart';
import '../../features/product_details/presentation/pages/view.dart';
import '../../features/product_list/presentation/pages/view.dart';
import '../../features/profile_address/presentation/pages/view.dart';
import '../../features/profile_address/presentation/pages/add_pick_location_view.dart';
import '../../features/shipping_information/presentation/pages/view.dart';
import '../../features/splash/presentation/pages/view.dart';
import '../../features/wishlist/presentation/pages/view.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter goRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: NamedRoutes.i.splash,
  routes: [
    GoRoute(
      path: NamedRoutes.i.splash,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: NamedRoutes.i.layout,
      builder: (context, state) => const LayoutView(),
    ),
    GoRoute(
      path: NamedRoutes.i.login,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: NamedRoutes.i.productList,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>? ?? {};
        return ProductListView(
          categoryUid: args['categoryUid'] ?? '',
          categoryName: args['categoryName'] ?? '',
          initialSort: args['initialSort'],
        );
      },
    ),
    GoRoute(
      path: NamedRoutes.i.productDetails,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>? ?? {};
        return ProductDetailsView(
          sku: args['sku'] ?? '',
          productName: args['name'] ?? '',
        );
      },
    ),
    GoRoute(
      path: NamedRoutes.i.wishlistView,
      builder: (context, state) => const WishlistView(),
    ),
    GoRoute(
      path: NamedRoutes.i.account,
      builder: (context, state) => const MyAccountView(),
    ),
    GoRoute(
      path: NamedRoutes.i.orderHistory,
      builder: (context, state) => OrderHistoryView(),
    ),
    GoRoute(
      path: NamedRoutes.i.changeLanguage,
      builder: (context, state) => const ChangeLanguageView(),
    ),
    GoRoute(
      path: NamedRoutes.i.shippingInformation,
      builder: (context, state) => const ShippingInformationView(),
    ),
    GoRoute(
      path: NamedRoutes.i.checkout,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return CheckoutView(
          isDelivery: args?['isDelivery'] ?? true,
          shippingAddressId: args?['shippingAddressId'],
          billingAddressId: args?['billingAddressId'],
          outletId: args?['outletId'],
          addressStreet: args?['addressStreet'],
          addressCity: args?['addressCity'],
          addressRegion: args?['addressRegion'],
          addressPostcode: args?['addressPostcode'],
          addressTelephone: args?['addressTelephone'],
          addressFirstname: args?['addressFirstname'],
          addressLastname: args?['addressLastname'],
        );
      },
    ),
    GoRoute(
      path: NamedRoutes.i.profileAddress,
      builder: (context, state) => const ProfileAddressView(),
    ),
    // GoRoute(
    //   path: NamedRoutes.i.addPickLocation,
    //   builder: (context, state) {
    //     final args = state.extra as Map<String, dynamic>?;
    //     if (args != null) {
    //       final existingAddress = args['existingAddress'];
    //       if (existingAddress != null) {
    //         return AddPickLocationView(existingAddress: existingAddress);
    //       }
    //     }
    //     return const AddPickLocationView();
    //   },
    // ),
    // Account routes - mapped if they were used, currently just mapping the main ones visible in existing logic
    // You can add nested routes here if desired structure changes.
  ],
);
