class NamedRoutes {
  static NamedRoutes get i => NamedRoutes._internal();
  NamedRoutes._internal();
  final splash = "/splash";
  final login = "/login";
  final loginRules = "/login_rules";
  String get layout => "/layout";
  String get productList => "/product_list";
  String get productDetails => "/product_details";
  final home = "/home";
  final wishlistView = "/wishlist_view";
  final searchView = "/search_view";
  final changeLanguage = "/change_language";
  final shippingInformation = "/shipping_information";
  final checkout = "/checkout";
  final profileAddress = "/profile_address";
  final addPickLocation = "/add_pick_location";

  // Account routes
  final account = "/account";
  final orderHistory = "/order_history";
  final accountOverview = "/account/overview";
  final accountOrders = "/account/orders";
  final accountInfo = "/account/info";
  final accountChangePassword = "/account/change-password";
  final accountAddresses = "/account/addresses";
  final accountAddressAdd = "/account/address/add";
  String accountAddressEdit(int id) => "/account/address/edit/$id";
}
