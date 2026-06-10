import 'package:get/get.dart';
import '../../modules/auth/views/auth_view.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/bookings/bindings/my_bookings_binding.dart';
import '../../modules/bookings/views/my_bookings_view.dart';
import '../../modules/venues/venues_details/venue_detail_view.dart';
import '../../modules/venues/views/venues_view.dart';
import '../../modules/venues/bindings/venues_binding.dart';
// import '../../modules/bookings/views/my_bookings_view.dart';
// import '../../modules/bookings/bindings/bookings_binding.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.venues,
      page: () => const VenuesView(),
      binding: VenuesBinding(),
    ),
    GetPage(
      name: AppRoutes.venueDetail,
      page: () =>  VenueDetailView(),
      binding: VenuesBinding(),
    ),
    GetPage(
      name: AppRoutes.myBookings,
      page: () => const MyBookingsView(),
      binding: MyBookingsBinding(),
    ),
  ];
}