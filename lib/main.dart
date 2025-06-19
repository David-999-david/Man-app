import 'package:flutter/material.dart';
import 'package:user_auth/core/network/dio_client.dart';
import 'package:user_auth/presentation/user/auth/login/login_screen.dart';
import 'package:user_auth/core/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioClient.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigationKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: LoginScreen(),
    );
  }
}
