import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../app_initialize.dart';
import '../../data/models/order_model.dart';
import '../../domain/usecases/usecases.dart';
import 'state.dart';

class OrderHistoryController extends Cubit<OrderHistoryState> {
  OrderHistoryController() : super(const OrderHistoryState());

  final _getOrdersUseCase = GetOrdersUseCaseImpl();
  final _getGuestOrderUseCase = GetGuestOrderUseCaseImpl();

  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;

  // 📦 Guest order storage keys
  static const String _guestOrdersKey = 'guest_orders';
  static const String _guestOrdersEmailKey = 'guest_orders_emails';

  Future<void> getOrders({bool refresh = false}) async {
    // Check if user is logged in
    final isLoggedIn = preferences.getString('auth_token') != null;

    if (!isLoggedIn) {
      // User is guest - load saved guest orders and refresh from backend
      emit(state.copyWith(requestState: RequestState.loading, isGuest: true));

      final savedOrders = _getSavedGuestOrders();
      final savedEmails = _getSavedGuestOrderEmails();

      // If no saved orders, just show empty state
      if (savedOrders.isEmpty) {
        emit(state.copyWith(requestState: RequestState.done, orders: []));
        return;
      }

      // Fetch fresh data for all saved guest orders
      final List<OrderModel> refreshedOrders = [];

      for (int i = 0; i < savedOrders.length; i++) {
        final savedOrder = savedOrders[i];
        final email = savedEmails.length > i ? savedEmails[i] : '';

        if (email.isEmpty) {
          // No email saved, keep the cached order
          refreshedOrders.add(savedOrder);
          continue;
        }

        final result = await _getGuestOrderUseCase.call(
          orderNumber: savedOrder.orderNumber,
          email: email,
        );

        result.fold(
          (error) {
            // If fetch fails, keep the saved order
            refreshedOrders.add(savedOrder);
          },
          (order) {
            // Update with fresh data
            refreshedOrders.add(order);
            _saveGuestOrder(order, email);
          },
        );
      }

      emit(
        state.copyWith(
          requestState: RequestState.done,
          orders: refreshedOrders,
        ),
      );
      return;
    }

    // User is logged in - fetch customer orders
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      emit(
        state.copyWith(
          requestState: RequestState.loading,
          orders: [],
          isGuest: false,
        ),
      );
    } else {
      if (!_hasMore) return;
    }

    final result = await _getOrdersUseCase.call(
      pageSize: _pageSize,
      currentPage: _currentPage,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            requestState: RequestState.error,
            errorMessage: error.message,
          ),
        );
      },
      (orderData) {
        final newOrders = refresh
            ? orderData.items
            : [...state.orders, ...orderData.items];

        _currentPage++;
        _hasMore = orderData.items.length >= _pageSize;

        emit(
          state.copyWith(
            requestState: RequestState.done,
            orderData: orderData,
            orders: newOrders,
          ),
        );
      },
    );
  }

  Future<void> trackGuestOrder({
    required String orderNumber,
    required String email,
  }) async {
    emit(state.copyWith(requestState: RequestState.loading));

    final result = await _getGuestOrderUseCase.call(
      orderNumber: orderNumber,
      email: email,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            requestState: RequestState.error,
            errorMessage: error.message,
          ),
        );
      },
      (order) {
        // Save guest order locally
        _saveGuestOrder(order, email);

        // Update state with the tracked order
        final updatedOrders = [order, ...state.orders];
        emit(
          state.copyWith(
            requestState: RequestState.done,
            guestOrder: order,
            orders: updatedOrders,
          ),
        );
      },
    );
  }

  // 💾 Save guest order to SharedPreferences
  void _saveGuestOrder(OrderModel order, String email) {
    final savedOrders = _getSavedGuestOrders();
    final savedEmails = _getSavedGuestOrderEmails();

    // Check if order already exists
    final existingIndex = savedOrders.indexWhere(
      (o) => o.orderNumber == order.orderNumber,
    );

    if (existingIndex != -1) {
      // Update existing order
      savedOrders[existingIndex] = order;
      savedEmails[existingIndex] = email;
    } else {
      // Add new order at the beginning
      savedOrders.insert(0, order);
      savedEmails.insert(0, email);
    }

    // Keep only last 10 orders
    if (savedOrders.length > 10) {
      savedOrders.removeRange(10, savedOrders.length);
      savedEmails.removeRange(10, savedEmails.length);
    }

    // Save to preferences
    final ordersJson = savedOrders.map((o) => o.toJson()).toList();
    preferences.setString(_guestOrdersKey, json.encode(ordersJson));
    preferences.setString(_guestOrdersEmailKey, json.encode(savedEmails));
  }

  // 📖 Retrieve saved guest orders from SharedPreferences
  List<OrderModel> _getSavedGuestOrders() {
    final ordersString = preferences.getString(_guestOrdersKey);
    if (ordersString == null || ordersString.isEmpty) return [];

    try {
      final List<dynamic> ordersJson = json.decode(ordersString);
      return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // 📖 Retrieve saved guest order emails from SharedPreferences
  List<String> _getSavedGuestOrderEmails() {
    final emailsString = preferences.getString(_guestOrdersEmailKey);
    if (emailsString == null || emailsString.isEmpty) return [];

    try {
      final List<dynamic> emailsJson = json.decode(emailsString);
      return emailsJson.map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }
}
