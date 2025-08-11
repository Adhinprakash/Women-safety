import 'package:background_sms/background_sms.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';

class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  String? _currentaddress;
  String? _curentPosition;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;

  _getpermission() async => await [Permission.sms].request();
  _isPermissiongranted() async => await Permission.sms.isGranted;

  // __getcurrentlocation() async {
  //   try {
  //     // Check if location service is enabled
  //     bool serviceEnabled = await FlLocation.isLocationServicesEnabled;
  //     if (!serviceEnabled) {
  //       Fluttertoast.showToast(msg: "Location service is disabled");
  //       return;
  //     }

  //     // Check location permission
  //     LocationPermission permission =
  //         await FlLocation.checkLocationPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await FlLocation.requestLocationPermission();
  //       if (permission == LocationPermission.denied) {
  //         Fluttertoast.showToast(msg: "Location permission denied");
  //         return;
  //       }
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       Fluttertoast.showToast(msg: "Location permission denied forever");
  //       return;
  //     }

  //     // Get current location
  //     Location locationData = await FlLocation.getLocation(
  //       accuracy: LocationAccuracy.high,
  //       timeLimit: Duration(seconds: 10),
  //     );

  //     setState(() {
  //       _currentposition = locationData;
  //     });

  //     // Get address from coordinates
  //     _getcurrentaddressLocation();

  //     Fluttertoast.showToast(msg: "Location retrieved successfully");
  //   } catch (error) {
  //     print("Error getting location: $error");
  //     Fluttertoast.showToast(msg: "Failed to get current location: $error");
  //   }
  // }

  _sendSms(String phonenumber, String message, {int? simSlot}) async {
    await BackgroundSms.sendMessage(
            phoneNumber: phonenumber, message: message, simSlot: simSlot)
        .then(
      (SmsStatus status) {
        if (status == 'send') {
          Get.snackbar(
            "Send",
            "sms send successfully",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            "Fail",
            "Failed to send sms",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }

// _getcurrentlocation()async{
//   try {

//     bool _isserviceenable= await

//   } catch (e) {

//   }
// }

  // _getcurrentlocation() async {
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     Fluttertoast.showToast(msg: "Location permission denied");
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     Fluttertoast.showToast(msg: "Location permission denied forever");
  //   }
  //   if (permission == LocationPermission.whileInUse) {
  //     _currentposition = await Geolocator.getCurrentPosition();
  //   }
  //   Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high,
  //           forceAndroidLocationManager: true)
  //       .then((Position position) {
  //     setState(() {
  //       _currentposition = position;
  //       _getcurrentaddressLocation();
  //     });
  //   }).catchError((error) {
  //     Fluttertoast.showToast(msg: "Failed to get current location");
  //   });
  // }

  // _getcurrentaddressLocation() async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //       _curentPosition!, _curentPosition!.longitude);
  //   Placemark? place = placemarks[0];
  //   setState(() {
  //     _currentaddress =
  //         '${place.street},${place.subAdministrativeArea},${place.administrativeArea}';
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // _getcurrentaddressLocation();
  }

  showModelSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SEND YOUR CUURENT LOCATION IMMEDIATELY TO YOU EMERGENCY CONTACTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                if (_curentPosition != null) Text(_currentaddress ?? ''),
                PrimaryButton(title: "Get location", onPressed: () {}),
                const SizedBox(
                  height: 10,
                ),
                PrimaryButton(title: "Send alert", onPressed: () {})
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModelSafeHome(context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(),
          child: Row(
            children: [
              const Expanded(
                  child: Column(
                children: [
                  ListTile(
                    title: Text("Send Location"),
                    subtitle: Text("Share Location"),
                  ),
                ],
              )),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/route.jpg')),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  bool loading;
  PrimaryButton(
      {required this.title, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          title,
          style: const TextStyle(fontSize: 17, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
      ),
    );
  }
}
