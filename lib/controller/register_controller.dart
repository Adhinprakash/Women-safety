import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_saftey/model/usermodel.dart';
import 'package:women_saftey/utils/consts.dart';

class RegisterController extends GetxController{
  final formKey = GlobalKey<FormState>();
  var isPasswordShown = true.obs;
  var isRetypePasswordShown = true.obs;
  final formData = Map<String, Object>().obs;
  final isLoading = false.obs;


  void togglepasswordvisibility(){
 isPasswordShown.value=!isPasswordShown.value;
}
void toggleRetypePasswordVisibility(){
  isRetypePasswordShown.value=!isRetypePasswordShown.value;
}

 Future<void> registerUser(BuildContext context) async {
      Get.dialog(
    const Center(child: CircularProgressIndicator()),
    barrierDismissible: false,
  );
    formKey.currentState!.save();
    if (formData['password'] != formData['repassword']) {
      Get.defaultDialog(title: "Error", middleText: "Passwords do not match.");
      return;
    }

    try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: formData['cemail'].toString(),
        password: formData['password'].toString(),
      );
      Get.back();
   if(userCredential.user!=null){
    isLoading.value=false;
      final v = userCredential.user!.uid;
          DocumentReference<Map<String, dynamic>> db =
              FirebaseFirestore.instance.collection('users').doc(v);

            UserModel userModel=UserModel(
              id: v,
              childEmail: formData['cemail'].toString(),
              guardianEmail: formData['gemail'].toString(),
              name: formData['name'].toString(),
              phone: formData['phone'].toString(),
              type: 'child',
            );
            await db.set(userModel.toJson()).whenComplete((){
 Get.back(); 
      Get.offAllNamed("/loginChild");
            });
     
   }
    } on FirebaseAuthException catch (e) {
      isLoading.value=false;
      Get.defaultDialog(title: "Error", middleText: e.message ?? "Unknown error");
    } catch (e) {
      isLoading.value=false;
      Get.defaultDialog(title: "Error", middleText: "Something went wrong");
      Get.back();
    }
  }


  

}