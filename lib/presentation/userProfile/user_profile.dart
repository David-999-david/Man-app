import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/userProfile/addedProfile/add_profile_image.dart';
import 'package:user_auth/presentation/userProfile/notifier/user_notifier.dart';
import 'package:user_auth/presentation/widgets/loading_show.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserNotifier()..getUserProfile(),
      child: Consumer<UserNotifier>(
        builder: (context, notifier, child) {
          return Scaffold(
            backgroundColor: Colors.blueGrey,
            body: notifier.isLoading
                ? LoadingShow()
                : CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        // floating: true,
                        // snap: true,
                        expandedHeight: 250,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(8)),
                        actions: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.46,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          decoration: BoxDecoration(
                                              color: Colors.teal,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: AddProfileImage()),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Upload Profile',
                                style: 15.sp(color: Colors.white),
                              ))
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              textAlign: TextAlign.center,
                              notifier.user!.name.toString(),
                              style: 20.sp(color: Colors.white),
                            ),
                            titlePadding: EdgeInsets.only(left: 20, bottom: 10),
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  notifier.user!.imageUrl.toString(),
                                  fit: BoxFit.cover,
                                ),
                                DecoratedBox(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                      Colors.transparent,
                                      Colors.black54,
                                    ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter)))
                              ],
                            )),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        sliver: SliverList(
                            delegate: SliverChildListDelegate([
                          _userSettings(
                              Icons.phone_enabled_rounded, 'Contact', () {}),
                          _userSettings(Icons.headset_rounded, 'Music', () {}),
                          _userSettings(Icons.movie, 'Movie', () {}),
                          _userSettings(
                              Icons.hide_image_rounded, 'Hide', () {}),
                          _userSettings(Icons.history_toggle_off_rounded,
                              'History', () {}),
                          _userSettings(
                              Icons.currency_exchange, 'Exchange Rate', () {}),
                          _userSettings(Icons.newspaper, 'World News', () {}),
                          _userSettings(Icons.energy_savings_leaf,
                              'Battery saver', () {}),
                          _userSettings(Icons.logout_outlined, 'Log out',
                              notifier.signOut),
                        ])),
                      )
                    ],
                  ),
          );
        },
      ),
    );
  }
}

Widget _userSettings(IconData icon, String label, void Function() onTap) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    height: 60,
    child: InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Colors.grey,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                label,
                style: 16.sp(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
