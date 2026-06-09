import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/api_constants.dart';
import 'package:flutter_application_1/auth/services/auth_service.dart';

class BansosService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> apply({
    required String programId,
    required String namaIbuKandung,
    required double penghasilanBulanan,
    required int jumlahTanggungan,
  }) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Tidak ada token');

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/bansos/apply');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'program_id': programId,
          'nama_ibu_kandung': namaIbuKandung,
          'penghasilan_bulanan': penghasilanBulanan,
          'jumlah_tanggungan': jumlahTanggungan,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengajukan bansos');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<dynamic>> getStatus() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Tidak ada token');

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/bansos/status');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      } else {
        throw Exception('Gagal memuat status bansos');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
