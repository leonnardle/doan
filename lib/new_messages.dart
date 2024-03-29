import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewMessage extends StatefulWidget{
  const NewMessage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewMessagesState();
  }
}

class _NewMessagesState extends State<NewMessage>{
  final messagecontroller=TextEditingController();
  @override
  void dispose() {
    messagecontroller.dispose();
    super.dispose();
  }
  void submitMessage() async {
    final enterMessage = messagecontroller.text;
    if (enterMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    messagecontroller.clear();

    final user = FirebaseAuth.instance.currentUser!;
      final userData = await FirebaseFirestore.instance.collection('user_info').doc(user.email).get();
        FirebaseFirestore.instance.collection('chat').add({
          'user_image': userData.data()!['image'],
          'text': enterMessage,
          'createAt': Timestamp.now(),
          'userID': user.uid,
          'use_name': userData.data()!['name']
        });


  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 15,right: 1,bottom: 14),
    child: Row(
      children: [
        Expanded(child: TextField(
          controller: messagecontroller,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          enableSuggestions: true,
          decoration: InputDecoration(labelText: 'send a message'),

        )),
        IconButton( icon: Icon(Icons.send),onPressed: submitMessage,)
      ],
    ),
    );
  }

}