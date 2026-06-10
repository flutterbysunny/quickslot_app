import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/slot_model.dart';
import '../../../data/providers/api_provider.dart';

class VenueDetailController extends GetxController {
  final ApiProvider _api = Get.find<ApiProvider>();

  final slots = <SlotsResponse>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final selectedDate = DateTime.now().obs;
  final isBooking = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSlots();
  }

  String get formattedDate {
    final d = selectedDate.value;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> pickDate(context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      selectedDate.value = picked;
      fetchSlots();
    }
  }

  Future<void> fetchSlots() async {
    final venue = Get.arguments;
    try {
      isLoading(true);
      error('');
      final response = await _api.getSlots(venue.id, formattedDate);
      slots.value = (response.data as List)
          .map((e) => SlotsResponse.fromJson(e))
          .toList();
    } catch (e) {
      error('Failed to load slots. Please try again.');
    } finally {
      isLoading(false);
    }
  }

  Future<void> bookSlot(int slotId) async {
    try {
      isBooking(true);
      await _api.createBooking(slotId);
      Get.snackbar(
        'Success! 🎉',
        'Slot booked successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      fetchSlots();
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('409')) {
        Get.snackbar(
          'Slot Taken!',
          'Someone just booked this slot. Please choose another.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchSlots();
      } else {
        Get.snackbar(
          'Error',
          'Something went wrong. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isBooking(false);
    }
  }
}