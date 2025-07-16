import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:women_saftey/controller/contacts_controller.dart';
import 'package:women_saftey/controller/trustedContacts_controller.dart';
import 'package:women_saftey/model/contacts_model.dart';

class Contactspage extends StatefulWidget {
  const Contactspage({super.key});

  @override
  State<Contactspage> createState() => _ContactspageState();
}

class _ContactspageState extends State<Contactspage> {
    String normalizePhone(String phone) {
  return phone.replaceAll(RegExp(r'\D'), '');
}
  final ContactsController contactsController=Get.put(ContactsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Obx(()=> contactsController.contacts.length==0
      ?const Center(child: CircularProgressIndicator(),):
   SafeArea(child:    
 Padding(padding: EdgeInsets.all(8),
 child:  Column(
  children: [
      Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                       TextField(
                      autofocus: true,
                      onChanged: (value)=>contactsController.filtercontacts(value) ,
                      decoration: const InputDecoration(
                          labelText: "search sontact",
                          prefixIcon: Icon(Icons.search)),
                    )
                   
                  ),
    Expanded(child:  ListView.builder(
        itemCount: contactsController.contactsFiltered.length,
        itemBuilder: (BuildContext context,int index){
        Contact contact=contactsController.contactsFiltered[index]; 
        return ListTile(
          title: Text(contact.displayName),
          leading: CircleAvatar( backgroundImage: contact.photo != null 
    ? MemoryImage(contact.photo!) 
    : null,
  child: contact.photo == null 
    ? Text(contact.displayName[0]) 
    : null,),
          onTap: (){
              final TrustedcontactsController trustedContactController = Get.find();

            if(contact.phones.isNotEmpty){
final String phonenum=contact.phones.first.number;



final String name=contact.displayName;
// final phonenumber=normalizePhone(phonenum);
final newcontacts=Tcontacts(name: name,phone: phonenum);
trustedContactController.insertContact(newcontacts);
Get.back();
            }
          },
        );
      }))
  ],
 ),)))
    );
      }

  }
