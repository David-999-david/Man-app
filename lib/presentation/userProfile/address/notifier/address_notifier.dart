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

  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;

  void getAllAddress() async {
    _loading = true;
    notifyListeners();
    try {
      _addressList = await AddressUsecase().getAllAddress();
      print('🏠 got ${_addressList.length} addresses');
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

  Set<int> _oneditId = {};
  bool onEdit(int id) => _oneditId.contains(id);

  Future<bool> updateAddress() async {
    _loading = true;
    _oneditId.add(editAddress!.id!);
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
      _oneditId.remove(editAddress!.id!);
      _loading = false;
      notifyListeners();
    }
  }

  Set<int> removeIds = {};
  bool onRemove(int id) => removeIds.contains(id);

  Future<bool> removeAddress(AddressModel address) async {
    removeIds.add(address.id!);
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
      removeIds.remove(address.id);
      notifyListeners();
    }
  }

  final List<TextEditingController> _label = [TextEditingController()];
  final List<TextEditingController> _street = [TextEditingController()];
  final List<TextEditingController> _city = [TextEditingController()];
  final List<TextEditingController> _state = [TextEditingController()];
  final List<TextEditingController> _country = [TextEditingController()];
  final List<TextEditingController> _postal = [TextEditingController()];
  final List<TextEditingController> _imageDesc = [TextEditingController()];

  List<TextEditingController> get label => _label;
  List<TextEditingController> get street => _street;
  List<TextEditingController> get city => _city;
  List<TextEditingController> get state => _state;
  List<TextEditingController> get country => _country;
  List<TextEditingController> get postal => _postal;
  List<TextEditingController> get imageDesc => _imageDesc;

  int _count = 1;
  int get count => _count;

  void callNew() {
    _label.add(TextEditingController());
    _street.add(TextEditingController());
    _city.add(TextEditingController());
    _state.add(TextEditingController());
    _country.add(TextEditingController());
    _postal.add(TextEditingController());
    _imageDesc.add(TextEditingController());
    _count++;
    notifyListeners();
  }

  void undo() {
    if (_count <= 1) return;
    _label.removeLast();
    _street.removeLast();
    _city.removeLast();
    _state.removeLast();
    _country.removeLast();
    _postal.removeLast();
    _imageDesc.removeLast();
    _count--;
    notifyListeners();
  }

  Future<bool> createMany() async {
    _loading = true;
    notifyListeners();
    try {
      final List<TestAddress> items = List.generate(_count, (i) {
        return TestAddress(
            label: _label[i].text,
            street: _street[i].text,
            city: _city[i].text,
            state: _state[i].text,
            country: _country[i].text,
            postalCode: _postal[i].text,
            imageDesc: _imageDesc[i].text);
      });

      await AddressUsecase().createMany(items);

      _label
        ..clear()
        ..add(TextEditingController());
      _street
        ..clear()
        ..add(TextEditingController());
      _city
        ..clear()
        ..add(TextEditingController());
      _state
        ..clear()
        ..add(TextEditingController());
      _country
        ..clear()
        ..add(TextEditingController());
      _postal
        ..clear()
        ..add(TextEditingController());
      _imageDesc
        ..clear()
        ..add(TextEditingController());

      return true;
    } catch (e) {
      _msg = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void countRefresh() {
    _count = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    for (final l in _label) l.dispose();
    for (final l in _street) l.dispose();
    for (final l in _city) l.dispose();
    for (final l in _state) l.dispose();
    for (final l in _country) l.dispose();
    for (final l in _postal) l.dispose();
    for (final l in _imageDesc) l.dispose();
  }
}
