import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_saftey/db/database_helper.dart';
import 'package:women_saftey/model/contacts_model.dart';

class TrustedcontactsController extends GetxController{
  var trustedContacts = <Tcontacts>[].obs;


@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadContacts();
  }
void loadContacts()async{

 trustedContacts.value= await DatabaseHelper.getallcontacts();

}

void insertContact(Tcontacts contact)async{

bool exists= await DatabaseHelper.isDuplicateContact(contact.phone);
if(!exists){
  await DatabaseHelper.insertContact(contact);
  Get.snackbar("successfull", "Contact added succesfully");
}
 
 else{
   Get.snackbar(
      "Duplicate Contact",
      "${contact.name} is already added.",
      snackPosition: SnackPosition.BOTTOM,
    );

 }
  loadContacts();
}

void deleteContact(int id)async{
  await DatabaseHelper.deleteContact(id);
  loadContacts();
}

void updateContact(Tcontacts contacts)async{
await DatabaseHelper.updateContact(contacts);
loadContacts();
}

}