import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../core/api_constants.dart';
import '../halaman_klinik_hoaks.dart'; // To access BeritaHoaksItem

class HoaksService {
  static Future<List<BeritaHoaksItem>> getArticles() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/hoaks/articles'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List items = data['data'] ?? [];
        return items.map((item) {
          DateTime publishedAt = DateTime.now();
          if (item['published_at'] != null) {
            publishedAt = DateTime.parse(item['published_at']);
          }
          final formattedDate = DateFormat('dd MMM yyyy', 'id_ID').format(publishedAt);

          return BeritaHoaksItem(
            title: item['judul'] ?? '',
            category: item['kategori'] ?? '',
            tag: item['status_klarifikasi'] ?? '',
            date: formattedDate,
            urlSumber: item['url_sumber'],
            id: item['id'],
            imageAsset: _getImageForCategory(item['kategori'] ?? ''),
          );
        }).toList();
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      throw Exception('Failed to load articles: $e');
    }
  }

  static Future<String> reportHoax({
    required String judulLaporan,
    required String deskripsiKejadian,
    String? urlBukti,
    String? token, 
  }) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      String? formattedUrl = urlBukti;
      if (formattedUrl != null && formattedUrl.isNotEmpty) {
        if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
          formattedUrl = 'https://$formattedUrl';
        }
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/hoaks/report'),
        headers: headers,
        body: jsonEncode({
          'judul_laporan': judulLaporan,
          'deskripsi_kejadian': deskripsiKejadian,
          if (formattedUrl != null && formattedUrl.isNotEmpty) 'url_bukti': formattedUrl,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'success';
      } else if (response.statusCode == 409) {
        return 'duplicate';
      }
      return 'error: API returned ${response.statusCode} - ${response.body}';
    } catch (e) {
      return 'error: Exception: $e';
    }
  }
  static String _getImageForCategory(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('kesehatan') || cat.contains('medis')) {
      return 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?auto=format&fit=crop&q=80&w=200'; // Health
    } else if (cat.contains('ekonomi') || cat.contains('keuangan') || cat.contains('uang') || cat.contains('bantuan')) {
      return 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&q=80&w=200'; // Economy/Finance
    } else if (cat.contains('pendidikan') || cat.contains('sekolah')) {
      return 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&q=80&w=200'; // Education
    } else if (cat.contains('teknologi') || cat.contains('cyber') || cat.contains('digital')) {
      return 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&q=80&w=200'; // Tech
    } else if (cat.contains('politik') || cat.contains('pemerintah') || cat.contains('layanan publik') || cat.contains('geopolitik')) {
      return 'https://images.unsplash.com/photo-1523995462485-3d171b5c8fa9?auto=format&fit=crop&q=80&w=200'; // Gov/News
    } else {
      return 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?auto=format&fit=crop&q=80&w=200'; // General news
    }
  }
}
