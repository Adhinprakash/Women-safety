import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:women_saftey/controller/safe_home_controller.dart';


class SafeHome extends StatelessWidget {
  showModelSafeHome(BuildContext context) {
    final SafeHomeController safeHomeController=Get.put(SafeHomeController());
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
                const Text(
                  "SEND YOUR CUURENT LOCATION IMMEDIATELY TO YOU EMERGENCY CONTACTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                Obx((){
                  if(safeHomeController.hasAddress&&safeHomeController.hasLocation) {
                    return 
                   Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: 
                  
                  Text(
                    
                            safeHomeController.currentaddress.value!,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                );
                  }
                return Text(
                      'Location not obtained yet. Click "Get Location" first.',
                      style: TextStyle(color: Colors.orange[700]),
                    );
                })
               
                        //  Text(
                        //   'Lat: ${_curentPosition!.latitude!.toStringAsFixed(6)}, '
                        //   'Lng: ${_curentPosition!.longitude!.toStringAsFixed(6)}',
                        //   style: TextStyle(
                        //     fontSize: 12, 
                        //     color: Colors.grey[600],
                        //     fontFamily: 'monospace',
                        //   ),
                        // ),

                        ,

                Obx((){
 return PrimaryButton(
loading: safeHomeController.isgettingLocation.value,
                  
                                title:safeHomeController.isgettingLocation.value ? "Getting Location..." : "GET LOCATION", 
  
               onPressed:()async{
               safeHomeController.getcurrentLocation();
               });
                }),
                const SizedBox(
                  height: 10,
                ),
                // PrimaryButton(title: "Send alert", onPressed: () {})
                   PrimaryButton(
                  title: "SEND ALERT",
                  onPressed: () async {
                    if (!safeHomeController.hasLocation) {
                      Fluttertoast.showToast(
                        msg: "Please get your location first!",
                        backgroundColor: Colors.orange,
                        textColor: Colors.white,
                      );
                      return;
                    }

                    bool? shouldSend = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('⚠️ Send Emergency Alert?'),
                          content: const Text(
                            'This will send your current location to your emergency contacts.\n\n'
                            'Are you sure you want to proceed?'
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: Text('Send Alert', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldSend != true) return;

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 20),
                              Text('Sending emergency alerts...'),
                            ],
                          ),
                        );
                      },
                    );

                    try {
                      Map<String, bool> results = await safeHomeController.sendEmergencyAlert();
                      
                      Navigator.of(context).pop();

                      if (results.isNotEmpty) {
                        Navigator.of(context).pop();
                        
                        _showSmsResults(context, results);
                      }

                    } catch (e) {
                      // Close loading dialog if open
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
                      
                      Fluttertoast.showToast(
                        msg: "Error sending alert: ${e.toString()}",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                ),
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


  void _showSmsResults(BuildContext context, Map<String, bool> results) {
    int successCount = results.values.where((success) => success).length;
    int totalCount = results.length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SMS Status Report'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Emergency alerts sent: $successCount/$totalCount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final entry = results.entries.elementAt(index);
                      final phoneNumber = entry.key;
                      final success = entry.value;
                      
                      return ListTile(
                        leading: Icon(
                          success ? Icons.check_circle : Icons.error,
                          color: success ? Colors.green : Colors.red,
                        ),
                        title: Text('Contact ${index + 1}'),
                        subtitle: Text(phoneNumber),
                        trailing: Text(
                          success ? 'Sent' : 'Failed',
                          style: TextStyle(
                            color: success ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
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
        onPressed: ()async {
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
