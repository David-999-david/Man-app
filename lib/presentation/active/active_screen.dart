import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/presentation/active/notifier/active_notifier.dart';
import 'package:user_auth/presentation/home/home_screen.dart';
import 'package:user_auth/presentation/setting/setting_screen.dart';
import 'package:user_auth/presentation/userProfile/user_profile.dart';

class ActiveScreen extends StatelessWidget {
  const ActiveScreen({super.key, this.pageIdx = 0});

  final int pageIdx;

  @override
  Widget build(BuildContext context) {
    List<Widget> _screen = [HomeScreen(), SettingScreen(), UserProfile()];

    return ChangeNotifierProvider(
      create: (context) => ActiveNotifier()..getIdx(pageIdx),
      child: Consumer<ActiveNotifier>(
        builder: (context, notifier, child) {
          return Scaffold(
            body: _screen[notifier.currIdx],
            bottomNavigationBar: NavigationBar(
                selectedIndex: notifier.currIdx,
                onDestinationSelected: (value) {
                  notifier.getIdx(value);
                },
                backgroundColor: Colors.white,
                destinations: [
                  NavigationDestination(icon: Icon(Icons.home), label: 'HOME'),
                  NavigationDestination(
                      icon: Icon(Icons.settings), label: 'SETTING'),
                  NavigationDestination(
                      icon: Icon(Icons.bloodtype_sharp), label: 'User')
                ]),
          );
        },
      ),
    );
  }
}
