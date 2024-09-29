import 'package:flutter/material.dart';
import 'account_list.dart';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({Key? key}) : super(key: key);

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: AccountList(),
    );
  }
}
