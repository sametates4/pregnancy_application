import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy_application/service/strings.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key, required this.id, required this.name}) : super(key: key);
  final String id, name;
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {

  final _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('message').doc(widget.id).collection('chat').orderBy('time', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    if(snapshot.data!.docs.isNotEmpty){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        reverse:  true,
                        itemBuilder: (context, index) {
                          var newIndex = snapshot.data!.docs[index];
                          return BubbleNormal(
                            text: newIndex['text'],
                            isSender: newIndex['senderId'] == FirebaseAuth.instance.currentUser!.uid ? true : false,
                            color: const Color(0xFF1B97F3),
                            tail: true,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          );
                        },
                      );
                    }else{
                      return const Center(child: Text(emptyChatMessage),);
                    }
                  }else{
                    return const Center(child: CircularProgressIndicator(),);
                  }
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextField(
                controller: _message,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: message,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: ()async{
                      await FirebaseFirestore.instance.collection('message').doc(widget.id).collection('chat').doc().set({
                        'text': _message.text,
                        'senderId': FirebaseAuth.instance.currentUser!.uid,
                        'time': FieldValue.serverTimestamp(),
                      });
                      _message.clear();
                    },
                  )
                )
              ),
            ),
          ],
        ),
      )
    );
  }
}
