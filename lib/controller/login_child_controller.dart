import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:women_saftey/db/sharedprefereces.dart';
import 'package:women_saftey/utils/consts.dart';

class LoginChildController extends GetxController{
  var isPasswordShown = true.obs;
  final formData = Map<String, Object>().obs;
  var isLoading = true.obs;

  void togglePasswordVisibility(){
    isPasswordShown.value = !isPasswordShown.value;
  }

  Future<void> loginUser(BuildContext context) async {
     Get.dialog(
    const Center(child: CircularProgressIndicator()),
    barrierDismissible: false,
  );
try {
  UserCredential userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: formData['email'].toString(),
    password: formData['password'].toString(),
  );
      Get.back(); 

  if(userCredential.user!=null){


    FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get().then((value) {
      print(value['type']);
     if(value['type']=='parent'){
      MySharedPrefference.saveUserType('parent');
      Get.offAllNamed("/parentHome");
    }else{
      MySharedPrefference.saveUserType('child');
      Get.offAllNamed("/bottompage");
    }});

  }
} on FirebaseAuthException catch (e) {  
      isLoading.value=false;

      if (e.code == 'user-not-found') {
        dialogueBox(context, 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        dialogueBox(context, 'Wrong password provided for that user.');
        print('Wrong password provided for that user.');
      }

  }catch(e){   
      Get.back();
}}}