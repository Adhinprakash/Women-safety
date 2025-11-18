import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';

class CallerController extends GetxController {

   void callnumber(String number)async {
    
    FlutterPhoneDirectCaller.callNumber(number);
  }     
}


