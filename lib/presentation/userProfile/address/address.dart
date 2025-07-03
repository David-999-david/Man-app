import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/presentation/userProfile/address/notifier/address_notifier.dart';

class Address extends StatelessWidget {
  const Address({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddressNotifier()..getCurrentLocation(),
      child: Consumer(
        builder: (context, value, child) {
          return Scaffold();
        },
      ),
    );
  }
}
