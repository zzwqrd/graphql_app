import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/enums.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import 'state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase _getProductDetailsUseCase =
      GetProductDetailsUseCaseImpl();

  ProductDetailsCubit() : super(ProductDetailsState());

  Future<void> getProductDetails(String sku) async {
    emit(state.copyWith(requestState: RequestState.loading));

    final result = await _getProductDetailsUseCase(sku);

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              requestState: RequestState.error,
              msg: error.message,
            ),
          );
        }
      },
      (data) {
        if (!isClosed) {
          emit(state.copyWith(requestState: RequestState.done, product: data));
        }
      },
    );
  }
}
