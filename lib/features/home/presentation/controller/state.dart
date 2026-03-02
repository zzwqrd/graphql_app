import '../../../../core/utils/enums.dart';
import '../../data/models/home_response.dart';

class HomeState {
  final RequestState requestState;
  final String msg;
  final HomeResponse? homeResponse;

  HomeState({
    this.requestState = RequestState.initial,
    this.msg = '',
    this.homeResponse,
  });

  HomeState copyWith({
    RequestState? requestState,
    String? msg,
    HomeResponse? homeResponse,
  }) => HomeState(
    requestState: requestState ?? this.requestState,
    msg: msg ?? this.msg,
    homeResponse: homeResponse ?? this.homeResponse,
  );
}
