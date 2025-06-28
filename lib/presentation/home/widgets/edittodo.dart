import 'package:flutter/material.dart';
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
        return provider.loading
            ? LoadingShow()
            : Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Form(
                      key: provider.key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _textFormField(provider.titleCtrl, 'Title'),
                          SizedBox(
                            height: 15,
                          ),
                          _textFormField(provider.descCtrl, 'Description'),
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

Widget _textFormField(TextEditingController controller, String hint) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFBDBDBD),
        hintText: hint,
        hintStyle: 14.sp(),
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
