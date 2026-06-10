import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class ApiProvider {
  static const String baseUrl = 'http://10.0.2.2:3000';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  // Current user — hardcoded for hackathon
  String userId = 'user1';

  // Venues
  Future<Response> getVenues() => _dio.get('/venues');

  Future<Response> getVenueById(int id) => _dio.get('/venues/$id');

  // Slots
  Future<Response> getSlots(int venueId, String date) =>
      _dio.get('/venues/$venueId/slots', queryParameters: {'date': date});

  // Bookings
  Future<Response> createBooking(int slotId) => _dio.post(
    '/bookings',
    data: {'slot_id': slotId},
    options: Options(headers: {'X-User-Id': userId}),
  );

  Future<Response> getMyBookings() =>
      _dio.get('/users/$userId/bookings');

  Future<Response> cancelBooking(int bookingId) => _dio.delete(
    '/bookings/$bookingId',
    options: Options(headers: {'X-User-Id': userId}),
  );
}