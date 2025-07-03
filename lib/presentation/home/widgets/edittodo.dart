import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/data/model/todo/todo_model.dart';
import 'package:user_auth/presentation/home/notifier/home_notifier.dart';
import 'package:user_auth/presentation/widgets/loading_show.dart';

class Edittodo extends StatelessWidget {
  const Edittodo({super.key, required this.editTodo});

  final TodoModel editTodo;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifier>(
      builder: (context, provider, child) {
        return Scaffold(
          body: provider.onEditLoaidng 
              ? LoadingShow()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Form(
                      key: provider.key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _todoImageCard(provider),
                          SizedBox(
                            height: 20,
                          ),
                          _textFormField(provider.titleCtrl, 'Title'),
                          SizedBox(
                            height: 15,
                          ),
                          _textFormField(provider.descCtrl, 'Description'),
                          SizedBox(
                            height: 15,
                          ),
                          _textFormField(
                              provider.imageDescCtrl, 'Image Description'),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 70,
                            child: Row(children: [
                              Expanded(
                                child: RadioListTile<bool>(
                                  dense: true,
                                  title: Text(
                                    'Completed',
                                    style: 14.sp(color: Color(0xFFBDBDBD)),
                                  ),
                                  visualDensity: VisualDensity(horizontal: -4),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 35),
                                  value: true,
                                  groupValue: provider.completed,
                                  onChanged: (value) {
                                    provider.getBool(value!);
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<bool>(
                                    dense: true,
                                    title: Text(
                                      'Incompleted',
                                      style: 14.sp(color: Color(0xFFBDBDBD)),
                                    ),
                                    visualDensity:
                                        VisualDensity(horizontal: -4),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: -10),
                                    value: false,
                                    groupValue: provider.completed,
                                    onChanged: (value) {
                                      provider.getBool(value!);
                                    }),
                              )
                            ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      fixedSize: Size(80, 32),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      backgroundColor: Color(0xFFBDBDBD),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      side: BorderSide(color: Colors.white)),
                                  onPressed: () {
                                    AppNavigator.pop(context);
                                  },
                                  child: Text(
                                    'Back',
                                    style: 15.sp(),
                                  )),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      fixedSize: Size(80, 32),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      backgroundColor: Color(0xFFBDBDBD),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      side: BorderSide(color: Colors.white)),
                                  onPressed: () async {
                                    final success = await provider.onEditTodo();
                                    if (success) {
                                      AppNavigator.pop(context, success);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('Updated success')));
                                    }
                                  },
                                  child: Text(
                                    'OK',
                                    style: 15.sp(),
                                  ))
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
              backgroundImage: notifier.imageUrl!.isNotEmpty
                  ? FileImage(File(notifier.imageUrl!))
                  : notifier.editTodo!.imageUrl.isNotEmpty
                      ? NetworkImage(
                          notifier.editTodo!.imageUrl.first.url.toString())
                      : null,
              radius: 80,
              child: notifier.editTodo!.imageUrl.isEmpty &&
                      notifier.imageUrl!.isEmpty
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

Widget _textFormField(TextEditingController controller, String hint) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFBDBDBD),
        hintText: hint,
        hintStyle: 14.sp(color: const Color.fromARGB(255, 103, 102, 102)),
        errorStyle: 10.sp(color: Colors.red),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white)),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6)),
  );
}
