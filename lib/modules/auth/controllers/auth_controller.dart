import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/providers/api_provider.dart';

class AuthController extends GetxController {
  final users = [
    {'id': 'user1', 'name': 'Rahul'},
    {'id': 'user2', 'name': 'Priya'},
    {'id': 'user3', 'name': 'Arjun'},
  ];

  final ApiProvider _api = ApiProvider();

  void selectUser(String userId, String userName) {
    _api.userId = userId;
    Get.put(_api, permanent: true);
    Get.offAllNamed(AppRoutes.venues);
  }
}