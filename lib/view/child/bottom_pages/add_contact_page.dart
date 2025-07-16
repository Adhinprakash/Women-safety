  import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
  import 'package:get/get.dart';
  import 'package:women_saftey/components/primary_button.dart';
import 'package:women_saftey/controller/trustedContacts_controller.dart';
  import 'package:women_saftey/view/child/bottom_pages/contact_page.dart';

  class AddContactPage extends StatelessWidget {
    const AddContactPage({super.key});

    @override
    Widget build(BuildContext context) {
          final TrustedcontactsController trustedContactController = Get.put(TrustedcontactsController());

      return SafeArea(child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: PrimaryButton(
                  title: "Add Trusted contacts",
                  
                  onPressed: () => Get.to(Contactspage())),
            ),
              const SizedBox(height: 10),
            const Text("Trusted Contacts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: trustedContactController.trustedContacts.length,
                  itemBuilder: (context, index) {
                    final contact = trustedContactController.trustedContacts[index];
                    final contactnumber=trustedContactController.trustedContacts[index].phone;
                    print(contactnumber);
                    return ListTile(
                      title: Text(contact.name),
                      subtitle: Text(contact.phone),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.call),
                            onPressed: ()async {
                          await FlutterPhoneDirectCaller.callNumber(contactnumber);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              trustedContactController.deleteContact(contact.id!);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ));
    }
  }
