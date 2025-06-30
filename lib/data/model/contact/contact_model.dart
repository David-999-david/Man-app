import 'package:flutter_contacts/contact.dart';

class ContactModel {
  final String? displayName;
  final List<String> email;
  final List<String> phoneNum;

  ContactModel({
    required this.displayName,
    this.email = const [],
    required this.phoneNum,
  });

  factory ContactModel.fromFlutter(Contact c) {
    return ContactModel(
        displayName: c.displayName,
        email: c.emails.map((item) => item.address).toList(),
        phoneNum: c.phones.map((item) => item.number).toList());
  }
}
