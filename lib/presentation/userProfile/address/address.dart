import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/presentation/userProfile/address/create_address/create_address.dart';
import 'package:user_auth/presentation/userProfile/address/notifier/address_notifier.dart';

class Address extends StatelessWidget {
  const Address({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddressNotifier(),
      child: Consumer<AddressNotifier>(
        builder: (context, notifier, child) {
          return Scaffold(
            body: Center(
              child: OutlinedButton(
                  onPressed: () {
                    AppNavigator.push(context, CreateAddress());
                  },
                  child: Text('Add new')),
            ),
          );
        },
      ),
    );
  }
}
