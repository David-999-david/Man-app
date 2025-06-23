import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/loading_show.dart';
import 'package:user_auth/presentation/user/auth/change_password/notifier/change_password_notifier.dart';
import 'package:user_auth/presentation/user/auth/login/login_screen.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChangePasswordNotifier(),
      child: Consumer<ChangePasswordNotifier>(
        builder: (context, psw, child) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    AppNavigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            body: psw.loading
                ? LoadingShow()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: psw.key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Password',
                            style: 16.sp(color: Color(0xFFFFAB91)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _textFormField(psw, psw.newPswKey,
                                'Enter new password', psw.newPsw,
                                validator: psw.validateNewPsw),
                          ),
                          Text(
                            'Confirm Password',
                            style: 16.sp(color: Color(0xFFFFAB91)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _textFormField(psw, psw.confirmPswKey,
                                'Confirm your new password', psw.confirmPsw,
                                validator: psw.validateConfirmPsw),
                          ),
                          Center(
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    fixedSize: Size(80, 32),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    backgroundColor: Color(0xFFBDBDBD),
                                    side: BorderSide(color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: psw.loading
                                    ? null
                                    : () async {
                                        if (psw.key.currentState!.validate()) {
                                          await psw.changePassword();
                                          psw.success
                                              ? AppNavigator.pushAndRemoveUntil(
                                                  LoginScreen())
                                              : null;
                                        }
                                      },
                                child: Text(
                                  'Submit',
                                  style: 15.sp(),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

Widget _textFormField(ChangePasswordNotifier notifier,
    GlobalKey<FormFieldState> key, String hintText, TextEditingController ctrl,
    {required String? Function(String?) validator}) {
  return Column(
    children: [
      TextFormField(
        key: key,
        controller: ctrl,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFBDBDBD),
          hintText: hintText,
          hintStyle: 15.sp(),
          errorStyle: 13.sp(color: Colors.red),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white)),
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        ),
        validator: validator,
      ),
    ],
  );
}
