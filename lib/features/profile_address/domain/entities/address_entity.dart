import 'package:equatable/equatable.dart';

/// Address Entity - Domain Layer
/// Represents a customer address with all necessary fields
class AddressEntity extends Equatable {
  final String? id;
  final String label; // Home, Work, Other
  final String street;
  final String? apartment;
  final String? floor;
  final String? building;
  final String? city;
  final String? country;
  final String? region;
  final String? postcode;
  final String? telephone;
  final String? email;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final String? customerId;

  const AddressEntity({
    this.id,
    required this.label,
    required this.street,
    this.apartment,
    this.floor,
    this.building,
    this.city,
    this.country,
    this.region,
    this.postcode,
    this.telephone,
    this.email,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
    this.customerId,
  });

  @override
  List<Object?> get props => [
    id,
    label,
    street,
    apartment,
    floor,
    building,
    city,
    country,
    region,
    postcode,
    telephone,
    email,
    latitude,
    longitude,
    isDefault,
    customerId,
  ];

  /// Create a copy with updated fields
  AddressEntity copyWith({
    String? id,
    String? label,
    String? street,
    String? apartment,
    String? floor,
    String? building,
    String? city,
    String? country,
    String? region,
    String? postcode,
    String? telephone,
    String? email,
    double? latitude,
    double? longitude,
    bool? isDefault,
    String? customerId,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      apartment: apartment ?? this.apartment,
      floor: floor ?? this.floor,
      building: building ?? this.building,
      city: city ?? this.city,
      country: country ?? this.country,
      region: region ?? this.region,
      postcode: postcode ?? this.postcode,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      customerId: customerId ?? this.customerId,
    );
  }

  /// Get formatted address string
  String get formattedAddress {
    final parts = <String>[];

    if (apartment != null && apartment!.isNotEmpty) {
      parts.add('شقة $apartment');
    }
    if (floor != null && floor!.isNotEmpty) {
      parts.add('طابق $floor');
    }
    if (building != null && building!.isNotEmpty) {
      parts.add('مبنى $building');
    }
    parts.add(street);
    if (city != null && city!.isNotEmpty) {
      parts.add(city!);
    }
    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }

    return parts.join(', ');
  }
}
