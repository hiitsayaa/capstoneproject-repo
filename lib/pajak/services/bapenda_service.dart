import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/api_constants.dart';

class BapendaService {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<List<dynamic>> fetchMyVehicles() async {
    final token = await _getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.bapendaVehiclesMe),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> checkPkb(String nopol) async {
    final token = await _getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.bapendaPkbCheck}?nopol=$nopol'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> createPayment(String billId, String method) async {
    final token = await _getToken();
    if (token == null) return null;

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.bapendaPkbPay),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'bill_id': billId,
          'payment_method': method,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>> searchNjkb(String? merk, String? tahun) async {
    try {
      String query = '';
      if (merk != null) query += 'merk=$merk&';
      if (tahun != null) query += 'tahun=$tahun';
      
      final url = query.isNotEmpty ? '${ApiConstants.bapendaNjkb}?$query' : ApiConstants.bapendaNjkb;
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return data['data'] as List<dynamic>;
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
