import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/home/notifier/home_notifier.dart';
import 'package:user_auth/presentation/widgets/loading_show.dart';

class Addtodo extends StatelessWidget {
  const Addtodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifier>(
      builder: (context, notifier, child) {
        return Scaffold(
          body: notifier.loading
              ? LoadingShow()
              : Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Form(
                      key: notifier.key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _todoImageCard(notifier),
                          SizedBox(
                            height: 15,
                          ),
                          _textFormField(notifier.titleCtrl, 'Title', 'Title'),
                          SizedBox(
                            height: 15,
                          ),
                          _textFormField(
                              notifier.descCtrl, 'Description', 'Description'),
                          SizedBox(
                            height: 10,
                          ),
                          _textFormField(notifier.imageDescCtrl,
                              'Image Description', 'Image Description'),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Color(0xFFBDBDBD),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      side: BorderSide(color: Colors.white),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      fixedSize: Size(80, 32)),
                                  onPressed: () {
                                    AppNavigator.pop(context);
                                  },
                                  child: Text(
                                    'Back',
                                    style: 15.sp(),
                                  )),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Color(0xFFBDBDBD),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      side: BorderSide(color: Colors.white),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      fixedSize: Size(80, 32)),
                                  onPressed: () async {
                                    if (notifier.key.currentState!.validate()) {
                                      final success = await notifier
                                          .addNew();
                                      if (success) {
                                        AppNavigator.pop(context, success);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    '1 items had been added')));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('Failed to add new')));
                                      }
                                    }
                                  },
                                  child: Text(
                                    'OK',
                                    style: 15.sp(),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

Widget _todoImageCard(HomeNotifier notifier) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
    height: 322,
    width: 250,
    child: Card(
      color: Colors.brown,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: CircleAvatar(
              backgroundImage: notifier.imageUrl!.isEmpty
                  ? null
                  : FileImage(File(notifier.imageUrl!)),
              radius: 80,
              child: notifier.imageUrl!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 60,
                    )
                  : null,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  fixedSize: Size(130, 32)),
              onPressed: () async {
                await notifier.onPick(ImageSource.gallery);
              },
              child: Text(
                'From Gallery',
                style: 13.sp(color: Colors.white),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  fixedSize: Size(130, 32)),
              onPressed: () async {
                await notifier.onPick(ImageSource.camera);
              },
              child: Text(
                'Open Camera',
                style: 13.sp(color: Colors.white),
              ))
        ],
      ),
    ),
  );
}

Widget _textFormField(
    TextEditingController controller, String hint, String text) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: 14.sp(color: const Color.fromARGB(255, 103, 102, 102)),
      errorStyle: 10.sp(color: Colors.red),
      filled: true,
      fillColor: Color(0xFFBDBDBD),
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white)),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '$text must not be empty';
      } else {
        return null;
      }
    },
  );
}
