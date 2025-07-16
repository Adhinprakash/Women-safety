import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    askPermission();
  }

  RxList<Contact> contacts = <Contact>[].obs;
  RxList<Contact> contactsFiltered = <Contact>[].obs;


  Future<void> askPermission() async {
    PermissionStatus permissionStatus = await getallcontactspermission();
    if (permissionStatus == PermissionStatus.granted) {
      getallcontacts();
      
    } else {
      handleinvalidPermission(permissionStatus);
    }
  }

  Future<PermissionStatus> getallcontactspermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    }
    return permission;
  }

  void handleinvalidPermission(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      Get.snackbar(
          "Access denied", "Access to the contacts denied by the user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      Get.snackbar("No contact found", "May contact does exist in this device");
    }
  }

  Future<void> getallcontacts() async {
    try {
      final contactsList = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
      contacts.value = contactsList;
      contactsFiltered.value=contactsList;
    } catch (e) {
      Get.snackbar("Error", "Failed to get contacts: $e");
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }


  filtercontacts(String searchItem) {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchItem.isNotEmpty) {
      _contacts.retainWhere((element) {
        String searchItemLower = searchItem.toLowerCase();
                String searchTermFlattren = flattenPhoneNumber(searchItemLower);

        String contactName = element.displayName;

        bool nameMatch = contactName.toLowerCase().contains(searchItemLower);
        if (nameMatch) return true;
     if(searchTermFlattren.isEmpty){
      return false;
     }
        if (element.phones.isNotEmpty) {
          return element.phones.any(
              (phone) => phone.number.toLowerCase().contains(searchItemLower));
        }
        return false;
      });
    }
    contactsFiltered.value=_contacts;
  }
  
}



