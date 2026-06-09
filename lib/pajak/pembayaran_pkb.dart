import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// METODE PEMBAYARAN PAGE
// ─────────────────────────────────────────────
class PembayaranPkbPage extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  final Map<String, dynamic> latestBill;

  const PembayaranPkbPage({
    super.key,
    required this.vehicle,
    required this.latestBill,
  });

  @override
  State<PembayaranPkbPage> createState() => _PembayaranPkbPageState();
}

class _PembayaranPkbPageState extends State<PembayaranPkbPage> {
  String _expandedMethod = ''; // 'QRIS' or 'VA'
  String _selectedBank = ''; // 'Mandiri', 'BCA', 'BRI', 'BNI'

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
          'Pembayaran Pajak Kendaraan',
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
            // Informasi Biaya
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCol('Merk', widget.vehicle['merk']?.toString() ?? '-'),
                      _buildInfoCol('No. Polisi', widget.vehicle['nopol']?.toString() ?? '-'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 16),
                  _buildCostRow('PKB Pokok', _formatCurrency(widget.latestBill['pokok_pkb'] ?? 0)),
                  _buildCostRow('PKB Denda', _formatCurrency(widget.latestBill['denda_pkb'] ?? 0)),
                  _buildCostRow('SWDKLLJ Pokok', _formatCurrency(widget.latestBill['swdkllj'] ?? 0)),
                  _buildCostRow('SWDKLLJ Denda', _formatCurrency(widget.latestBill['denda_swdkllj'] ?? 0)),
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
                          Text(_formatCurrency(widget.latestBill['total'] ?? 0), style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pilih Metode Pembayaran
            const Text('Pilih Metode Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: [
                  _buildQrisOption(),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildVaOption(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
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
                width: 60,
                child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrisOption() {
    final isExpanded = _expandedMethod == 'QRIS';
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() {
            _expandedMethod = isExpanded ? '' : 'QRIS';
          }),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.qr_code_scanner, color: Color(0xFF6B7280), size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Bayar dengan QRIS', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500)),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_down : Icons.radio_button_unchecked,
                  color: isExpanded ? const Color(0xFF1A1A1A) : const Color(0xFF9CA3AF),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => BayarQrisPage(
                  total: widget.latestBill['total'] ?? 0,
                )));
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2979FF)),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Dapatkan Kode QR', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
            ),
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildVaOption() {
    final isExpanded = _expandedMethod == 'VA';
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() {
            _expandedMethod = isExpanded ? '' : 'VA';
          }),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.credit_card, color: Color(0xFF6B7280), size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Bayar dengan Virtual Account', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500)),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                  color: isExpanded ? const Color(0xFF1A1A1A) : const Color(0xFF9CA3AF),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                _buildBankRadio('Mandiri', 'mandiri'),
                _buildBankRadio('BCA', 'bca'),
                _buildBankRadio('BRI', 'bri'),
                _buildBankRadio('BNI', 'bni'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _selectedBank.isEmpty ? null : () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => BayarVaPage(
                      total: widget.latestBill['total'] ?? 0,
                      vehicle: widget.vehicle,
                    )));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledBackgroundColor: const Color(0xFFE5E7EB),
                    disabledForegroundColor: const Color(0xFF9CA3AF),
                  ),
                  child: const Text('Dapatkan Virtual Account', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildBankRadio(String bankName, String bankCode) {
    final isSelected = _selectedBank == bankCode;
    return InkWell(
      onTap: () => setState(() => _selectedBank = bankCode),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Placeholder for bank icon
            Container(
              width: 40,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  bankName,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF6B7280)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(bankName, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500)),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFF2979FF) : const Color(0xFF9CA3AF),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// QRIS PAYMENT PAGE
// ─────────────────────────────────────────────
class BayarQrisPage extends StatelessWidget {
  final num total;
  const BayarQrisPage({super.key, required this.total});

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
        title: const Text('Bayar dengan QRIS', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  const Text('Selesaikan Pembayaran Sebelum', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
                  const SizedBox(height: 8),
                  const CountdownHeaderWidget(),
                  const SizedBox(height: 24),
                  
                  // QRIS Code Placeholder
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.qr_code_2, size: 150, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 12),
                  const Text('Unduh QRIS', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                  const SizedBox(height: 24),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nominal Bayar', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
                      Row(
                        children: [
                          Text('Rp ${_formatCurrency(total)}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Text('Salin', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Lihat Panduan Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// VIRTUAL ACCOUNT PAYMENT PAGE
// ─────────────────────────────────────────────
class BayarVaPage extends StatelessWidget {
  final num total;
  final Map<String, dynamic> vehicle;
  
  const BayarVaPage({super.key, required this.total, required this.vehicle});

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
        title: const Text('Bayar dengan Virtual Account', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selesaikan Pembayaran Sebelum', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
                  const SizedBox(height: 8),
                  const CountdownHeaderWidget(),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 20),
                  
                  const Text('Virtual Account dengan BCA', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Text('8808123456789012', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('Salin', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  const Text('Nominal Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Rp. ${_formatCurrency(total)}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      const Text('Salin', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 20),
                  
                  const Text('Informasi Kendaraan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildCopyRow('NIK Pemilik', vehicle['nik_pemilik']?.toString() ?? '-'),
                  const SizedBox(height: 12),
                  _buildCopyRow('Nomor Polisi', vehicle['nopol']?.toString() ?? '-'),
                  const SizedBox(height: 12),
                  _buildCopyRow('Nomor Rangka', vehicle['no_rangka']?.toString() ?? '-'),
                  
                  const SizedBox(height: 24),
                  const Center(child: Text('Lihat Panduan Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2979FF)))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Text('Salin', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SHARED ACTION BUTTONS & DIALOGS
// ─────────────────────────────────────────────
Widget _buildActionButtons(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const PembayaranBerhasilPage()),
              (route) => route.isFirst,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2979FF),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Saya Sudah Membayar', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        ),
      ),
      const SizedBox(height: 16),
      GestureDetector(
        onTap: () {
          _showCancelDialog(context);
        },
        child: const Text('Batalkan Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
      ),
      const SizedBox(height: 32),
    ],
  );
}

void _showCancelDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Apakah Anda ingin membatalkan pembayaran?',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Proses ini akan membatalkan transaksi yang sedang berlangsung',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280), height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Tetap lanjutkan transaksi', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
                _showCancelSuccessDialog(context);
              },
              child: const Text('Ya, batalkan transaksi', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showCancelSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(color: Color(0xFF2979FF), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transaksi berhasil dibatalkan',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pop(context); // Go back to payment selection
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Kembali', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────
// PEMBAYARAN BERHASIL PAGE
// ─────────────────────────────────────────────
class PembayaranBerhasilPage extends StatelessWidget {
  const PembayaranBerhasilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Konfirmasi Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(color: Color(0xFF2979FF), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pembayaran Berhasil',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'E-SKKP Pajak Kendaraan\nAnda akan Diperbarui',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A), height: 1.3),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pembaruan E-SKKP (Surat Ketetapan Kewajiban Pembayaran Elektronik) akan membutuhkan waktu. Mohon periksa secara berkala.',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280), height: 1.5),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EskkpViewerPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Lihat Bukti E-SKKP', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// COUNTDOWN HEADER WIDGET
// ─────────────────────────────────────────────
class CountdownHeaderWidget extends StatefulWidget {
  const CountdownHeaderWidget({super.key});

  @override
  State<CountdownHeaderWidget> createState() => _CountdownHeaderWidgetState();
}

class _CountdownHeaderWidgetState extends State<CountdownHeaderWidget> {
  late DateTime _targetTime;
  late Duration _remaining;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _targetTime = DateTime.now().add(const Duration(minutes: 30));
    _updateTimer();
  }

  void _updateTimer() {
    if (!mounted) return;
    setState(() {
      final now = DateTime.now();
      if (_targetTime.isBefore(now)) {
        _remaining = Duration.zero;
        _isFinished = true;
      } else {
        _remaining = _targetTime.difference(now);
      }
    });

    if (!_isFinished) {
      Future.delayed(const Duration(seconds: 1), _updateTimer);
    }
  }

  String _formatDate(DateTime date) {
    const days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final dayName = days[date.weekday % 7];
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$dayName, $day-$month-$year\n$hour.$minute WIB';
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '00:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDate(_targetTime),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _isFinished ? const Color(0xFFFEE2E2) : const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _formatDuration(_remaining),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _isFinished ? const Color(0xFFEF4444) : const Color(0xFF2979FF),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// E-SKKP VIEWER PAGE
// ─────────────────────────────────────────────
class EskkpViewerPage extends StatelessWidget {
  const EskkpViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Bukti E-SKKP', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Set to false to prevent panning.
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.asset(
            'assets/eskkp_dummy.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
