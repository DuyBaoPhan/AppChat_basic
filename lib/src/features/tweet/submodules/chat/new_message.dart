import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tweet_app/src/features/tweet/submodules/chat/notifi_service.dart';


class NewMessage extends StatefulWidget {
  final String? id;

  const NewMessage({Key? key, this.id}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.intiNotification();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData =
    await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    String recipientId = '#';

    final userSnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<Map<String, dynamic>> userList =
    userSnapshot.docs.map((userDoc) => userDoc.data() as Map<String, dynamic>).toList();

    for (final userData in userList) {
      if (userData['identifier'] == (widget.id ?? '')) {
        recipientId = userData['uidAuth'];
        break;
      }
    }

    final sortId = [user.uid, recipientId];
    sortId.sort();
    String id = 'chat${sortId[0]}##vs##${sortId[1]}';
    FirebaseFirestore.instance.collection('chat').doc(id).collection('conversation').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['identifier'],
      'userImage': userData.data()!['imgUrl'],
      'RecipientName': widget.id,
      'RecipientId': recipientId,
    });

    _notificationService.showNotification(
      userId: 0,
      title: 'New Message',
      body: 'You have a new message from ${userData.data()!['identifier']}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 0, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(
                color: Colors.black,
              ),
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              maxLength: null,
              enableSuggestions: true,
              decoration: const InputDecoration(
                labelText: 'Message',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submitMessage,
            icon: const Icon(Icons.send_rounded),
            iconSize: 40,
          ),
        ],
      ),
    );
  }
}
