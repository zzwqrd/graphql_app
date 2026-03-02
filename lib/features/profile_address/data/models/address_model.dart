import '../../domain/entities/address_entity.dart';

/// Address Model - Data Layer
/// Handles JSON serialization for API and local storage
class AddressModel extends AddressEntity {
  const AddressModel({
    super.id,
    required super.label,
    required super.street,
    super.apartment,
    super.floor,
    super.building,
    super.city,
    super.country,
    super.region,
    super.postcode,
    super.telephone,
    super.email,
    required super.latitude,
    required super.longitude,
    super.isDefault,
    super.customerId,
  });

  /// Create from GraphQL response
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString(),
      label: json['label'] as String? ?? 'Other',
      street:
          (json['street'] as List?)?.join(', ') ??
          json['street'] as String? ??
          '',
      apartment: json['apartment'] as String?,
      floor: json['floor'] as String?,
      building: json['building'] as String?,
      city: json['city'] as String?,
      country: json['country_code'] as String?,
      region: json['region']?['region'] as String? ?? json['region'] as String?,
      postcode: json['postcode'] as String?,
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['default_shipping'] as bool? ?? false,
      customerId: json['customer_id']?.toString(),
    );
  }

  /// Convert to GraphQL mutation input
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'label': label,
      'street': [street],
      if (apartment != null) 'apartment': apartment,
      if (floor != null) 'floor': floor,
      if (building != null) 'building': building,
      if (city != null) 'city': city,
      if (country != null) 'country_code': country,
      if (region != null) 'region': {'region': region},
      if (postcode != null) 'postcode': postcode,
      if (telephone != null) 'telephone': telephone,
      if (email != null) 'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'default_shipping': isDefault,
    };
  }

  /// Create from local storage (SharedPreferences)
  factory AddressModel.fromLocalJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String?,
      label: json['label'] as String,
      street: json['street'] as String,
      apartment: json['apartment'] as String?,
      floor: json['floor'] as String?,
      building: json['building'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      region: json['region'] as String?,
      postcode: json['postcode'] as String?,
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isDefault: json['isDefault'] as bool? ?? false,
      customerId: json['customerId'] as String?,
    );
  }

  /// Convert to local storage format
  Map<String, dynamic> toLocalJson() {
    return {
      if (id != null) 'id': id,
      'label': label,
      'street': street,
      if (apartment != null) 'apartment': apartment,
      if (floor != null) 'floor': floor,
      if (building != null) 'building': building,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (region != null) 'region': region,
      if (postcode != null) 'postcode': postcode,
      if (telephone != null) 'telephone': telephone,
      if (email != null) 'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      if (customerId != null) 'customerId': customerId,
    };
  }

  /// Create from entity
  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      label: entity.label,
      street: entity.street,
      apartment: entity.apartment,
      floor: entity.floor,
      building: entity.building,
      city: entity.city,
      country: entity.country,
      region: entity.region,
      postcode: entity.postcode,
      telephone: entity.telephone,
      email: entity.email,
      latitude: entity.latitude,
      longitude: entity.longitude,
      isDefault: entity.isDefault,
      customerId: entity.customerId,
    );
  }

  /// Convert to entity
  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      label: label,
      street: street,
      apartment: apartment,
      floor: floor,
      building: building,
      city: city,
      country: country,
      region: region,
      postcode: postcode,
      telephone: telephone,
      email: email,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault,
      customerId: customerId,
    );
  }
}
