import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/pajak/services/bapenda_service.dart';

class HasilNjkbPage extends StatefulWidget {
  final String? merk;
  final String? tipe;
  final String? tahun;
  final String? model;

  const HasilNjkbPage({super.key, this.merk, this.tipe, this.tahun, this.model});

  @override
  State<HasilNjkbPage> createState() => _HasilNjkbPageState();
}

class _HasilNjkbPageState extends State<HasilNjkbPage> {
  final BapendaService _bapendaService = BapendaService();
  bool _isLoading = true;
  Map<String, dynamic>? _vehicleData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final results = await _bapendaService.searchNjkb(widget.merk, widget.tahun);
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (results.isNotEmpty) {
          // If tipe is provided, try to find an exact match, otherwise just take the first one
          _vehicleData = results.firstWhere(
            (v) => v['tipe'] == widget.tipe,
            orElse: () => results.first,
          );
        }
      });
    }
  }

  String _formatRp(double value) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
    return formatter.format(value).trim();
  }

  @override
  Widget build(BuildContext context) {
    // Math logic based on NJKB and bobot
    double dpp = 0;
    if (_vehicleData != null) {
      final double njkb = (_vehicleData!['nilai_njkb'] ?? 0).toDouble();
      final double bobot = (_vehicleData!['bobot'] ?? 1.0).toDouble();
      dpp = njkb * bobot;
    }

    final double pkbHitam = dpp * 0.015;
    final double opsenHitam = pkbHitam * 0.66;
    
    final double pkbKuning = dpp * 0.005;
    final double opsenKuning = pkbKuning * 0.66;

    final double pkbMerah = dpp * 0.005;
    final double opsenMerah = pkbMerah * 0.66;
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hasil Pencarian NJKB',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Kendaraan
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_vehicleData == null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
                child: const Text('Data NJKB tidak ditemukan', style: TextStyle(fontFamily: 'Poppins')),
              )
            else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Merk & Type', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
                        const SizedBox(height: 2),
                        Text('${(_vehicleData!['merk'] ?? '').toString().toUpperCase()}\n${(_vehicleData!['tipe'] ?? '').toString().toUpperCase()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 16),
                        const Text('Detail Kendaraan', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(4)),
                              child: Text('Model: ${widget.model ?? 'MINIBUS'}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(4)),
                              child: Text('Tahun: ${_vehicleData!['tahun'] ?? ''}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: 10,
                      child: Icon(Icons.directions_car, size: 80, color: const Color(0xFF2979FF).withValues(alpha: 0.3)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),


              const Text('Estimasi Pajak Tahunan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Plat Hitam
              _buildTaxCard(
                headerColor: Colors.black,
                headerText: 'Plat Hitam',
                headerTextColor: Colors.white,
                bodyColor: Colors.white,
                pkbPotensial: _formatRp(pkbHitam),
                opsenPkb: _formatRp(opsenHitam),
                footerText: 'Umum/Pribadi',
                footerTextColor: const Color(0xFF6B7280),
              ),
              const SizedBox(height: 16),

              // Plat Kuning
              _buildTaxCard(
                headerColor: const Color(0xFFF59E0B),
                headerText: 'Plat Kuning',
                headerTextColor: Colors.white,
                bodyColor: const Color(0xFFFEF3C7),
                pkbPotensial: _formatRp(pkbKuning),
                opsenPkb: _formatRp(opsenKuning),
                footerText: 'Angkutan Umum',
                footerTextColor: const Color(0xFFD97706),
              ),
              const SizedBox(height: 16),

              // Plat Merah
              _buildTaxCard(
                headerColor: const Color(0xFFE11D48),
                headerText: 'Plat Merah',
                headerTextColor: Colors.white,
                bodyColor: const Color(0xFFFFE4E6),
                pkbPotensial: _formatRp(pkbMerah),
                opsenPkb: _formatRp(opsenMerah),
                footerText: 'Pemerintah',
                footerTextColor: const Color(0xFFBE123C),
              ),
              const SizedBox(height: 24),

              const Text('Penerimaan Negara Bukan Pajak', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    _buildRowItem('PNBP BPKB', '375.000'),
                    const SizedBox(height: 12),
                    _buildRowItem('PNBP STNK', '200.000'),
                    const SizedBox(height: 12),
                    _buildRowItem('PNBP TNKB', '100.000'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('Bea Balik Nama', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    _buildRowItem('BBN 1 (Kendaraan Baru)', _formatRp(dpp * 0.1)),
                    const SizedBox(height: 12),
                    _buildRowItem('BBN 1 (Kendaraan Bekas)', '0'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Color(0xFF6B7280)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: const Text(
                        'Nilai yang tertera adalah estimasi dasar pengenaan pajak dan tarif PNBP standar. Biaya sebenarnya dapat berbeda tergantung pada kebijakan daerah, denda keterlambatan (jika ada), pajak progresif, dan biaya administrasi lainnya. Informasi ini sebaiknya digunakan sebagai referensi awal saja.',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280), height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ], // Close the else ...[ block
            const SizedBox(height: 32),

            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text('Kembali', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxCard({
    required Color headerColor,
    required String headerText,
    required Color headerTextColor,
    required Color bodyColor,
    required String pkbPotensial,
    required String opsenPkb,
    required String footerText,
    required Color footerTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bodyColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: headerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Text(
              headerText,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: headerTextColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildRowItem('PKB Potensial', pkbPotensial),
                const SizedBox(height: 12),
                _buildRowItem('Opsen PKB', opsenPkb),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 12),
                Text(
                  footerText,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: footerTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
        Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
      ],
    );
  }
}
