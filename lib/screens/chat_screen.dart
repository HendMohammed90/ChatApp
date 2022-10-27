import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

final _cloudDataBase = FirebaseFirestore.instance;
dynamic logedInUser;

class ChatScreen extends StatefulWidget {
  static String route = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String massege;

  void getUserCreated() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        logedInUser = user;
        print('The loggedIn User Data is Down');
        print(logedInUser);
      }
    } catch (eror) {
      print(eror);
    }
  }
//to Show stream of message
//   void messageStreamm() async {
//     await for (var snapshot
//         in _cloudDataBase.collection('messages').snapshots()) {
//       for (var message in snapshot.docs) {
//         print(message.data());
//       }
//     }
//   }

  @override
  void initState() {
    super.initState();
    getUserCreated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
                // messageStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        massege = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFFF3EFF5),
                          border: Border(
                              left:
                                  BorderSide(color: kDarkPurple, width: 0.2))),
                      child: FloatingActionButton(
                        backgroundColor: Colors.white.withOpacity(0),
                        elevation: 0,
                        onPressed: () {
                          messageTextController.clear();
                          _cloudDataBase.collection('messages').add({
                            'text': massege,
                            'sender': logedInUser.email,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                        },
                        child: const Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // <Widget>[
          //   StreamBuilder<QuerySnapshot>(
          //       stream: _cloudDataBase.collection('messages').snapshots(),
          //       builder: (context, snapshot) {
          //         if (snapshot.hasData) {
          //           final messages = snapshot.data.docs;
          //           List<Text> messageList = [];
          //           for (var singleMessage in messages) {
          //             final MesgText = singleMessage.get('text');
          //             final MesgSender = singleMessage.get('sender');
          //             final Mesgtime = singleMessage.get('timestamp') ?? '';
          //
          //             print(MesgText);
          //             messageList.add(
          //               Text('$MesgText is from $MesgSender at $Mesgtime'),
          //             );
          //           }
          //           return Expanded(
          //             child: ListView(
          //               children: messageList,
          //             ),
          //           );
          //         } else if (snapshot.hasError) {
          //           return Center(
          //             child: Text('${snapshot.hasError}'),
          //           );
          //         } else {
          //           return const Center(
          //             child: CircularProgressIndicator(),
          //           );
          //         }
          //       }),
          //   Container(
          //     decoration: kMessageContainerDecoration,
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: <Widget>[
          //         Expanded(
          //           child: TextField(
          //             onChanged: (value) {
          //               //Do something with the user input.
          //               massege = value;
          //             },
          //             decoration: kMessageTextFieldDecoration,
          //           ),
          //         ),
          //         FlatButton(
          //           onPressed: () {
          //             //Implement send functionality.
          //             _cloudDataBase.collection('messages').add(
          //               {
          //                 'text': massege,
          //                 'sender': logedInUser,
          //                 'timestamp': FieldValue.serverTimestamp(),
          //               },
          //             );
          //           },
          //           child: Text(
          //             'Send',
          //             style: kSendButtonTextStyle,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _cloudDataBase
            .collection('messages')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: kDarkPurple,
                ),
              ),
            );
          }
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final currentUser = logedInUser.email;
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final messageTime = message.get('timestamp');

            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              time: messageTime != null
                  ? messageTime.toDate().toString()
                  : 'Time not available',
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
                reverse:
                    true, ///// to make list of message appears the last one
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: messageBubbles),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({this.sender, this.text, this.time, this.isMe});

  final String sender;
  final String text;
  final String time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              sender,
              style: TextStyle(color: kDarkPurple, fontSize: 12.0),
            ),
          ),
          Material(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMe ? 30.0 : 0),
                  topRight: Radius.circular(isMe ? 0 : 30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0)),
              elevation: 5.0,
              color: isMe ? kLightPurple : kSoftBlue,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text(
                  '$text',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              time.substring(0, 16),
              style: TextStyle(
                color: kDarkPurple,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
