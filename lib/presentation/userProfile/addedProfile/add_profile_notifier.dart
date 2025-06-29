import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:user_auth/domain/usecase/auth/auth_usecase.dart';

class AddProfileNotifier extends ChangeNotifier {
  String? _image;
  String? get image => _image;

  bool _loading = false;
  bool get loading => _loading;

  String? _msg;
  String? get msg => _msg;

  Future<bool> upload() async {
    _msg = null;
    _loading = true;
    notifyListeners();
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (picked == null) return false;

      final mimeStr = lookupMimeType(picked.path) ?? 'image/jpeg';
      final parts = mimeStr.split('/');

      final form = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(picked.path,
            filename: picked.name, contentType: MediaType(parts[0], parts[1]))
      });

      final Url = await AuthUsecase().uploadProfile(form);

      _image = Url;
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
