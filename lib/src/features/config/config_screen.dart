import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tweet_app/src/features/config/services/logout_service.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  late final LogoutService logoutService;

  @override
  void initState() {
    logoutService = Modular.get<LogoutService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('SETTINGS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Modular.to.pop(); // Quay lại màn hình trước đó
          },
        ),
      ),
      body: Column(
        children: [
          const ListTile(
            title: Text('Account'),
            leading: Icon(Icons.person, color: Colors.blueAccent, size: 30),
          ),
          const ListTile(
            leading: Icon(Icons.settings_applications, color: Colors.blueAccent, size: 30),
            title: Text('App Details'),
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout, color: Colors.blueAccent, size: 30),
            onTap: () {
              logoutService.logoutUser().then((value) {
                Modular.to.navigate('../auth');
              });
            },
          )
        ],
      ),
    );
  }
}
