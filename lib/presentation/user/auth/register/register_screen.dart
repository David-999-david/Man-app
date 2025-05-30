import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/presentation/user/auth/login/login_screen.dart';
import 'package:user_auth/presentation/user/auth/register/notifier/register_notifier.dart';
import 'package:user_auth/theme/app_text_style.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: ChangeNotifierProvider(
          create: (_) => RegisterNotifier(),
          child: Consumer<RegisterNotifier>(
            builder: (context, provider, child) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                                padding:
                                    const EdgeInsets.only(top: 25, left: 7),
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
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFBDBDBD),
                                      // labelText: '@email',
                                      // labelStyle: 15.sp(),
                                      hintText: 'example@gmail.com',
                                      hintStyle: 15.sp(),
                                      errorStyle: 15.sp(color: Colors.red),
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
                                              BorderSide(color: Colors.white))),
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
                                padding: const EdgeInsets.only(top: 5, left: 7),
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
                                      errorStyle: 15.sp(color: Colors.red),
                                      suffixIcon: IconButton(
                                          color: Colors.black,
                                          iconSize: 20,
                                          onPressed: () {
                                            provider.onShown();
                                          },
                                          icon: Icon(provider.isVisable
                                              ? Icons.visibility_off
                                              : Icons.visibility)),
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
                                              BorderSide(color: Colors.white))),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: OutlinedButton(
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
                                        if (formKey.currentState!.validate()) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(),
                                              ));
                                        }
                                      },
                                      child: Text(
                                        'Register',
                                        style: 15.sp(),
                                      )),
                                ),
                              )
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
