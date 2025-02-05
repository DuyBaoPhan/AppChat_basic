import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:tweet_app/src/features/tweet/store/drawer_store.dart';
import 'package:tweet_app/src/features/tweet/ui/components/mini_profile_information.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late final DrawerStore drawerStore;

  @override
  void initState() {
    drawerStore = Modular.get();
    drawerStore.loadInformation();
    autorun((_) {
      if (drawerStore.screenState == DrawerScreenState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${drawerStore.errorMessage}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white, // Màu nền xanh nhạt
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Observer(
              builder: (_) => drawerStore.screenState ==
                  DrawerScreenState.loaded
                  ? MiniProfileInformation(
                  profileImage: Image.network(drawerStore.user.iconPhoto),
                  followersAmount: drawerStore.followersAmount,
                  followingAmount: drawerStore.followingAmount,
                  identifier: drawerStore.user.identifier)
                  : const CircularProgressIndicator(),
            ),
            Expanded(
              child: ListView(
                children: [
                  const Divider(
                    thickness: 1.5,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.insert_emoticon_outlined,
                      color: Colors.black, // Màu icon trắng
                    ),
                    title: const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.black, // Màu chữ trắng
                      ),
                    ),
                    onTap: () {
                      Modular.to.pop();
                      Modular.to
                          .pushNamed('profile/${drawerStore.returnUidAuth()}');
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.black, // Màu icon trắng
                    ),
                    title: const Text(
                      'Setting',
                      style: TextStyle(
                        color: Colors.black, // Màu chữ trắng
                      ),
                    ),
                    onTap: () {
                      Modular.to.pop();
                      Modular.to.pushNamed('/config/');
                    },
                  ),
                  const Divider(
                    thickness: 1.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
