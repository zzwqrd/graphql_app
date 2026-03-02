import 'package:equatable/equatable.dart';

/// Entity representing a location with address
class AddressLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final String? label;
  final String? city;
  final String? country;

  const AddressLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.label,
    this.city,
    this.country,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    address,
    label,
    city,
    country,
  ];
}
