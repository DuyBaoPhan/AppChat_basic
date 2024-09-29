// chat_screen.dart
import 'package:flutter/material.dart';
import 'account_list.dart';
import 'account_list_screen.dart';

class chatlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: AccountListScreen(),
    );
  }
}