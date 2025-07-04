import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user_auth/data/model/address/address_model.dart';
import 'package:user_auth/domain/usecase/address/address_usecase.dart';

class AddressNotifier extends ChangeNotifier {
  AddressNotifier({this.editAddress});

  AddressModel? editAddress;

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

  final TextEditingController labelCtrl = TextEditingController();

  final TextEditingController streetCtrl = TextEditingController();

  final TextEditingController cityCtrl = TextEditingController();

  final TextEditingController stateCtrl = TextEditingController();

  final TextEditingController countryCtrl = TextEditingController();

  final TextEditingController postalCtrl = TextEditingController();

  final TextEditingController imageDescCtrl = TextEditingController();

  XFile? _picked;
  XFile? get picked => _picked;

  String? _imageUrl = '';
  String? get imageUrl => _imageUrl;

  Future<bool> requestGalleryAndCameraPer(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.status;

      if (status.isGranted) return true;

      final result = await Permission.camera.request();

      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    } else {
      if (Platform.isAndroid) {
        final status = await Permission.storage.status;

        if (status.isGranted) return true;

        final result = await Permission.storage.request();

        if (result.isGranted) return true;

        if (result.isPermanentlyDenied) {
          await openAppSettings();
        }
        return false;
      } else {
        final status = await Permission.storage.status;

        if (status.isGranted) return true;

        final result = await Permission.storage.request();

        if (result.isGranted) return true;

        if (result.isPermanentlyDenied) {
          await openAppSettings();
        }
        return false;
      }
    }
  }

  Future<void> onPick(ImageSource soucre) async {
    if (!await requestGalleryAndCameraPer(soucre)) {
      throw Exception('Camera or gallery permission is rejected');
    }

    final picked = await ImagePicker().pickImage(source: soucre);

    if (picked == null) return;

    final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        maxHeight: 800,
        maxWidth: 800,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              cropFrameColor: Colors.tealAccent),
          IOSUiSettings(title: 'Crop Image')
        ]);

    if (cropped == null) return;

    _picked = XFile(cropped.path);
    _imageUrl = cropped.path;
    notifyListeners();
  }

  Future<bool> createAddress() async {
    _loading = true;
    notifyListeners();
    try {
      final Map<String, dynamic> map = {
        'label': labelCtrl.text,
        'street': streetCtrl.text,
        'city': cityCtrl.text,
        'state': stateCtrl.text,
        'country': countryCtrl.text,
        'postalCode': postalCtrl.text,
        'imageDesc': imageDescCtrl.text
      };

      if (_picked != null) {
        final mimeType = lookupMimeType(_picked!.path) ?? 'image/jpeg';

        final part = mimeType.split('/');

        map['file'] = await MultipartFile.fromFile(_picked!.path,
            filename: _picked!.name, contentType: MediaType(part[0], part[1]));
      }

      final form = FormData.fromMap(map);

      final created = await AddressUsecase().createAddress(form);

      _addressList.insert(0, created);
      notifyListeners();

      labelCtrl.clear();
      streetCtrl.clear();
      cityCtrl.clear();
      stateCtrl.clear();
      countryCtrl.clear();
      postalCtrl.clear();
      imageDescCtrl.clear();
      _imageUrl = '';
      _picked = null;

      return true;
    } catch (e) {
      _msg = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    labelCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    postalCtrl.dispose();
    imageDescCtrl.dispose();
    super.dispose();
  }

  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;

  void getAllAddress() async {
    _loading = true;
    notifyListeners();
    try {
      _addressList = await AddressUsecase().getAllAddress();
    } catch (e) {
      _msg = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void loadOld() {
    if (editAddress != null) {
      labelCtrl.text = editAddress!.label.toString();

      streetCtrl.text = editAddress!.street;
      cityCtrl.text = editAddress!.city.toUpperCase();
      stateCtrl.text = editAddress!.state;
      countryCtrl.text = editAddress!.country.toUpperCase();
      postalCtrl.text = editAddress!.postalCode;
      if (editAddress!.addressImage.isNotEmpty) {
        _imageUrl = editAddress!.addressImage.first.url;
        imageDescCtrl.text = editAddress!.addressImage.first.description;
      } else {
        _imageUrl = '';
        imageDescCtrl.text = '';
      }
    }
  }

  Future<bool> updateAddress() async {
    _loading = true;
    notifyListeners();
    try {
      final Map<String, dynamic> map = {
        'label': labelCtrl.text,
        'street': streetCtrl.text,
        'city': cityCtrl.text,
        'state': stateCtrl.text,
        'country': countryCtrl.text,
        'postalCode': postalCtrl.text,
        'imageDesc': imageDescCtrl.text
      };

      if (_picked != null) {
        final mimeType = lookupMimeType(_picked!.path) ?? 'image/jpeg';

        final part = mimeType.split('/');

        map['file'] = await MultipartFile.fromFile(_picked!.path,
            filename: _picked!.name, contentType: MediaType(part[0], part[1]));
      }

      final form = FormData.fromMap(map);

      final edited = await AddressUsecase().editAddress(editAddress!.id!, form);

      final idx = _addressList.indexWhere((add) => add.id == edited.id);

      if (idx != -1) {
        _addressList[idx] = edited;
        notifyListeners();
      }

      imageDescCtrl.clear();
      labelCtrl.clear();
      streetCtrl.clear();
      cityCtrl.clear();
      stateCtrl.clear();
      countryCtrl.clear();
      postalCtrl.clear();
      return true;
    } catch (e) {
      _msg = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> removeAddress(AddressModel address) async {
    _loading = true;
    notifyListeners();
    try {
      final response = await AddressUsecase().removeAddress(address.id!);

      _msg = response;

      final idx = _addressList.indexWhere((item) => item.id == address.id);

      if (idx != -1) {
        _addressList.removeAt(idx);
        notifyListeners();
      }
      return true;
    } catch (e) {
      _msg = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
