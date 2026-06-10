import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/venues_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/models/venue_model.dart';

class VenuesView extends GetView<VenuesController> {
  const VenuesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickSlot', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => Get.toNamed(AppRoutes.myBookings),
          ),
        ],
      ),
      body: Obx(() {
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
                  onPressed: controller.fetchVenues,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty
        if (controller.venues.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text('No venues available', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        // List
        return RefreshIndicator(
          onRefresh: controller.fetchVenues,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.venues.length,
            itemBuilder: (context, index) {
              final venue = controller.venues[index];
              return _VenueCard(venue: venue);
            },
          ),
        );
      }),
    );
  }
}

class _VenueCard extends StatelessWidget {
  final VenueResponse venue;
  const _VenueCard({required this.venue});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () => Get.toNamed(AppRoutes.venueDetail, arguments: venue),
        leading: CircleAvatar(
          backgroundColor: venue.sport == 'Football' ? Colors.green : Colors.blue,
          child: Icon(
            venue.sport == 'Football' ? Icons.sports_soccer : Icons.sports_tennis,
            color: Colors.white,
          ),
        ),
        title: Text(venue.name ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(venue.sport ?? ""),
            Text(venue.location ?? "", style: const TextStyle(color: Colors.grey)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}