// To parse this JSON data, do
//
//     final slotsResponse = slotsResponseFromJson(jsonString);

import 'dart:convert';

List<SlotsResponse> slotsResponseFromJson(String str) => List<SlotsResponse>.from(json.decode(str).map((x) => SlotsResponse.fromJson(x)));

String slotsResponseToJson(List<SlotsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SlotsResponse {
  int? id;
  int? venueId;
  DateTime? date;
  String? startTime;
  String? endTime;
  Status? status;

  SlotsResponse({
    this.id,
    this.venueId,
    this.date,
    this.startTime,
    this.endTime,
    this.status,
  });

  factory SlotsResponse.fromJson(Map<String, dynamic> json) => SlotsResponse(
    id: json["id"],
    venueId: json["venue_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    startTime: json["start_time"],
    endTime: json["end_time"],
    status: statusValues.map[json["status"]]!,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "venue_id": venueId,
    "date": date?.toIso8601String(),
    "start_time": startTime,
    "end_time": endTime,
    "status": statusValues.reverse[status],
  };
}

enum Status {
  AVAILABLE
}

final statusValues = EnumValues({
  "available": Status.AVAILABLE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
