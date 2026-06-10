import 'package:get/get.dart';
import '../../../data/models/venue_model.dart';
import '../../../data/providers/api_provider.dart';

class VenuesController extends GetxController {
  final ApiProvider _api = Get.find<ApiProvider>();

  final venues = <VenueResponse>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVenues();
  }

  Future<void> fetchVenues() async {
    try {
      isLoading(true);
      error('');
      final response = await _api.getVenues();
      venues.value = (response.data as List)
          .map((e) => VenueResponse.fromJson(e))
          .toList();
    } catch (e) {
      error('Failed to load venues. Please try again.');
    } finally {
      isLoading(false);
    }
  }
}