import 'dart:convert';

import '../../app_initialize.dart';
import '../../features/auth/login/data/models/login_model.dart';
import '../../features/product_list/data/models/product_model.dart'
    show ProductModel;

class SharedPrefHelper {
  Customer getCustomer() {
    final String? userJson = preferences.getString('customer');
    if (userJson == null) return Customer();
    final dynamic userMap = json.decode(userJson);
    return Customer.fromJson(userMap as Map<String, dynamic>);
  }

  void setCustomer(Customer customer) {
    final String userJson = json.encode(customer.toJson());
    preferences.setString('customer', userJson);
  }

  void removeCustomer() {
    preferences.remove('customer');
  }

  void clear() {
    preferences.clear();
  }

  void removeToken() {
    preferences.remove('auth_token');
  }

  String getToken() {
    return preferences.getString('auth_token') ?? '';
  }

  void setToken(String token) {
    preferences.setString('auth_token', token);
  }

  List<String> getSearchTerms() {
    return preferences.getStringList('search_terms') ?? [];
  }

  void addSearchTerm(String term) {
    List<String> terms = getSearchTerms();
    if (!terms.contains(term)) {
      terms.insert(0, term);
      if (terms.length > 10) {
        terms = terms.sublist(0, 10);
      }
      preferences.setStringList('search_terms', terms);
    }
  }

  List<ProductModel> getRecentlyViewed() {
    final String? jsonString = preferences.getString('recently_viewed');
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => ProductModel.fromJson(e)).toList();
  }

  void addRecentlyViewed(ProductModel product) {
    List<ProductModel> products = getRecentlyViewed();
    // Remove if exists to move to top
    products.removeWhere((p) => p.uid == product.uid || p.sku == product.sku);
    products.insert(0, product);
    if (products.length > 10) {
      products = products.sublist(0, 10);
    }
    final String jsonString = json.encode(
      products.map((e) => e.toJson()).toList(),
    );
    preferences.setString('recently_viewed', jsonString);
  }
}
