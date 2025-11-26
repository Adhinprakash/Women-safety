import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:women_saftey/controller/chat_controller.dart';
import 'package:women_saftey/controller/profile_controller.dart';
import 'package:women_saftey/controller/safe_home_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy initialization - controller will be created when first used
    Get.lazyPut<SafeHomeController>(() => SafeHomeController());
        Get.lazyPut<ProfileController>(() => ProfileController());

        // Get.lazyPut<ChatController>(() => ChatController());

    // Or use Get.put for immediate initialization
    // Get.put<LocationController>(LocationController());
  }
}