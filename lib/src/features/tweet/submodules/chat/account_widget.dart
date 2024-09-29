// account_widget.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:tweet_app/src/features/tweet/models/user_request_model.dart';

class AccountWidget extends StatefulWidget {
  final UserRequestModel user;

  const AccountWidget(this.user);

  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  String latestMessage = '';
  DateTime? latestMessageTime;

  @override
  void initState() {
    super.initState();
    // Lấy tin nhắn mới nhất khi khởi tạo widget
    fetchLatestMessage();
  }

  void fetchLatestMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final chatId = 'chat${user?.uid}##vs##${widget.user.uidAuth}';

    final querySnapshot = await FirebaseFirestore.instance
        .collection('chat')
        .doc(chatId)
        .collection('conversation')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final latestMessageData = querySnapshot.docs.first.data();
      setState(() {
        latestMessage = latestMessageData['text'] ?? '';
        latestMessageTime = (latestMessageData['createdAt'] as Timestamp).toDate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0), // Loại bỏ khoảng trắng xung quanh ListTile
        leading: CircleAvatar(
          backgroundImage: Image.network(widget.user.iconPhoto).image,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.user.identifier,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (latestMessageTime != null)
              Text(
                // Format thời gian theo ý bạn (ví dụ: HH:mm)
                '${latestMessageTime!.hour}:${latestMessageTime!.minute}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        subtitle: latestMessage.isNotEmpty
            ? Text(
          latestMessage.length > 50
              ? '${latestMessage.substring(0, 50)}...'
              : latestMessage,
          style: const TextStyle(color: Colors.grey),
        )
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(id: widget.user.identifier),
            ),
          );
        },
      ),
    );
  }
}
