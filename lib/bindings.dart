import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:women_saftey/controller/safe_home_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy initialization - controller will be created when first used
    Get.lazyPut<SafeHomeController>(() => SafeHomeController());
    
    // Or use Get.put for immediate initialization
    // Get.put<LocationController>(LocationController());
  }
}