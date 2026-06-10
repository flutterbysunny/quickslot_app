import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/slots_controller.dart';


class SlotView extends GetView<SlotController> {
  const SlotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slots'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          Obx(
                () => ListTile(
              title: Text(
                controller.selectedDate.value
                    .toString()
                    .split(' ')[0],
              ),
              trailing: const Icon(
                Icons.calendar_month,
              ),
              onTap: () {
                controller.selectDate(context);
              },
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.error.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(controller.error.value),
                      ElevatedButton(
                        onPressed:
                        controller.fetchSlots,
                        child:
                        const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.slots.isEmpty) {
                return const Center(
                  child: Text(
                    'No slots available',
                  ),
                );
              }

              return GridView.builder(
                padding:
                const EdgeInsets.all(16),
                itemCount:
                controller.slots.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                ),
                itemBuilder: (context, index) {
                  final slot =
                  controller.slots[index];

                  final isBooked =
                      slot.isBooked;

                  return InkWell(
                    onTap: isBooked
                        ? null
                        : () => controller
                        .confirmBooking(
                        slot),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isBooked
                            ? Colors.red.shade100
                            : Colors.green
                            .shade100,
                        borderRadius:
                        BorderRadius.circular(
                            12),
                        border: Border.all(
                          color: isBooked
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            '${slot.startTime}',
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                              height: 8),
                          Text(
                            isBooked
                                ? 'BOOKED'
                                : 'AVAILABLE',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}