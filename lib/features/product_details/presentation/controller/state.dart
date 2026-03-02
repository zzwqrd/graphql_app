import '../../../../../core/utils/enums.dart';
import '../../data/models/product_details_model.dart';

class ProductDetailsState {
  final RequestState requestState;
  final String msg;
  final ProductDetailsModel? product;

  ProductDetailsState({
    this.requestState = RequestState.initial,
    this.msg = '',
    this.product,
  });

  ProductDetailsState copyWith({
    RequestState? requestState,
    String? msg,
    ProductDetailsModel? product,
  }) => ProductDetailsState(
    requestState: requestState ?? this.requestState,
    msg: msg ?? this.msg,
    product: product ?? this.product,
  );
}
