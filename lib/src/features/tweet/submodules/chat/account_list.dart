// account_list.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'account_widget.dart';
import 'package:tweet_app/src/features/tweet/models/user_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountList extends StatefulWidget {
  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  late TextEditingController _searchController;
  String currentUserID = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: const InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            var users = snapshot.data!.docs
                .map((doc) => UserRequestModel.fromMap(doc.data() as Map<String, dynamic>))
                .where((user) =>
            user.uidAuth != currentUserID &&
                (user.identifier.toLowerCase().contains(_searchController.text.toLowerCase())))
                .toList();

            return Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];

                  return FutureBuilder(
                    future: hasMessages(user.uidAuth),
                    builder: (context, AsyncSnapshot<bool> hasMessagesSnapshot) {
                      if (hasMessagesSnapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink(); // Trả về widget rỗng trong trạng thái loading
                      }

                      if (hasMessagesSnapshot.hasError || !hasMessagesSnapshot.data!) {
                        return const SizedBox.shrink(); // Trả về widget rỗng nếu có lỗi hoặc không có tin nhắn
                      }

                      return Column(
                        children: [
                          AccountWidget(user),
                          if (index < users.length - 1)
                            Divider(
                              color: Colors.grey.withOpacity(0.4),
                              thickness: 1,
                              height: 4,
                              indent: 16,
                              endIndent: 16,
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // Hàm kiểm tra xem có tin nhắn giữa hai người dùng hay không
  Future<bool> hasMessages(String recipientId) async {
    final user = FirebaseAuth.instance.currentUser;
    final chatId = 'chat${user?.uid}##vs##$recipientId';

    final querySnapshot = await FirebaseFirestore.instance
        .collection('chat')
        .doc(chatId)
        .collection('conversation')
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
