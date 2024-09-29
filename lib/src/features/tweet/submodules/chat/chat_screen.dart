import 'package:flutter/material.dart';
import 'package:tweet_app/src/features/tweet/submodules/chat/chat_messages.dart';
import 'package:tweet_app/src/features/tweet/submodules/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatScreen extends StatefulWidget {
  final String? id;

  const ChatScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? url;

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
    getUrl();
  }

  void getUrl() async {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref().child('User_images/$userid.jpeg');
    try {
      final geturl = await ref.getDownloadURL();
      setState(() {
        url = geturl;
      });
    } catch (e) {
      print('Failed to fetch profile. please login again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: Theme.of(context).appBarTheme.scrolledUnderElevation,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Row(
            children: [
              CircleAvatar(
                foregroundImage: url != null ? NetworkImage(url!) : null,
              ),
              const SizedBox(width: 8),
              Text(
                widget.id ?? '',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessages(id: widget.id ?? '')),
          const SizedBox(height: 5),
          NewMessage(id: widget.id ?? ''),
        ],
      ),
    );
  }
}
