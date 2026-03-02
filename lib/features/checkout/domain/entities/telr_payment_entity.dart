import 'package:equatable/equatable.dart';

class TelrPaymentEntity extends Equatable {
  final String? tokenUrl;
  final String? orderUrl;
  final String? webViewUrl;
  final String? orderRef;

  const TelrPaymentEntity({
    this.tokenUrl,
    this.orderUrl,
    this.webViewUrl,
    this.orderRef,
  });

  @override
  List<Object?> get props => [tokenUrl, orderUrl, webViewUrl, orderRef];
}
