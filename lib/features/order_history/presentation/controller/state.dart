import 'package:equatable/equatable.dart';
import '../../../../../core/utils/enums.dart';
import '../../data/models/order_model.dart';

class OrderHistoryState extends Equatable {
  final RequestState requestState;
  final String errorMessage;
  final OrderData? orderData;
  final List<OrderModel> orders;
  final bool isGuest;
  final OrderModel? guestOrder;

  const OrderHistoryState({
    this.requestState = RequestState.initial,
    this.errorMessage = '',
    this.orderData,
    this.orders = const [],
    this.isGuest = false,
    this.guestOrder,
  });

  OrderHistoryState copyWith({
    RequestState? requestState,
    String? errorMessage,
    OrderData? orderData,
    List<OrderModel>? orders,
    bool? isGuest,
    OrderModel? guestOrder,
  }) {
    return OrderHistoryState(
      requestState: requestState ?? this.requestState,
      errorMessage: errorMessage ?? this.errorMessage,
      orderData: orderData ?? this.orderData,
      orders: orders ?? this.orders,
      isGuest: isGuest ?? this.isGuest,
      guestOrder: guestOrder ?? this.guestOrder,
    );
  }

  @override
  List<Object?> get props => [
    requestState,
    errorMessage,
    orderData,
    orders,
    isGuest,
    guestOrder,
  ];
}
