import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';

/// Local Data Source for Guest Users
/// Stores addresses in SharedPreferences
class AddressLocalDataSource {
  final SharedPreferences prefs;

  static const String _addressesKey = 'guest_addresses';
  static const String _selectedAddressKey = 'selected_guest_address';

  AddressLocalDataSource({required this.prefs});

  /// Get all guest addresses from local storage
  Future<List<AddressModel>> getGuestAddresses() async {
    try {
      final String? addressesJson = prefs.getString(_addressesKey);
      if (addressesJson == null || addressesJson.isEmpty) {
        return [];
      }

      final List<dynamic> addressesList = json.decode(addressesJson);
      return addressesList
          .map(
            (json) => AddressModel.fromLocalJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error getting guest addresses: $e');
      return [];
    }
  }

  /// Save a new guest address
  Future<void> saveGuestAddress(AddressModel address) async {
    try {
      final addresses = await getGuestAddresses();

      // Generate ID if not exists
      final addressWithId = AddressModel.fromEntity(
        address.copyWith(
          id: address.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        ),
      );

      addresses.add(addressWithId);
      await _saveAddresses(addresses);
    } catch (e) {
      print('Error saving guest address: $e');
      rethrow;
    }
  }

  /// Update an existing guest address
  Future<void> updateGuestAddress(AddressModel address) async {
    try {
      final addresses = await getGuestAddresses();
      final index = addresses.indexWhere((a) => a.id == address.id);

      if (index != -1) {
        addresses[index] = address;
        await _saveAddresses(addresses);
      }
    } catch (e) {
      print('Error updating guest address: $e');
      rethrow;
    }
  }

  /// Delete a guest address
  Future<void> deleteGuestAddress(String addressId) async {
    try {
      final addresses = await getGuestAddresses();
      addresses.removeWhere((address) => address.id == addressId);
      await _saveAddresses(addresses);
    } catch (e) {
      print('Error deleting guest address: $e');
      rethrow;
    }
  }

  /// Set default address
  Future<void> setDefaultGuestAddress(String addressId) async {
    try {
      final addresses = await getGuestAddresses();

      // Remove default from all addresses
      final updatedAddresses = addresses.map((address) {
        return AddressModel.fromEntity(
          address.copyWith(isDefault: address.id == addressId),
        );
      }).toList();

      await _saveAddresses(updatedAddresses);
    } catch (e) {
      print('Error setting default address: $e');
      rethrow;
    }
  }

  /// Get selected address for checkout
  Future<AddressModel?> getSelectedAddress() async {
    try {
      final String? addressJson = prefs.getString(_selectedAddressKey);
      if (addressJson == null || addressJson.isEmpty) {
        return null;
      }

      return AddressModel.fromLocalJson(
        json.decode(addressJson) as Map<String, dynamic>,
      );
    } catch (e) {
      print('Error getting selected address: $e');
      return null;
    }
  }

  /// Save selected address for checkout
  Future<void> saveSelectedAddress(AddressModel address) async {
    try {
      await prefs.setString(
        _selectedAddressKey,
        json.encode(address.toLocalJson()),
      );
    } catch (e) {
      print('Error saving selected address: $e');
      rethrow;
    }
  }

  /// Clear all guest addresses (e.g., after login)
  Future<void> clearGuestAddresses() async {
    try {
      await prefs.remove(_addressesKey);
      await prefs.remove(_selectedAddressKey);
    } catch (e) {
      print('Error clearing guest addresses: $e');
      rethrow;
    }
  }

  /// Private helper to save addresses list
  Future<void> _saveAddresses(List<AddressModel> addresses) async {
    final addressesJson = addresses.map((a) => a.toLocalJson()).toList();
    await prefs.setString(_addressesKey, json.encode(addressesJson));
  }
}
