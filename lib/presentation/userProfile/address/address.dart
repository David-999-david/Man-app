import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/data/model/address/address_model.dart';
import 'package:user_auth/presentation/userProfile/address/create_address/create_address.dart';
import 'package:user_auth/presentation/userProfile/address/edit_address/edit_address.dart';
import 'package:user_auth/presentation/userProfile/address/notifier/address_notifier.dart';
import 'package:user_auth/presentation/widgets/loading_show.dart';

class Address extends StatelessWidget {
  const Address({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddressNotifier()..getAllAddress(),
      child: Consumer<AddressNotifier>(
        builder: (context, notifier, child) {
          return Scaffold(
            backgroundColor: Color(0xffB8CFCE),
            body: notifier.loading
                ? LoadingShow()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          final address = notifier.addressList[index];
                          return _addressCard(address, context, notifier);
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
              onPressed: () async {
                final didSuccess = await AppNavigator.push<bool>(
                    context,
                    ChangeNotifierProvider.value(
                      value: notifier,
                      child: CreateAddress(),
                    ));
                notifier.countRefresh();
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

Widget _addressCard(
    AddressModel address, BuildContext context, AddressNotifier notifier) {
  final onRemove = notifier.onRemove(address.id!);
  String? firstUrl =
      address.addressImage.isNotEmpty ? address.addressImage.first.url : null;

  DecorationImage? bg;

  if (firstUrl != null && firstUrl.isNotEmpty) {
    bg = DecorationImage(image: NetworkImage(firstUrl), fit: BoxFit.cover);
  }
  return onRemove || notifier.onEdit(address.id!) == true
      ? LoadingShow()
      : Slidable(
          key: ValueKey(address.id),
          endActionPane:
              ActionPane(motion: DrawerMotion(), extentRatio: 0.23, children: [
            SlidableAction(
              onPressed: (_) async {
                final didSuccess = await showModalBottomSheet<bool>(
                  context: (context),
                  isDismissible: false,
                  enableDrag: false,
                  isScrollControlled: true,
                  builder: (context) {
                    return ChangeNotifierProvider(
                      create: (_) =>
                          AddressNotifier(editAddress: address)..loadOld(),
                      child: EditAddress(),
                    );
                  },
                );
                if (didSuccess == true) {
                  notifier.getAllAddress();
                }
              },
              backgroundColor: Colors.greenAccent,
              icon: Icons.edit_location_sharp,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            SlidableAction(
              onPressed: (_) async {
                final messenger = ScaffoldMessenger.of(context);
                final success = await notifier.removeAddress(address);

                if (success) {
                  messenger
                      .showSnackBar(SnackBar(content: Text(notifier.msg!)));
                }
              },
              backgroundColor: Colors.red,
              icon: Icons.clear,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              borderRadius: BorderRadius.circular(10),
            )
          ]),
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
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
                          image: bg),
                      child: bg == null
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
                          padding: const EdgeInsets.fromLTRB(15, 10, 5, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                address.label.toString().isNotEmpty
                                    ? address.label.toString().toUpperCase()
                                    : 'Unknown',
                                style: 17.sp(
                                    color: address.label.toString().isNotEmpty
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
                                      color: address.postalCode.isNotEmpty
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
            ),
          ),
        );
}
