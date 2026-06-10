import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../../data/models/booking_model.dart';
import '../../../data/providers/api_provider.dart';

class MyBookingsController extends GetxController {
  final ApiProvider _api = Get.find<ApiProvider>();

  final bookings = <SlotsBookingResponse>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading(true);
      error('');
      final response = await _api.getMyBookings();
      bookings.value = (response.data as List)
          .map((e) => SlotsBookingResponse.fromJson(e))
          .toList();
    } catch (e) {
      error('Failed to load bookings. Please try again.');
    } finally {
      isLoading(false);
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    try {
      await _api.cancelBooking(bookingId);
      Get.snackbar(
        'Cancelled',
        'Booking cancelled successfully.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      fetchBookings();
    } on DioException catch (e) {
      final msg = e.response?.statusCode == 403
          ? 'You can only cancel your own bookings.'
          : 'Could not cancel. Please try again.';
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void confirmCancel(BuildContext context, int bookingId) {
    Get.defaultDialog(
      title: 'Cancel Booking',
      middleText: 'Are you sure you want to cancel this booking?',
      textConfirm: 'Yes, Cancel',
      textCancel: 'Keep',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        cancelBooking(bookingId);
      },
    );
  }
}
