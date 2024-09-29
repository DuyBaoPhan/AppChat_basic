
import 'package:tweet_app/src/features/tweet/submodules/chat/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  final String? id;

  const ChatMessages({Key? key, this.id}) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
   String? chatId;

  @override
  void initState() {
    super.initState();
    generateChatId();
  }

  Future<void> generateChatId() async {
    // lấy thông tin của người dùng hiện tại
    final me = FirebaseAuth.instance.currentUser!;

    // biến recipientId lưu giá trị là Id của người dùng cụ thể
    String recipientId = '#';

    // truy vấn tất cả User có trong FirebaseFirestore
    final userSnapshot = await FirebaseFirestore.instance.collection('users').get();
    // đưa tất cả User vào list
    List<Map<String, dynamic>> userList = userSnapshot.docs.map((userDoc) => userDoc.data()).toList();

    // duyệt qua tất cả user để lấy id của user tương ứng
    for (final userData in userList)
    {
      if (userData['identifier'] == (widget.id ?? ''))
      {
        recipientId = userData['uidAuth'];
        break;
      }
    }

    final sortId = [me.uid,recipientId];
    sortId.sort();
    final generatedChatId = 'chat${sortId[0]}##vs##${sortId[1]}';
    setState(() {
      chatId = generatedChatId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser!;
    if (chatId == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .doc(chatId)
          .collection('conversation')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
          );
        }
        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No messages',
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
          );
        }
        if (chatSnapshot.hasError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        final loadedMessages = chatSnapshot.data!.docs;
        final filteredMessages = loadedMessages.toList();
         //     .where((message) =>
         // (message['userId'] == me.uid && message['RecipientName'] == id)
         //     ||
         // message['username'] == id && message['RecipientId'] == me.uid)
         //     .toList();

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 30, left: 13, right: 13),
          physics: const BouncingScrollPhysics(),
          reverse: true,
          itemCount: filteredMessages.length,
          itemBuilder: (context, index) {
            final chatMessage = filteredMessages[index].data();
            final nextChatMessage = index + 1 < filteredMessages.length
                ? filteredMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
            nextChatMessage != null ? nextChatMessage['userId'] : null;

            final nextUserisSame = nextMessageUserId == currentMessageUserId;
            if (nextUserisSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: me.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: me.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
