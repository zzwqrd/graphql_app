import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enums.dart';
import '../../data/models/dashboard_model.dart';

class MyAccountState extends Equatable {
  final RequestState requestState;
  final String errorMessage;
  final DashboardData? dashboardData;

  const MyAccountState({
    this.requestState = RequestState.initial,
    this.errorMessage = '',
    this.dashboardData,
  });

  MyAccountState copyWith({
    RequestState? requestState,
    String? errorMessage,
    DashboardData? dashboardData,
  }) {
    return MyAccountState(
      requestState: requestState ?? this.requestState,
      errorMessage: errorMessage ?? this.errorMessage,
      dashboardData: dashboardData ?? this.dashboardData,
    );
  }

  @override
  List<Object?> get props => [requestState, errorMessage, dashboardData];
}
