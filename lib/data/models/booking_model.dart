// To parse this JSON data, do
//
//     final slotsBookingResponse = slotsBookingResponseFromJson(jsonString);

import 'dart:convert';

SlotsBookingResponse slotsBookingResponseFromJson(String str) => SlotsBookingResponse.fromJson(json.decode(str));

String slotsBookingResponseToJson(SlotsBookingResponse data) => json.encode(data.toJson());

class SlotsBookingResponse {
  int? id;
  int? slotId;
  String? userId;
  DateTime? createdAt;

  SlotsBookingResponse({
    this.id,
    this.slotId,
    this.userId,
    this.createdAt,
  });

  factory SlotsBookingResponse.fromJson(Map<String, dynamic> json) => SlotsBookingResponse(
    id: json["id"],
    slotId: json["slot_id"],
    userId: json["user_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slot_id": slotId,
    "user_id": userId,
    "created_at": createdAt?.toIso8601String(),
  };
}
