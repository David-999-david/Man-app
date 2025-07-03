import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user_auth/data/model/address/address_model.dart';

class AddressNotifier extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Future<bool> requestLocationUsedPerm() async {
    final status = await Permission.locationWhenInUse.status;

    if (status.isGranted) return true;

    final result = await Permission.locationWhenInUse.request();

    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  Position? _position;
  PickAddress? _currentAddress;
  PickAddress? get currentAddress => _currentAddress;

  final TextEditingController addressLabel = TextEditingController();

  String? _msg;
  String? get msg => _msg;

  Future<void> getCurrentLocation() async {
    _msg = null;
    _loading = true;
    notifyListeners();

    try {
      if (!await requestLocationUsedPerm()) {
        throw Exception('User reject the Location Permission');
      }

      _position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

      final placeMark = await placemarkFromCoordinates(
          _position!.latitude, _position!.longitude);

      if (placeMark.isNotEmpty) {
        final p = placeMark.first;

        _currentAddress = PickAddress(
            street: p.street ?? '',
            city: p.locality ?? '',
            state: p.administrativeArea ?? '',
            country: p.country ?? '',
            postalCode: p.postalCode ?? '');
      }
    } catch (e) {
      _msg = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
