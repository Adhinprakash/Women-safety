import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveSaveController extends GetxController{

  void openMap(String? location)async{

    final googleurl='https://www.google.com/maps/search/$location';
    final Uri uri=Uri.parse(googleurl);

    try {
      await launchUrl(uri);
    } catch (e) {
     Get.snackbar("error", "$e");
    }

  }
}