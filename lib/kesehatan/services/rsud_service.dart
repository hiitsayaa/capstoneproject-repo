import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/api_constants.dart';

class RsudService {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<Map<String, dynamic>?> fetchHospitalDetail(String hospitalId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.rsudHospital}/$hospitalId'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>> fetchRooms(String hospitalId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.rsudHospital}/$hospitalId/rooms'),
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        return decoded['rooms'] as List<dynamic>? ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> fetchSurgeries(String hospitalId, {String? tanggal}) async {
    try {
      String url = '${ApiConstants.rsudHospital}/$hospitalId/surgeries';
      if (tanggal != null && tanggal.isNotEmpty) {
        url += '?tanggal=$tanggal';
      }
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        return decoded['surgeries'] as List<dynamic>? ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> fetchQueues(String hospitalId, {String? spesialisasi, String? dokterNama}) async {
    try {
      String url = '${ApiConstants.rsudHospital}/$hospitalId/queues';
      final params = <String>[];
      if (spesialisasi != null && spesialisasi.isNotEmpty) {
        params.add('spesialisasi=${Uri.encodeComponent(spesialisasi)}');
      }
      if (dokterNama != null && dokterNama.isNotEmpty) {
        params.add('dokter_nama=${Uri.encodeComponent(dokterNama)}');
      }
      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        return decoded['queues'] as List<dynamic>? ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> createQueue(String hospitalId, Map<String, dynamic> data) async {
    final token = await _getToken();
    // Some endpoints in Gateway might require auth, we'll send it just in case.
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.rsudHospital}/$hospitalId/queue'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
