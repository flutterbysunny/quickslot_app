import 'package:get/get.dart';
import '../controllers/venues_controller.dart';

class VenuesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VenuesController>(() => VenuesController());
  }
}