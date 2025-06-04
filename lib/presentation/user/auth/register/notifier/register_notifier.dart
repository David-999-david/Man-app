import 'package:flutter/material.dart';

class RegisterNotifier extends ChangeNotifier {
  final TextEditingController _emailCtr = TextEditingController();
  final TextEditingController _pssCtr = TextEditingController();
  final TextEditingController _nameCtr = TextEditingController();

  TextEditingController get emailCtr => _emailCtr;
  TextEditingController get pssCtr => _pssCtr;
  TextEditingController get nameCtr => _nameCtr;

  bool isVisable = false;

  void onShown() {
    if (_pssCtr.text.trim().isNotEmpty) {
      isVisable = !isVisable;
      notifyListeners();
    } else {
      isVisable = !isVisable;
      notifyListeners();
    }
  }
}
