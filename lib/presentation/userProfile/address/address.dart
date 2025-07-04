import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/userProfile/address/create_address/create_address.dart';
import 'package:user_auth/presentation/userProfile/address/notifier/address_notifier.dart';

class Address extends StatelessWidget {
  const Address({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddressNotifier()..getAllAddress(),
      child: Consumer<AddressNotifier>(
        builder: (context, notifier, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    final address = notifier.addressList[index];
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.lightGreenAccent)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Container(
                              height: 130,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  image: address.addressImage.isEmpty
                                      ? null
                                      : DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              address.addressImage.first.url))),
                              child: address.addressImage.isEmpty
                                  ? Icon(
                                      Icons.photo,
                                      size: 30,
                                    )
                                  : null,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Card(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 5, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address.label.toString().isNotEmpty
                                            ? address.label.toString()
                                            : 'Unknown',
                                        style: 17.sp(
                                            color: address.label
                                                    .toString()
                                                    .isNotEmpty
                                                ? Colors.black
                                                : Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        address.street.isNotEmpty
                                            ? address.street
                                            : 'Unknown',
                                        style: 13.sp(
                                            color: address.street.isNotEmpty
                                                ? Colors.black
                                                : Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                          address.city.isNotEmpty
                                              ? address.city
                                              : 'Unknown',
                                          style: 13.sp(
                                              color: address.city.isNotEmpty
                                                  ? Colors.black
                                                  : Colors.grey)),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                          address.state.isNotEmpty
                                              ? address.state
                                              : 'Unknown',
                                          style: 13.sp(
                                              color: address.state.isNotEmpty
                                                  ? Colors.black
                                                  : Colors.grey)),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                          address.country.isNotEmpty
                                              ? address.country
                                              : 'Unknown',
                                          style: 13.sp(
                                              color: address.country.isNotEmpty
                                                  ? Colors.black
                                                  : Colors.grey)),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                          address.postalCode.isNotEmpty
                                              ? address.postalCode
                                              : 'Unknown',
                                          style: 13.sp(
                                              color:
                                                  address.postalCode.isNotEmpty
                                                      ? Colors.black
                                                      : Colors.grey))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: notifier.addressList.length),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndDocked,
            floatingActionButton: FloatingActionButton(
              mini: true,
              onPressed: () {
                final didSuccess = AppNavigator.push<bool>(
                    context,
                    ChangeNotifierProvider.value(
                      value: notifier,
                      child: CreateAddress(),
                    ));
                if (didSuccess == true) {
                  notifier.getAllAddress();
                }
              },
              child: Icon(
                Icons.add,
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
