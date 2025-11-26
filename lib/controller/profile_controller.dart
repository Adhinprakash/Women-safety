import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var isLoading = false.obs;
  var isFetching = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> fetchUserName() async {
    isFetching.value = true;
    
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Get user document from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (userDoc.exists) {
          String name = userDoc.get('name') ?? '';
          nameController.text = name;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error fetching name: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> updateUserName() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Warning',
        'Please enter a name',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        Get.snackbar(
          'Success',
          'Name updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error updating name: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}