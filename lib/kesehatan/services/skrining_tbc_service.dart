import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_constants.dart';
import '../../auth/services/auth_service.dart';
class SkriningTbcService {
  static const String baseUrl = '${ApiConstants.baseUrl}/tbc-screening';

  static Future<Map<String, dynamic>?> submitScreening(Map<String, dynamic> payload) async {
    try {
      final token = await AuthService().getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/records'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error submitting screening: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception submitting screening: $e');
      return null;
    }
  }

  static Future<List<dynamic>> getRiwayat({String? nik}) async {
    try {
      final token = await AuthService().getToken();
      final uri = Uri.parse('$baseUrl/records${nik != null ? '?nik=$nik' : ''}');
      final response = await http.get(
        uri,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error getRiwayat: $e');
      return [];
    }
  }

  static Future<bool> updateFaskes(String recordId, String faskesName) async {
    try {
      final token = await AuthService().getToken();
      final uri = Uri.parse('$baseUrl/records/$recordId/faskes');
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'faskes_name': faskesName}),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error updateFaskes: $e');
      return false;
    }
  }
}
