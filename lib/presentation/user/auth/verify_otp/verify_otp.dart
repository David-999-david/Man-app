import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/loading_show.dart';
import 'package:user_auth/presentation/user/auth/change_password/change_password.dart';
import 'package:user_auth/presentation/user/auth/verify_otp/notifier/verify_otp_notifier.dart';

class VerifyOtp extends StatelessWidget {
  const VerifyOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VerifyOtpNotifier>(
      builder: (context, otp, child) {
        return otp.loading
            ? LoadingShow()
            : Scaffold(
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
                body: Container(
                  decoration: BoxDecoration(color: Color(0xFF212121)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Please check your mail',
                          style: 19.sp(color: Color(0xFFBDBDBD)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'We have send OTP code in mail',
                          style: 16.sp(color: Color(0xFFBDBDBD)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: PinCodeTextField(
                            // backgroundColor: Colors.white,
                            appContext: context,
                            length: 6,
                            keyboardType: TextInputType.number,
                            animationType: AnimationType.fade,
                            obscureText: true,
                            obscuringCharacter: '*',
                            textStyle: 15.sp(color: Colors.white),
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                activeColor: Colors.blue,
                                inactiveFillColor: Colors.amber,
                                selectedFillColor: Colors.pink,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white),
                            onChanged: (value) {
                              otp.updatePin(value);
                            },
                            onCompleted: (value) async {
                              await otp.verifyOtp();
                              otp.success
                                  ? AppNavigator.push(context, ChangePassword())
                                  : ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                      otp.errMsg.toString(),
                                      style: 15.sp(color: Colors.red),
                                    )));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
