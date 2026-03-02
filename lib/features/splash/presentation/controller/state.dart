import 'package:equatable/equatable.dart';

enum SplashStatus { initial, loading, ready, error }

class SplashState extends Equatable {
  final SplashStatus status;
  final String? nextRoute;
  final String? message;

  const SplashState._({required this.status, this.nextRoute, this.message});

  const SplashState.initial() : this._(status: SplashStatus.initial);
  const SplashState.loading({String? message})
    : this._(status: SplashStatus.loading, message: message);
  const SplashState.ready({String? nextRoute})
    : this._(status: SplashStatus.ready, nextRoute: nextRoute);
  const SplashState.error(String message)
    : this._(status: SplashStatus.error, message: message);

  SplashState copyWith({
    SplashStatus? status,
    String? nextRoute,
    String? message,
  }) {
    return SplashState._(
      status: status ?? this.status,
      nextRoute: nextRoute ?? this.nextRoute,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, nextRoute, message];
}
