import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user_auth/domain/usecase/auth/auth_usecase.dart';

class AddProfileNotifier extends ChangeNotifier {
  String? _image;
  String? get image => _image;

  bool _loading = false;
  bool get loading => _loading;

  String? _msg;
  String? get msg => _msg;

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
        final status = await Permission.photos.status;
        if (status.isGranted) return true;

        final result = await Permission.photos.request();

        if (result.isGranted) return true;

        if (result.isPermanentlyDenied) await openAppSettings();

        return false;
      }
    }
  }

  Future<bool> upload(ImageSource source) async {
    _msg = null;
    _loading = true;
    notifyListeners();
    try {
      if (await requestGalleryAndCameraPer(source)) {
        final XFile? picked = await ImagePicker().pickImage(source: source);

        if (picked == null) return false;

        final mimeType = lookupMimeType(picked.path) ?? 'image/jpeg';
        final part = mimeType.split('/');

        final form = FormData.fromMap({
          'avatar': await MultipartFile.fromFile(picked.path,
              filename: picked.name, contentType: MediaType(part[0], part[1]))
        });

        final url = await AuthUsecase().uploadProfile(form);

        if (url == null || url.isEmpty) {
          _msg = 'Failed to get image Url';
          return false;
        }

        _image = url;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _msg = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
