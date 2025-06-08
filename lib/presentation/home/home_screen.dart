import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/circular_loading.dart';
import 'package:user_auth/presentation/home/notifier/user_notifier.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Home',
            style: 21.sp(color: Color(0xFFBDBDBD)),
          ),
          centerTitle: true,
        ),
        body: Consumer<UserNotifier>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return CircularLoading();
            }
            if (provider.user == null) {
              return Center(
                child: Text('Failed to load user,please log in again'),
              );
            }
            return Center(
              child: Container(
                decoration: BoxDecoration(color: Color(0xFF212121)),
                child: Column(
                  children: [
                    Text(
                      provider.user!.name,
                      style: 17.sp(color: Colors.white),
                    ),
                    // Text(provider.user!.email),
                    // Text(provider.user!.createdAt.toIso8601String()),
                    ElevatedButton(
                        onPressed: () {
                          provider.signOut();
                        },
                        child: Text(
                          'Sign out',
                          style: 16.sp(color: Color(0xFFBDBDBD)),
                        ))
                  ],
                ),
              ),
            );
          },
        ));
  }
}
