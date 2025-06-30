import 'package:flutter/material.dart';
import 'package:user_auth/data/model/contact/contact_model.dart';
import 'package:user_auth/data/remote/contact/contact_service.dart';

class ContactNotifier extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  List<ContactModel>? _contactList;
  List<ContactModel>? get contactList => _contactList;

  Future<void> loadContact() async {
    _loading = true;
    notifyListeners();
    try {
      final raw = await ContactService().fetchContact();

      _contactList = raw.map((item) => ContactModel.fromFlutter(item)).toList();
    } catch (e) {
      throw Exception('Error => ${e.toString()}');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
