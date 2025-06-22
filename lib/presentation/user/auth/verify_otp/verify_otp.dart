import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/presentation/user/auth/verify_otp/notifier/verify_otp_notifier.dart';

class VerifyOtp extends StatelessWidget {
  const VerifyOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VerifyOtpNotifier>(
      builder: (context, otp, child) {
        return Scaffold(
          body: Center(
              child: PinCodeTextField(
            appContext: context,
            length: 6,
            controller: otp.codeCtrl,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white),
          )),
        );
      },
    );
  }
}
