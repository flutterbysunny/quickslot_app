import 'package:get/get.dart';
import '../controllers/slots_controller.dart';

class SlotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SlotController>(
          () => SlotController(),
    );
  }
}