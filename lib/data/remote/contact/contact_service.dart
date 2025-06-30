import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactService {
  Future<bool> requestContactPermission() async {
    final status = await Permission.contacts.status;

    if (status.isGranted) return true;

    final result = await Permission.contacts.request();

    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  Future<List<Contact>> fetchContact() async {
    if (!await requestContactPermission()) {
      throw Exception('Content permission denied');
    }
    return await FlutterContacts.getContacts(
        withProperties: true, withPhoto: false);
  }
}
