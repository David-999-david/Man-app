import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/user/auth/forgot_password/notifier/forgot_password_notifier.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordNotifier(),
      child: Consumer<ForgotPasswordNotifier>(
        builder: (context, provider, child) {
          return Scaffold(
            body: provider.loading
                ? SpinKitWave(
                    color: Colors.red,
                    duration: Duration(seconds: 10),
                    size: 30,
                  )
                : Form(
                    key: provider.key,
                    child: Column(
                      children: [
                        Text(
                          'Email',
                          style: 16.sp(color: Color(0xFFFFAB91)),
                        ),
                        TextFormField(
                          controller: provider.emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFBDBDBD),
                            hintText: 'example@gamil.com',
                            hintStyle: 13.sp(),
                            errorStyle: 13.sp(color: Colors.red),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter you email';
                            }
                            if (EmailValidator.validate(value)) {
                              return 'Please enter a valid email';
                            }
                          },
                        ),
                        ElevatedButton(onPressed: () {}, child: Text('Submit'))
                      ],
                    )),
          );
        },
      ),
    );
  }
}
