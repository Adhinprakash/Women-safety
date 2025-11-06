import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{

  void sendMessage(String? message,String type,[String? currentId,String? friendId])async {

  
  // _controller.clear();

    await FirebaseFirestore.instance.collection("users").
    doc(currentId).collection('messages')
    .doc(friendId).
    collection('chats').add({
      "senderId":currentId,
      "receiverId":friendId,
      "message":message,
      "type":type,
      "date":DateTime.now()
    });
     await FirebaseFirestore.instance.collection("users").
    doc(friendId).collection('messages')
    .doc(currentId).
    collection('chats').add({
      "senderId":currentId,
      "receiverId":friendId,
      "message":message,
      "type":type,
      "date":DateTime.now()
    });

  }

}