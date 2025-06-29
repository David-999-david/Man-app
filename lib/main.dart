import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_auth/core/network/dio_client.dart';
import 'package:user_auth/presentation/splash/splash_screen.dart';
import 'package:user_auth/core/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioClient.init();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANNON_KEY']!);
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
      home: SplashScreen(),
    );
  }
}
