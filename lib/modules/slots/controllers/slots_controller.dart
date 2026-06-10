import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/slot_model.dart';
import '../../../data/providers/api_provider.dart';

class SlotController extends GetxController {
  final ApiProvider _api = Get.find<ApiProvider>();

  final slots = <SlotsResponse>[].obs;

  final isLoading = false.obs;
  final error = ''.obs;

  final selectedDate = DateTime.now().obs;

  late int venueId;

  @override
  void onInit() {
    super.onInit();

    venueId = Get.arguments['venueId'];

    fetchSlots();
  }

  Future<void> fetchSlots() async {
    try {
      isLoading(true);
      error('');

      final response = await _api.getSlots(
        venueId,
        selectedDate.value.toIso8601String().split('T')[0],
      );

      slots.value = (response.data as List)
          .map((e) => SlotsResponse.fromJson(e))
          .toList();
    } catch (e) {
      error('Failed to load slots');
    } finally {
      isLoading(false);
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 30),
      ),
    );

    if (picked != null) {
      selectedDate.value = picked;
      fetchSlots();
    }
  }

  Future<void> bookSlot(int slotId) async {
    try {
      await _api.createBooking(slotId);

      Get.snackbar(
        'Success',
        'Slot booked successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      fetchSlots();
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        Get.snackbar(
          'Already Booked',
          'This slot was just booked by another user',
        );

        fetchSlots();
      } else {
        Get.snackbar(
          'Error',
          'Unable to book slot',
        );
      }
    }
  }

  void confirmBooking(SlotsResponse slot) {
    Get.defaultDialog(
      title: 'Confirm Booking',
      middleText:
      '${slot.startTime} - ${slot.endTime}',
      textConfirm: 'Book',
      textCancel: 'Cancel',
      onConfirm: () {
        Get.back();
        bookSlot(slot.id!);
      },
    );
  }
}