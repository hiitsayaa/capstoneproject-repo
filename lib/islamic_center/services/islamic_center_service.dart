import 'dart:convert';
import 'package:http/http.dart' as http;

class IslamicCenterService {
  static const String baseUrl = 'http://10.0.2.2:3000/islamic-center';

  static Future<List<dynamic>> getFacilities({String? category}) async {
    try {
      final uri = Uri.parse('$baseUrl/facilities${category != null ? '?category=$category' : ''}');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error getFacilities: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getFacility(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/facilities/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error getFacility: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> createBooking({
    required String facilityId,
    required String namaPemohon,
    required String telepon,
    required String email,
    required String tanggal,
    required String waktu,
    String? catatan,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'facility_id': facilityId,
          'nama_pemohon': namaPemohon,
          'telepon': telepon,
          'email': email,
          'tanggal': tanggal,
          'waktu': waktu,
          if (catatan != null) 'catatan': catatan,
        }),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error createBooking: $e');
      return null;
    }
  }
}
