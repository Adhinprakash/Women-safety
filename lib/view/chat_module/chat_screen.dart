import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_saftey/utils/consts.dart';
import 'package:women_saftey/view/chat_module/message_textfield.dart';
import 'package:women_saftey/view/chat_module/single_message.dart';

class ChatScreen extends StatefulWidget {
  final String friendId;
  final String friendName;
  final String currentUserId;
  const ChatScreen(
      {super.key,
      required this.friendId,
      required this.friendName,
      required this.currentUserId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  String? type;
  String? myname;

  final ScrollController _scrollController = ScrollController();
void scrollToBottom() {
  if (_scrollController.hasClients) {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}

  getstatus() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.currentUserId)
        .get()
        .then((value) {
      setState(() {
        type = value.data()!['type'];
        myname = value.data()!['name'];
      });
    });
  }

  @override
  void initState() {
    getstatus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPersistentFrameCallback((_){
// scrollToBottom();
//     });
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 207, 166, 210),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(widget.friendName),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.currentUserId)
                      .collection("messages")
                      .doc(widget.friendId)
                      .collection("chats").orderBy('date',descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.length < 1) {
                        return Center(
                          child: Text(
                            type == "parent"
                                ? "TALK WITH CHILD"
                                : "TALK WITH PARENT",
                            style: TextStyle(fontSize: 30),
                          ),
                        );

                      }
                        WidgetsBinding.instance.addPostFrameCallback((_) {
    scrollToBottom();
  });
                      return Container(
                        child: ListView.builder(
                          controller: _scrollController,

                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              bool isMe = snapshot.data!.docs[index]
                                      ['senderId'] ==
                                  widget.currentUserId;
                              final data = snapshot.data!.docs[index];
                              return Dismissible(
                                onDismissed: (direction) {
                                  
                                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.currentUserId)
                      .collection("messages")
                      .doc(widget.friendId)
                      .collection("chats").doc(data.id).delete();
  
                                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.friendId)
                      .collection("messages")
                      .doc(widget.currentUserId)
                      .collection("chats").doc(data.id).delete().then((value)=>Fluttertoast.showToast(msg: "Message deleted successfuly"));


                                },
                                key:
                              UniqueKey()
                               , child: SingleMessage(
                                message: data['message'],
                                date: data['date'],
                                isMe: isMe,
                                friendName: widget.friendName,
                                myName: myname,
                                type: data['type'],
                              ));
                            }),
                      );
                    }
                    return progressIndicator(context);
                  })),
          ModernMessageInput(currentId: widget.currentUserId,friendId: widget.friendId,)
        ],
      ),
    ));
  }
}
