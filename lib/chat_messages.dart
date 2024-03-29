import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenuser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat').orderBy(
            'createAt', descending: true).snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('no messages found'),
            );
          }
          if (chatSnapshot.hasError) {
            return const Center(
              child: Text('something error'),
            );
          }
          final loadedMessage = chatSnapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(
                bottom: 40,
                left: 13,
                right: 13
            ),
            reverse: true,
            itemCount: loadedMessage.length,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedMessage[index].data();
              final nextMessage = index + 1 < loadedMessage.length
                  ? loadedMessage[index + 1].data()
                  : null;
              final currentMessageuserid = chatMessage['userID'];
              final nextmessageuserid = nextMessage != null
                  ? nextMessage['userID']
                  : null;
              final nextuserissame = nextmessageuserid == currentMessageuserid;
              if (nextuserissame) {
                return MessageBubble.next(message: chatMessage['text'],
                    isMe: authenuser.uid == currentMessageuserid);
              }
              else {
                return MessageBubble.first(userImage: chatMessage['user_image'],
                    username: chatMessage['user_name'],
                    message: chatMessage['text'],
                    isMe: authenuser.uid == currentMessageuserid);
              }
            },
          );
        });
  }
}