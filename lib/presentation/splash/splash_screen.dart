import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/presentation/splash/splash_notifier.dart';
import 'package:user_auth/presentation/widgets/dv_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashNotifier()..determineStart(),
      child: Consumer<SplashNotifier>(
        builder: (context, provoider, child) {
          if (provoider.checking) {
            return Scaffold(
              body: Center(child: DvLogo()),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
