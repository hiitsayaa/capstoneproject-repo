import 'package:flutter/material.dart';
import 'package:flutter_application_1/pajak/pembayaran_pkb.dart';
import 'package:flutter_application_1/pajak/services/bapenda_service.dart';

class DetailKendaraanPage extends StatefulWidget {
  final String nopol;
  const DetailKendaraanPage({super.key, required this.nopol});

  @override
  State<DetailKendaraanPage> createState() => _DetailKendaraanPageState();
}

class _DetailKendaraanPageState extends State<DetailKendaraanPage> {
  final BapendaService _bapendaService = BapendaService();
  bool _isLoading = true;
  Map<String, dynamic>? _vehicleData;
  Map<String, dynamic>? _latestBill;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final result = await _bapendaService.checkPkb(widget.nopol);
    if (mounted) {
      setState(() {
        if (result != null) {
          _vehicleData = result['vehicle'];
          final bills = result['bills'] as List? ?? [];
          if (bills.isNotEmpty) {
            _latestBill = bills.first;
          }
        }
        _isLoading = false;
      });
    }
  }

  String _formatCurrency(num amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
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
          'Informasi Kendaraan Saya',
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
        : _vehicleData == null
            ? const Center(child: Text('Data tidak ditemukan', style: TextStyle(fontFamily: 'Poppins')))
            : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Informasi Kendaraan Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informasi Kendaraan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildInfoPair('Merk', _vehicleData!['merk'] ?? '-')),
                      Expanded(child: _buildInfoPair('Model', _vehicleData!['tipe'] ?? '-')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInfoPair('No. Polisi', _vehicleData!['nopol'] ?? '-')),
                      Expanded(child: _buildInfoPair('Warna', 'BLACK')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInfoPair('Tgl. Jatuh Tempo', _latestBill?['due_date'] ?? '-')),
                      Expanded(child: _buildInfoPair('Tahun Pembuatan', _vehicleData!['tahun']?.toString() ?? '-')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInfoPair('Nomor Rangka', _vehicleData!['no_rangka'] ?? '-')),
                      Expanded(child: _buildInfoPair('Nomor Mesin', _vehicleData!['no_mesin'] ?? '-')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Informasi Biaya Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informasi Biaya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildCostRow('PKB Pokok', _formatCurrency(_latestBill?['pokok_pkb'] ?? 0)),
                  _buildCostRow('PKB Denda', _formatCurrency(_latestBill?['denda_pkb'] ?? 0)),
                  _buildCostRow('SWDKLLJ Pokok', _formatCurrency(_latestBill?['swdkllj'] ?? 0)),
                  _buildCostRow('SWDKLLJ Denda', _formatCurrency(_latestBill?['denda_swdkllj'] ?? 0)),
                  _buildCostRow('PNPB STNK', '0'),
                  _buildCostRow('PNPB TNKB', '0'),
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Text('Rp. ', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
                          Text(_latestBill != null ? _formatCurrency(_latestBill!['total'] ?? 0) : '0', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isLoading || _vehicleData == null ? null : Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: _latestBill == null || _latestBill!['status'] == 'Paid' ? null : () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PembayaranPkbPage(
                vehicle: _vehicleData!,
                latestBill: _latestBill!,
              )),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2979FF),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledBackgroundColor: const Color(0xFFE5E7EB),
          ),
          child: const Text('Lanjutkan Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _buildInfoPair(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildCostRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
          Row(
            children: [
              const Text('Rp. ', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
              SizedBox(
                width: 75,
                child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
