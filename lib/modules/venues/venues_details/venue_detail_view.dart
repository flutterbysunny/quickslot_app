import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickslot_app/modules/venues/venues_details/venue_detail_controller.dart';
import '../../../data/models/slot_model.dart';

class VenueDetailView extends GetView<VenueDetailController> {
  const VenueDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final venue = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(venue.name),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Date Picker
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() => InkWell(
              onTap: () => controller.pickDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.formattedDate,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.green),
                  ],
                ),
              ),
            )),
          ),

          // Slots
          Expanded(
            child: Obx(() {
              // Loading
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Colors.green));
              }

              // Error
              if (controller.error.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(controller.error.value),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.fetchSlots,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              // Empty
              if (controller.slots.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No slots available', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }

              // Slot Grid
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5,
                ),
                itemCount: controller.slots.length,
                itemBuilder: (context, index) {
                  final slot = controller.slots[index];
                  return _SlotCard(slot: slot, controller: controller);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  final SlotsResponse slot;
  final VenueDetailController controller;

  const _SlotCard({required this.slot, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isAvailable = slot.status == 'available';

    return GestureDetector(
      onTap: isAvailable
          ? () => _confirmBooking(context, slot)
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isAvailable ? Colors.green.shade50 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isAvailable ? Colors.green : Colors.grey,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              slot.startTime!.substring(0, 5),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isAvailable ? Colors.green : Colors.grey,
              ),
            ),
            Text(
              isAvailable ? 'Available' : 'Booked',
              style: TextStyle(
                fontSize: 10,
                color: isAvailable ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking(BuildContext context, SlotsResponse slot) {
    Get.defaultDialog(
      title: 'Confirm Booking',
      middleText: 'Book slot ${slot.startTime!.substring(0, 5)} - ${slot.endTime!.substring(0, 5)}?',
      textConfirm: 'Book',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () {
        Get.back();
        controller.bookSlot(slot.id ?? 0);
      },
    );
  }
}