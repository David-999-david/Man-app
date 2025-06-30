import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/data/model/contact/contact_model.dart';
import 'package:user_auth/presentation/userProfile/contact/notifier/contact_notifier.dart';
import 'package:user_auth/presentation/widgets/loading_show.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactNotifier()..loadContact(),
      child: Consumer<ContactNotifier>(
        builder: (context, contact, child) {
          return Scaffold(
              body: contact.loading
                  ? LoadingShow()
                  : SizedBox(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 10, top: 35, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        AppNavigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 26,
                                      )),
                                  SizedBox(
                                    width: 23,
                                  ),
                                  Text(
                                    'Contacts',
                                    style: 21.sp(color: Colors.white),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 22,
                                      ))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 15,
                                );
                              },
                              itemCount: contact.contactList!.length,
                              itemBuilder: (context, index) {
                                return _contactItem(
                                    contact.contactList![index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ));
        },
      ),
    );
  }
}

Widget _contactItem(ContactModel contact) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          child: Icon(Icons.person),
        ),
        SizedBox(
          width: 17,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                contact.displayName ?? 'Unknown',
                style: 18.sp(color: Colors.teal),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                contact.phoneNum.isNotEmpty
                    ? contact.phoneNum.first
                    : 'No phone',
                style: 15.sp(color: Colors.white),
              )
            ],
          ),
        )
      ],
    ),
  );
}
