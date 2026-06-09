import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/api_constants.dart';
import 'package:flutter_application_1/auth/services/auth_service.dart';

class PointJatimService {
  static const String endpoint = '${ApiConstants.baseUrl}/point-jatim';

  static Future<List<dynamic>> getProjects({String? sector}) async {
    try {
      var urlStr = '$endpoint/projects';
      if (sector != null && sector != 'Semua') {
        urlStr += '?sector=${Uri.encodeComponent(sector)}';
      }
      final url = Uri.parse(urlStr);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getProject(String id) async {
    try {
      final url = Uri.parse('$endpoint/projects/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching project $id: $e');
      return null;
    }
  }

  static Future<bool> apply({
    required String projectId,
    required String namaInvestor,
    required String email,
    required String telepon,
    String? catatan,
  }) async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();

      final url = Uri.parse('$endpoint/submissions');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'project_id': projectId,
          'nama_investor': namaInvestor,
          'email': email,
          'telepon': telepon,
          if (catatan != null && catatan.isNotEmpty) 'catatan': catatan,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error submitting point jatim: $e');
      return false;
    }
  }
}

