import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/presentation/active/active_screen.dart';
import 'package:user_auth/presentation/active/notifier/active_notifier.dart';
import 'package:user_auth/presentation/user/auth/forgot_password/forgot_password.dart';
import 'package:user_auth/presentation/user/auth/login/notifier/login_notifier.dart';
import 'package:user_auth/presentation/user/auth/register/register_screen.dart';
import 'package:user_auth/core/theme/app_text_style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: ChangeNotifierProvider(
          create: (_) => LoginNotifier(),
          child: Consumer<LoginNotifier>(
            builder: (context, provider, child) {
              return provider.isLoading
                  ? Center(
                      child: SpinKitWave(
                        color: Colors.red,
                        size: 30,
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Color(0xFF212121)),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image.asset(
                                  height: 75,
                                  width: 75,
                                  'assets/images/DV.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 25, left: 7),
                                      child: Text(
                                        'Email',
                                        style: 16.sp(color: Color(0xFFFFAB91)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: provider.emailCtr,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xFFBDBDBD),
                                            // labelText: '@email',
                                            // labelStyle: 15.sp(),
                                            hintText: 'example@gmail.com',
                                            hintStyle: 15.sp(),
                                            errorText: provider.emailErr,
                                            errorStyle:
                                                13.sp(color: Colors.red),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 6),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.white))),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter you email';
                                          }
                                          if (!EmailValidator.validate(value)) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 7),
                                      child: Text(
                                        'Password',
                                        style: 16.sp(color: Color(0xFFFFAB91)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: provider.pssCtr,
                                        obscureText: provider.isVisable,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xFFBDBDBD),
                                            // labelText: 'password',
                                            // labelStyle: 15.sp(),
                                            hintText: 'Enter password',
                                            hintStyle: 15.sp(),
                                            // error: Text(
                                            //     provider.errMsg.toString()),
                                            errorText: provider.pswErr,
                                            errorStyle:
                                                13.sp(color: Colors.red),
                                            suffixIcon: IconButton(
                                                color: Colors.black,
                                                iconSize: 20,
                                                onPressed: () {
                                                  provider.onShown();
                                                },
                                                icon: Icon(provider.isVisable
                                                    ? Icons.visibility_off
                                                    : Icons.visibility)),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 6),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.white))),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            AppNavigator.push(
                                                context, ForgotPassword());
                                          },
                                          child: Text(
                                            'Forgot password?',
                                            style:
                                                12.sp(color: Color(0xFFFFAB91)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFFBDBDBD),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 3),
                                                side: BorderSide(
                                                    color: Colors.white),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                fixedSize: Size(80, 32)),
                                            onPressed: provider.isLoading
                                                ? null
                                                : () async {
                                                    if (!formKey.currentState!
                                                        .validate()) {
                                                      return;
                                                    }
                                                    final success =
                                                        await provider.login();

                                                    if (success) {
                                                      AppNavigator
                                                          .pushAndRemoveUntil(
                                                              ChangeNotifierProvider(
                                                        create: (_) {
                                                          ActiveNotifier();
                                                        },
                                                        child: ActiveScreen(),
                                                      ));
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  'Login failed')));
                                                    }
                                                  },
                                            child: Text(
                                              'Log in',
                                              style: 15.sp(),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    Center(
                                        child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterScreen(),
                                            ));
                                      },
                                      child: RichText(
                                          text: TextSpan(
                                              style: 15.sp(),
                                              children: [
                                            TextSpan(
                                                text: 'Join us-',
                                                style: 14.sp(
                                                    color: Color(0xFFFFAB91))),
                                            TextSpan(
                                                text: 'Register now!',
                                                style: 14
                                                    .sp(
                                                        color:
                                                            Color(0xFFFFAB91))
                                                    .copyWith(
                                                        decoration:
                                                            TextDecoration
                                                                .underline))
                                          ])),
                                    ))
                                  ],
                                ))
                          ],
                        ),
                      ),
                    );
            },
          )),
    );
  }
}
