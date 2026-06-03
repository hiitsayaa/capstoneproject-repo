import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class GatewayService {
  static Future<List<dynamic>> fetchActiveFeatures() async {
    try {
      final url = Uri.parse(ApiConstants.features);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['active_features'] ?? [];
      } else {
        // Fallback jika gagal
        return [];
      }
    } catch (e) {
      // Fallback offline
      return [];
    }
  }
}
