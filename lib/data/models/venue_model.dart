// To parse this JSON data, do
//
//     final venueResponse = venueResponseFromJson(jsonString);

import 'dart:convert';

List<VenueResponse> venueResponseFromJson(String str) => List<VenueResponse>.from(json.decode(str).map((x) => VenueResponse.fromJson(x)));

String venueResponseToJson(List<VenueResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VenueResponse {
  int? id;
  String? name;
  String? sport;
  String? location;

  VenueResponse({
    this.id,
    this.name,
    this.sport,
    this.location,
  });

  factory VenueResponse.fromJson(Map<String, dynamic> json) => VenueResponse(
    id: json["id"],
    name: json["name"],
    sport: json["sport"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "sport": sport,
    "location": location,
  };
}
