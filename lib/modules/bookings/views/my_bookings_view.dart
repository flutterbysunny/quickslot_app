import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_bookings_controller.dart';

class MyBookingsView extends GetView<MyBookingsController> {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Loading
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error
        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.error.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.fetchBookings,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty
        if (controller.bookings.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 70,
                ),
                SizedBox(height: 12),
                Text(
                  'No bookings found',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        // Success
        return RefreshIndicator(
          onRefresh: controller.fetchBookings,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.bookings.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final booking = controller.bookings[index];

              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.sports_tennis),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Booking #${booking.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Slot ID: ${booking.slotId}',
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'User: ${booking.userId}',
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Created: ${booking.createdAt ?? ''}',
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            controller.confirmCancel(
                              context,
                              booking.id ?? 0,
                            );
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text(
                            'Cancel Booking',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}