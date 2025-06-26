import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/widgets/dv_logo.dart';
import 'package:user_auth/presentation/user/auth/forgot_password/notifier/forgot_password_notifier.dart';
import 'package:user_auth/presentation/user/auth/login/login_screen.dart';
import 'package:user_auth/presentation/user/auth/verify_otp/notifier/verify_otp_notifier.dart';
import 'package:user_auth/presentation/user/auth/verify_otp/verify_otp.dart';

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
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 50),
                    child: SingleChildScrollView(
                      child: Form(
                          key: provider.key,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () {
                                    AppNavigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 165,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: DvLogo(),
                                  )),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Center(
                                    child: Text(
                                      'Please enter your DV\'s registered email',
                                      style: 16.sp(color: Color(0xFFFFAB91)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      'Email',
                                      style: 16.sp(color: Color(0xFFFFAB91)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: provider.emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFBDBDBD),
                                      hintText: 'example@gamil.com',
                                      hintStyle: 15.sp(),
                                      errorText: provider.errmsg,
                                      errorStyle: 13.sp(color: Colors.red),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 6),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter you email';
                                      }
                                      if (!EmailValidator.validate(value)) {
                                        return 'Please enter a valid email';
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Center(
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xFFBDBDBD),
                                            fixedSize: Size(80, 32),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            side:
                                                BorderSide(color: Colors.white),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 3)),
                                        onPressed: provider.loading
                                            ? null
                                            : () async {
                                                if (!provider.key.currentState!
                                                    .validate()) {
                                                  return;
                                                }
                                                await provider.sendEmailOtp();
                                                provider.msg!.isNotEmpty
                                                    ? ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                provider.msg!)))
                                                    : null;
                                                provider.success
                                                    ? AppNavigator.push(
                                                        context,
                                                        MultiProvider(
                                                          providers: [
                                                            ChangeNotifierProvider(
                                                              create: (context) =>
                                                                  VerifyOtpNotifier(
                                                                provider
                                                                    .emailCtrl
                                                                    .text,
                                                              ),
                                                            ),
                                                            ChangeNotifierProvider
                                                                .value(
                                                              value: provider,
                                                            ),
                                                          ],
                                                          child: VerifyOtp(),
                                                        ))
                                                    : null;
                                              },
                                        child: Text(
                                          'Submit',
                                          style: 15.sp(),
                                        )),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
