import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:http/http.dart' as http;
import 'package:women_saftey/db/database_helper.dart';
import 'package:women_saftey/model/contacts_model.dart';
import 'package:women_saftey/utils/consts.dart';
import 'package:telephony/telephony.dart';

class SafeHomeController extends GetxController {
  var currentaddress = Rxn<String>();
  var isUploadingImage = false.obs; // For loading state

  var serviceEnabled = false.obs;
  var isgettingLocation = false.obs;
  var currentposition = Rxn<LocationData>();
  var _permissionGranted = ph.PermissionStatus.denied;

  final Location location = Location();
  final Telephony telephony = Telephony.instance;

  @override
  void onInit() {
    super.onInit();
    // getcurrentLocation();
  }

  final cluodinary =
      CloudinaryPublic("dqtmj8xfx", "women_safety_chat", cache: false);

  Future<String?> uploadImagetocloudinary(File? imagefile) async {
    try {
      isUploadingImage.value = true;
      final response = await cluodinary.uploadFile(CloudinaryFile.fromFile(
          imagefile!.path,
          folder: "women_safety_chat_images",
          resourceType: CloudinaryResourceType.Image));
      isUploadingImage.value = false;
      return response.secureUrl;
    } catch (e) {
      isUploadingImage.value = false;
      Fluttertoast.showToast(
        msg: "Image upload failed: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
      );
      print('Cloudinary upload error: $e');
      return null;
    }
  }

  Future<Map<ph.Permission, ph.PermissionStatus>> getPermission() async {
    return await [ph.Permission.sms].request();
  }

  Future<bool> isPermissionGranted() async {
    return await ph.Permission.sms.isGranted;
  }

  Future<bool> checkSmsPermission() async {
    bool? canSendSms = await telephony.isSmsCapable;
    if (canSendSms == null || !canSendSms) {
      return false;
    }

    final bool hasPermission = await ph.Permission.sms.isGranted;
    if (!hasPermission) {
      final Map<ph.Permission, ph.PermissionStatus> result =
          await getPermission();
      return result[ph.Permission.sms] == ph.PermissionStatus.granted;
    }
    return true;
  }

  Future<bool> sendSms(String phoneNumber, String message) async {
    try {
      String testmsgbody = "Emergency test from safety app app";

      String sanitizednum = phoneNumber.replaceAll(' ', '');
      bool issend = await checkSmsPermission();

      if (!issend) {
        print('SMS permission not granted or device cannot send SMS');
        return false;
      }

      print(sanitizednum);

      Completer<bool> completer = Completer<bool>();
      bool statusReceived = false;
      await telephony.sendSms(
        to: sanitizednum,
        message: message,
        statusListener: (SendStatus status) {
          print('SMS Status for $phoneNumber: ${status.toString()}');
          if (!statusReceived) {
            statusReceived = true;
            completer.complete(status == SendStatus.SENT);
          }
        },
      );
      return await completer.future.timeout(
        Duration(seconds: 6),
        onTimeout: () {
          print('SMS timeout for $phoneNumber');
          if (!statusReceived) {
            return true;
          }
          return false;
        },
      );
    } catch (e) {
      print('Error sending SMS to $phoneNumber: $e');
      return false;
    }
  }

  Future<Map<String, bool>> sendEmergencyAlert() async {
    try {
      if (currentposition.value == null) {
        showToast("Please get your location first!", Colors.orange);
        return {};
      }

      List<Tcontacts> contactList = await DatabaseHelper.getallcontacts();

      if (contactList.isEmpty) {
        showToast("Emergency contact list is empty. Please add contacts first.",
            Colors.red);
        return {};
      }

      String googleMapsLink =
          "https://www.google.com/maps/search/?api=1&query=${currentposition.value!.latitude}%2C${currentposition.value!.longitude}";
      String messageBody =
          // "🆘 EMERGENCY ALERT 🆘\n\n"
          "I am in trouble and need help!!\n"
          "$googleMapsLink\n"
          "GPS: ${currentposition.value!.latitude}, ${currentposition.value!.longitude}\n"
          // "Time: ${DateTime.now().toString().split('.')[0]}\n\n"
          ;

      // Send SMS to all contacts
      Map<String, bool> results = {};
      int successCount = 0;

      for (Tcontacts contact in contactList) {
        await Future.delayed(
            Duration(milliseconds: 500)); // Small delay between SMS
        bool success = await sendSms(contact.phone, messageBody);
        results[contact.phone] = success;
        if (success) successCount++;
      }

      if (successCount > 0) {
        showToast(
          "Emergency alert sent to $successCount/${contactList.length} contacts!",
          Colors.green,
        );
      } else {
        showToast(
          "Failed to send alerts. Check SMS permissions and try again.",
          Colors.red,
        );
      }

      return results;
    } catch (e) {
      showToast("Error sending alert: ${e.toString()}", Colors.red);
      print('Error sending emergency alert: $e');
      return {};
    }
  }

  Future<bool> checklocationservice() async {
    serviceEnabled.value = await location.serviceEnabled();
    if (!serviceEnabled.value) {
      serviceEnabled.value = await location.requestService();
      if (!serviceEnabled.value) {
        return false;
      }
    }
    return true;
  }

  Future<bool> _checkLocationPermission() async {
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<void> getcurrentLocation() async {
    isgettingLocation.value = true;

    try {
      bool serviceEnabled = await checklocationservice();
      if (!serviceEnabled) {
        Fluttertoast.showToast(
          msg:
              "Location services are disabled. Please enable location services.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

        isgettingLocation.value = false;

        return;
      }

      bool hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        Fluttertoast.showToast(
          msg: "Location permission denied. Please grant location permission.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

        isgettingLocation.value = false;

        return;
      }

      LocationData locationData = await location.getLocation();
      String address = await _getAddressFromCoordinates(
          locationData.latitude, locationData.longitude);

      currentposition.value = locationData;
      currentaddress.value = address;
      isgettingLocation.value = false;

      Fluttertoast.showToast(
        msg: "Location obtained successfully",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (e) {
      isgettingLocation.value = false;
      Fluttertoast.showToast(
        msg: "Error getting location: ${e.toString()}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      print('Error getting location: $e');
    }
  }

  Future<String> _getAddressFromCoordinates(double? lat, double? lng) async {
    try {
      final url =
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'WomenSafety/1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['display_name'] != null) {
          return data['display_name'];
        } else if (data['address'] != null) {
          // Build address from components
          final address = data['address'];
          List<String> addressParts = [];

          if (address['house_number'] != null)
            addressParts.add(address['house_number']);
          if (address['road'] != null) addressParts.add(address['road']);
          if (address['suburb'] != null) addressParts.add(address['suburb']);
          if (address['city'] != null) addressParts.add(address['city']);
          if (address['state'] != null) addressParts.add(address['state']);
          if (address['postcode'] != null)
            addressParts.add(address['postcode']);
          if (address['country'] != null) addressParts.add(address['country']);

          return addressParts.join(', ');
        }

        return 'Address not found';
      } else {
        return 'Unable to get address';
      }
    } catch (e) {
      print('Error getting address: $e');
      return 'Error getting address';
    }
  }

  bool get hasLocation => currentposition.value != null;
  bool get hasAddress =>
      currentaddress.value != null && currentaddress.value!.isNotEmpty;
}
