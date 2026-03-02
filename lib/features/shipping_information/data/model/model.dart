import '../../domain/entities/entity.dart';

/// Data model for AddressLocation
class AddressLocationModel extends AddressLocation {
  const AddressLocationModel({
    required super.latitude,
    required super.longitude,
    required super.address,
    super.label,
    super.city,
    super.country,
  });

  /// Create from JSON
  factory AddressLocationModel.fromJson(Map<String, dynamic> json) {
    return AddressLocationModel(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      address: json['address'] as String,
      label: json['label'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'label': label,
      'city': city,
      'country': country,
    };
  }

  /// Create from entity
  factory AddressLocationModel.fromEntity(AddressLocation entity) {
    return AddressLocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      label: entity.label,
      city: entity.city,
      country: entity.country,
    );
  }

  /// Convert to entity
  AddressLocation toEntity() {
    return AddressLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
      label: label,
      city: city,
      country: country,
    );
  }
}
