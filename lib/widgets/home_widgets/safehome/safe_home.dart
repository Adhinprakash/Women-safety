

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  
_getpermission()async=>await [Permission.sms].request();
_isPermissiongranted()async=>await Permission.sms.isGranted;

_sendsms(String phonenumber,String message,{int? simSlot})async{
await BackgroundSms.sendMessage(phoneNumber: phonenumber, message: message,simSlot: simSlot).then((SmsStatus status) {
 if(status=='send'){
   Get.snackbar(
      "Send",
      "sms send successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
 } else{
  Get.snackbar(
      "Fail",
      "Failed to send sms",
      snackPosition: SnackPosition.BOTTOM,
    );
 }
},);
}
  @override
  void initState() {
    super.initState();

  }

  showModelSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          child:  Padding(
            padding: EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SEND YOUR CUURENT LOCATION IMMEDIATELY TO YOU EMERGENCY CONTACTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                PrimaryButton(title: "Get location", onPressed: (){}),
                SizedBox(height: 10,),
                PrimaryButton(title: "Send alert", onPressed: (){})
                
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
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
          style: const TextStyle(fontSize: 17,color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
      ),
    );
  }
}