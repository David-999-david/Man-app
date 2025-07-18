import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/userProfile/addedProfile/add_profile_notifier.dart';
import 'package:user_auth/presentation/userProfile/notifier/user_notifier.dart';

class AddProfileImage extends StatelessWidget {
  const AddProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AddProfileNotifier()),
        ChangeNotifierProvider(
            create: (context) => UserNotifier()..getUserProfile())
      ],
      child: Consumer2<AddProfileNotifier, UserNotifier>(
        builder: (context, notifier, user, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              notifier.loading ||
                      user.user == null ||
                      user.user!.imageUrl == null
                  ? SpinKitCircle(
                      color: Colors.white,
                      size: 20,
                    )
                  : CircleAvatar(
                      radius: 100,
                      backgroundImage: notifier.image == null
                          ? NetworkImage(user.user!.imageUrl!)
                          : NetworkImage(notifier.image!),
                      child: user.user!.imageUrl == null
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      backgroundColor: Colors.transparent),
                  onPressed: () async {
                    final success = await notifier.upload(ImageSource.gallery);
                    if (success) {
                      AppNavigator.pop(context, true);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Choose from Gallery',
                        style: 13.sp(color: Colors.white),
                      )
                    ],
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      backgroundColor: Colors.transparent),
                  onPressed: () async {
                    final success = await notifier.upload(ImageSource.camera);
                    if (success) {
                      AppNavigator.pop(context, true);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Take a Photo',
                        style: 13.sp(color: Colors.white),
                      )
                    ],
                  ))
            ],
          );
        },
      ),
    );
  }
}
