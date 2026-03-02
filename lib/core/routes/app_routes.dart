// import 'package:flutter/material.dart';

// import '../../features/auth/login/presentation/pages/view.dart';
// import '../../features/change_language/presentation/pages/view.dart';
// import '../../features/checkout/presentation/pages/view.dart';
// import '../../features/layout/presentation/pages/view.dart';
// import '../../features/my_account/presentation/pages/view.dart';
// import '../../features/order_history/presentation/pages/view.dart';
// import '../../features/product_details/presentation/pages/view.dart';
// import '../../features/product_list/presentation/pages/view.dart';
// import '../../features/profile_address/presentation/pages/view.dart';
// import '../../features/profile_address/presentation/pages/add_pick_location_view.dart';
// import '../../features/shipping_information/presentation/pages/view.dart';
// import '../../features/splash/presentation/pages/view.dart';
// import '../../features/wishlist/presentation/pages/view.dart';
// import 'routes.dart';

// class AppRoutes {
//   static AppRoutes get init => AppRoutes._internal();
//   String initial = NamedRoutes.i.splash;
//   AppRoutes._internal();
//   // Map<String, Widget Function(BuildContext c)> appRoutes = {
//   //   NamedRoutes.i.splash: (c) => const SplashView(),
//   //   NamedRoutes.i.layout: (c) => const LayoutView(),
//   //   NamedRoutes.i.login: (c) => const LoginView(),
//   //   NamedRoutes.i.productList: (c) {
//   //     final args = ModalRoute.of(c)!.settings.arguments as Map<String, dynamic>;
//   //     return ProductListView(
//   //       categoryUid: args['categoryUid'],
//   //       categoryName: args['categoryName'],
//   //       initialSort: args['initialSort'],
//   //     );
//   //   },
//   //   NamedRoutes.i.productDetails: (c) {
//   //     final args = ModalRoute.of(c)!.settings.arguments as Map<String, dynamic>;
//   //     return ProductDetailsView(sku: args['sku'], productName: args['name']);
//   //   },
//   //   NamedRoutes.i.wishlistView: (c) => const WishlistView(),
//   //   NamedRoutes.i.account: (c) => const MyAccountView(),
//   //   NamedRoutes.i.orderHistory: (c) => OrderHistoryView(),
//   //   NamedRoutes.i.changeLanguage: (c) => const ChangeLanguageView(),
//   //   NamedRoutes.i.shippingInformation: (c) => const ShippingInformationView(),
//   //   NamedRoutes.i.checkout: (c) {
//   //     final args =
//   //         ModalRoute.of(c)?.settings.arguments as Map<String, dynamic>?;
//   //     return CheckoutView(
//   //       isDelivery: args?['isDelivery'] ?? true,
//   //       shippingAddressId: args?['shippingAddressId'],
//   //       billingAddressId: args?['billingAddressId'],
//   //       outletId: args?['outletId'],
//   //       addressStreet: args?['addressStreet'],
//   //       addressCity: args?['addressCity'],
//   //       addressRegion: args?['addressRegion'],
//   //       addressPostcode: args?['addressPostcode'],
//   //       addressTelephone: args?['addressTelephone'],
//   //       addressFirstname: args?['addressFirstname'],
//   //       addressLastname: args?['addressLastname'],
//   //     );
//   //   },
//   //   NamedRoutes.i.profileAddress: (c) => const ProfileAddressView(),
//   //   NamedRoutes.i.addPickLocation: (c) {
//   //     final args = ModalRoute.of(c)?.settings.arguments;
//   //     if (args != null && args is Map<String, dynamic>) {
//   //       final existingAddress = args['existingAddress'];
//   //       if (existingAddress != null) {
//   //         return AddPickLocationView(existingAddress: existingAddress);
//   //       }
//   //     }
//   //     return const AddPickLocationView();
//   //   },
//   //   // NamedRoutes.i.searchView: (c) => const SearchView(),
//   //   // // Account routes
//   //   // NamedRoutes.i.account: (c) => const AccountView(),
//   //   // NamedRoutes.i.accountOverview: (c) => const OverviewView(),
//   //   // NamedRoutes.i.accountOrders: (c) => const OrderHistoryView(),
//   //   // NamedRoutes.i.accountInfo: (c) => const AccountInfoView(),
//   //   // NamedRoutes.i.accountChangePassword: (c) => const ChangePasswordView(),
//   //   // NamedRoutes.i.accountAddresses: (c) => const AddressListView(),
//   //   // NamedRoutes.i.accountAddressAdd: (c) => const AddressFormView(),
//   // };
// }
