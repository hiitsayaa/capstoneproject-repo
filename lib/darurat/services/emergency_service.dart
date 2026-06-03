import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/api_constants.dart';

class EmergencyContact {
  final String id;
  final String region;
  final String name;
  final String category;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;

  EmergencyContact({
    required this.id,
    required this.region,
    required this.name,
    required this.category,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] ?? '',
      region: json['region'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }
}

class EmergencyService {
  Future<List<String>> fetchRegions() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/emergency/regions'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return List<String>.from(data['data']);
        }
      }
    } catch (e) {
      print('Error fetching emergency regions: $e');
    }
    return [];
  }

  Future<List<EmergencyContact>> fetchContacts(String region) async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/emergency/contacts?region=$region'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((item) => EmergencyContact.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      print('Error fetching emergency contacts: $e');
    }
    return [];
  }
}
