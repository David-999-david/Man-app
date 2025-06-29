import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/userProfile/addedProfile/add_profile_notifier.dart';

class AddProfileImage extends StatelessWidget {
  const AddProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddProfileNotifier(),
      child: Consumer<AddProfileNotifier>(
        builder: (context, notifier, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 100,
                  backgroundImage: notifier.image == null
                      ? null
                      : NetworkImage(notifier.image!),
                  child: notifier.image == null
                      ? Icon(
                          Icons.person,
                          color: Colors.black54,
                          size: 100,
                        )
                      : null),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent),
                  onPressed: () async {
                    final success = notifier.upload();
                    if (success == true) {
                      AppNavigator.pop(context);
                    }
                  },
                  child: Text(
                    'Upload',
                    style: 13.sp(color: Colors.white),
                  ))
            ],
          );
        },
      ),
    );
  }
}
