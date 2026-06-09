import 'package:flutter/material.dart';
import 'package:flutter_application_1/bansos/services/bansos_service.dart';
import 'package:flutter_application_1/auth/services/auth_service.dart';

class SapaBansosHasilPage extends StatefulWidget {
  final String nik;

  const SapaBansosHasilPage({
    super.key,
    required this.nik,
  });

  @override
  State<SapaBansosHasilPage> createState() => _SapaBansosHasilPageState();
}

class _SapaBansosHasilPageState extends State<SapaBansosHasilPage> {
  final BansosService _bansosService = BansosService();
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  String _errorMessage = '';
  
  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _bansosApplication;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final profile = await _authService.getFullProfile();
      final statuses = await _bansosService.getStatus();

      setState(() {
        _profile = profile;
        if (statuses.isNotEmpty) {
          _bansosApplication = statuses.first as Map<String, dynamic>;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatCurrency(num value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hasil Pencarian',
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
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: const TextStyle(fontFamily: 'Poppins', color: Colors.red)))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Data Diri
                        const Text(
                          'Data Diri',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDataRow('Nama', _profile?['nama_lengkap'] ?? '-'),
                        const SizedBox(height: 8),
                        _buildDataRow('Nama Ibu Kandung', _bansosApplication?['nama_ibu_kandung'] ?? '-'),
                        const SizedBox(height: 8),
                        _buildDataRow('NIK', _profile?['nik'] ?? widget.nik),
                        const SizedBox(height: 8),
                        _buildDataRow('Penghasilan', _bansosApplication != null ? _formatCurrency(_bansosApplication!['penghasilan_bulanan'] as num) : '-'),
                        const SizedBox(height: 8),
                        _buildDataRow('Tanggungan', _bansosApplication?['jumlah_tanggungan']?.toString() ?? '-'),
                        const SizedBox(height: 24),

                        // Informasi Bansos
                        const Text(
                          'Informasi Bansos',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_bansosApplication == null)
                          const Text(
                            'Belum ada pengajuan bansos.',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280)),
                          )
                        else
                          _buildBansosCard(
                            title: _bansosApplication!['nama_program']?.toString() ?? 'Program Keluarga Harapan Plus',
                            status: _bansosApplication!['status']?.toString() ?? 'Menunggu Verifikasi',
                            periode: '2026',
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        const Text(
          ':',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBansosCard({
    required String title,
    required String status,
    required String periode,
  }) {
    Color statusColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'approved':
        statusColor = const Color(0xFF4CAF50);
        statusText = 'Disetujui';
        break;
      case 'rejected':
        statusColor = const Color(0xFFF44336);
        statusText = 'Ditolak';
        break;
      case 'verifying':
      case 'submitted':
      default:
        statusColor = const Color(0xFFFFA000);
        statusText = 'Menunggu Verifikasi';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 80,
                child: Text(
                  'Status',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280)),
                ),
              ),
              Expanded(
                child: Text(
                  statusText,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 80,
                child: Text(
                  'Periode',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280)),
                ),
              ),
              Expanded(
                child: Text(
                  periode,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
