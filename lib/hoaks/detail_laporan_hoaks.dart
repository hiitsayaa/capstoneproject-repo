import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../core/api_constants.dart';

class DetailLaporanHoaksPage extends StatefulWidget {
  final String ticketId;

  const DetailLaporanHoaksPage({super.key, required this.ticketId});

  @override
  State<DetailLaporanHoaksPage> createState() => _DetailLaporanHoaksPageState();
}

class _DetailLaporanHoaksPageState extends State<DetailLaporanHoaksPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _ticketData;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/tickets/${widget.ticketId}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _ticketData = data['data'] ?? data;
            _isLoading = false;
          });
        }
      } else {
        _useMockData();
      }
    } catch (e) {
      _useMockData();
    }
  }

  void _useMockData() {
    if (mounted) {
      setState(() {
        _ticketData = {
          'status': 'Sedang diverifikasi',
          'title': 'Berita wilayah Surabaya akan dilanda gempa bumi raksasa dengan kekuatan 12,7 SR',
          'updated_at': '2026-04-10T12:00:00Z',
          'description': 'Saya ingin melaporkan temuan konten disinformasi berupa berita bohong (hoaks) yang menyebarkan klaim bahwa wilayah Surabaya akan dilanda gempa bumi raksasa berkekuatan 12,7 SR dalam waktu dekat. Pesan ini telah menimbulkan keresahan di masyarakat karena mencantumkan angka magnitudo yang tidak masuk akal secara ilmiah dan mencatut nama wilayah tanpa sumber valid dari pihak berwenang seperti BMKG. Narasi ini berpotensi memicu kepanikan massal dan gangguan ketertiban umum, sehingga saya memohon agar pihak terkait segera menindaklanjuti konten tersebut dengan melakukan pemblokiran atau memberikan klarifikasi resmi guna mencegah penyebaran yang lebih luas di media sosial dan grup percakapan.',
          'url_bukti': 'https://www.example.com/berita-hoaks-surabaya',
        };
        _isLoading = false;
      });
    }
  }

  String _mapStatus(String status) {
    status = status.toLowerCase();
    if (status.contains('investigating') || status.contains('analisis')) return 'Dalam Proses Analisis';
    if (status.contains('selesai') || status.contains('resolved')) return 'Selesai';
    if (status.contains('ditolak') || status.contains('rejected')) return 'Ditolak';
    return 'Sedang diverifikasi';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Laporan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ticketData == null
              ? const Center(child: Text('Data tidak ditemukan', style: TextStyle(fontFamily: 'Poppins')))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final statusRaw = _ticketData?['status'] ?? '';
    final status = _mapStatus(statusRaw);
    final title = _ticketData?['title'] ?? '';
    final description = _ticketData?['description'] ?? _ticketData?['deskripsi_kejadian'] ?? '-';
    final urlBukti = _ticketData?['url_bukti'] ?? '-';
    
    DateTime date = DateTime.now();
    if (_ticketData?['updated_at'] != null) {
      date = DateTime.parse(_ticketData!['updated_at']).toLocal();
    } else if (_ticketData?['created_at'] != null) {
      date = DateTime.parse(_ticketData!['created_at']).toLocal();
    }
    
    // Format: 10 April 2026, 12.00
    final dateStr = DateFormat('dd MMMM yyyy, HH.mm', 'id_ID').format(date);

    Color statusColor;
    IconData statusIcon;
    switch (status.toLowerCase()) {
      case 'sedang diverifikasi':
        statusColor = const Color(0xFFF59E0B);
        statusIcon = Icons.check_circle_outline;
        break;
      case 'dalam proses analisis':
        statusColor = const Color(0xFF2979FF);
        statusIcon = Icons.search;
        break;
      case 'selesai':
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.check;
        break;
      case 'ditolak':
        statusColor = const Color(0xFFEF4444);
        statusIcon = Icons.close;
        break;
      default:
        statusColor = const Color(0xFF6B7280);
        statusIcon = Icons.info_outline;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, size: 14, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          
          // Date
          Text(
            'Dilaporkan pada: $dateStr',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 24),
          
          // Section Title
          const Text(
            'Detail Laporan',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          
          // Isi Laporan
          const Text(
            'Isi Laporan',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          
          // Link/Sumber
          const Text(
            'Link /Sumber',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            urlBukti.isEmpty ? '-' : urlBukti,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          
          // File
          const Text(
            'File',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '-', // Still placeholder for now
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
