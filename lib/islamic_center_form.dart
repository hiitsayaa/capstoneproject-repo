import 'package:flutter/material.dart';

class IslamicCenterFormPage extends StatefulWidget {
  const IslamicCenterFormPage({super.key});

  @override
  State<IslamicCenterFormPage> createState() => _IslamicCenterFormPageState();
}

class _IslamicCenterFormPageState extends State<IslamicCenterFormPage> {
  int _currentStep = 1;

  // Step 1 Form Data
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _paxController = TextEditingController();
  String _waktu = 'Siang';
  
  bool _karpet = false;
  bool _meja = false;

  // Step 3 state
  String? _paymentMethod;
  bool _showPaymentInstruction = false;

  @override
  Widget build(BuildContext context) {
    String title = 'Pemesanan Ruang';
    if (_currentStep == 3 && _showPaymentInstruction) {
      title = _paymentMethod == 'QRIS' ? 'Bayar dengan QRIS' : 'Bayar dengan Virtual Account';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () {
            if (_currentStep == 3 && _showPaymentInstruction) {
              setState(() => _showPaymentInstruction = false);
            } else if (_currentStep > 1 && _currentStep < 4) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          if (_currentStep < 4 && !_showPaymentInstruction) _buildStepperHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildStepContent(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStepperHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepCircle(1, 'Data Pesanan'),
          _buildStepLine(1),
          _buildStepCircle(2, 'Ringkasan'),
          _buildStepLine(2),
          _buildStepCircle(3, 'Pembayaran'),
          _buildStepLine(3),
          _buildStepCircle(4, 'Selesai'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label) {
    bool isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2979FF) : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(step.toString(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 9, color: isActive ? Colors.black87 : Colors.grey)),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    bool isActive = _currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16),
        color: isActive ? const Color(0xFF2979FF) : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildStepContent() {
    if (_currentStep == 1) return _buildStep1();
    if (_currentStep == 2) return _buildStep2();
    if (_currentStep == 3 && !_showPaymentInstruction) return _buildStep3Select();
    if (_currentStep == 3 && _showPaymentInstruction) return _buildStep3Instruction();
    if (_currentStep == 4) return _buildStep4();
    return const SizedBox();
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRoomInfoCard(),
        const SizedBox(height: 24),
        const Text('Informasi Pemesan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildTextField('Nama Lengkap', 'Masukkan nama lengkap', _nameController),
        const SizedBox(height: 12),
        _buildTextField('Nomor Telepon', 'Masukkan nomor telepon', _phoneController),
        const SizedBox(height: 24),
        const Text('Detail Acara', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildTextField('Pilih Tanggal Acara', 'Pilih tanggal acara', _dateController, icon: Icons.calendar_today),
        const SizedBox(height: 12),
        _buildTextField('Jumlah Tamu', 'Masukkan perkiraan jumlah tamu', _paxController),
        const SizedBox(height: 16),
        const Text('Waktu', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
        Row(
          children: [
            // ignore: deprecated_member_use
            Radio(value: 'Siang', groupValue: _waktu, onChanged: (v) => setState(() => _waktu = v.toString())),
            const Text('Siang (08.00 - 15.00)', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
          ],
        ),
        Row(
          children: [
            // ignore: deprecated_member_use
            Radio(value: 'Malam', groupValue: _waktu, onChanged: (v) => setState(() => _waktu = v.toString())),
            const Text('Malam (18.00 - 22.00)', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Fasilitas Tambahan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
        const Text('Pilih fasilitas tambahan sesuai kebutuhan Anda', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 12),
        _buildCheckbox('Karpet', '+ Rp500.000', _karpet, (v) => setState(() => _karpet = v!)),
        _buildCheckbox('Meja & Kursi', '+ Rp600.000', _meja, (v) => setState(() => _meja = v!)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Estimasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold)),
            Text('Rp${_calculateTotal()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Detail Pesanan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildRoomInfoCard(),
        const SizedBox(height: 20),
        _buildSummaryRow('Nama', _nameController.text.isEmpty ? 'Ahmad Putra' : _nameController.text),
        _buildSummaryRow('Nomor Telepon', _phoneController.text.isEmpty ? '081234567890' : _phoneController.text),
        _buildSummaryRow('Tanggal Acara', _dateController.text.isEmpty ? '12 Juni 2025' : _dateController.text),
        _buildSummaryRow('Jumlah Tamu', _paxController.text.isEmpty ? '1800 Orang' : '${_paxController.text} Orang'),
        _buildSummaryRow('Waktu', _waktu == 'Siang' ? 'Siang (08.00 - 15.00)' : 'Malam (18.00 - 22.00)'),
        const SizedBox(height: 16),
        const Text('Fasilitas Tambahan', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (_karpet) _buildSummaryRow('• Karpet', '+ Rp500.000'),
        if (_meja) _buildSummaryRow('• Meja & Kursi', '+ Rp600.000'),
        if (!_karpet && !_meja) const Text('-', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
        const SizedBox(height: 24),
        const Text('Rincian Biaya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildCostRow('Harga Sewa Gedung', 'Rp10.000.000'),
              _buildCostRow('Fasilitas Tambahan', 'Rp${_getTambahanCost()}'),
              const Divider(height: 24),
              _buildCostRow('Subtotal', 'Rp${_getSubtotal()}'),
              _buildCostRow('Pajak & Layanan (11%)', 'Rp${_getTax()}'),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold)),
                  Text('Rp${_calculateTotal()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3Select() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pilih Metode Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildPaymentMethod('Bayar dengan QRIS', 'QRIS'),
        const SizedBox(height: 12),
        _buildPaymentMethod('Bayar dengan Virtual Account', 'VA'),
      ],
    );
  }

  Widget _buildStep3Instruction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text('Selesaikan Pembayaran Sebelum', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sabtu, 25-04-2025', style: TextStyle(fontFamily: 'Poppins', fontSize: 11)),
                        Text('20.00 WIB', style: TextStyle(fontFamily: 'Poppins', fontSize: 11)),
                      ],
                    ),
                    Text('00:42:56', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_paymentMethod == 'QRIS') ...[
                const Icon(Icons.qr_code_2, size: 200),
                const Text('Unduh QRIS', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Virtual Account Bank Jatim', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('8808123456789012', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Salin', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nominal Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
                  Text('Rp${_calculateTotal()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Lihat Panduan Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 80, height: 80,
          decoration: const BoxDecoration(color: Color(0xFF2979FF), shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 20),
        const Text('Pembayaran Berhasil', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Pemesanan Anda telah dikonfirmasi.', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _buildCostRow('No. Pesanan', 'AULA-25042025123'),
              _buildCostRow('Ruangan', 'Aula - Hall Utama'),
              _buildCostRow('Tanggal', _dateController.text.isEmpty ? '12 Juni 2025' : _dateController.text),
              _buildCostRow('Jumlah Tamu', _paxController.text.isEmpty ? '1800 Orang' : '${_paxController.text} Orang'),
              _buildCostRow('Waktu', _waktu == 'Siang' ? 'Siang (08.00 - 15.00)' : 'Malam (18.00 - 22.00)'),
              _buildCostRow('Metode Pembayaran', _paymentMethod ?? 'QRIS'),
              const Divider(height: 24),
              _buildCostRow('Total Pembayaran', 'Rp${_calculateTotal()}'),
            ],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF2979FF)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Download Invoice', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2979FF))),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Kembali ke Beranda', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomBar() {
    if (_currentStep == 4) return null;

    if (_currentStep == 3 && _showPaymentInstruction) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() => _currentStep = 4),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2979FF), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Saya Sudah Membayar', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => setState(() => _showPaymentInstruction = false),
                  child: const Text('Batalkan Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))]),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_currentStep == 1) {
                setState(() => _currentStep = 2);
              } else if (_currentStep == 2) {
                setState(() => _currentStep = 3);
              } else if (_currentStep == 3) {
                if (_paymentMethod != null) {
                  setState(() => _showPaymentInstruction = true);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2979FF),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              _currentStep == 3 ? 'Lanjutkan Pembayaran' : 'Lanjutkan',
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 80, height: 60,
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hall Utama', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
              Text('Aula', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey),
            suffixIcon: icon != null ? Icon(icon, size: 20, color: Colors.grey) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String title, String price, bool value, void Function(bool?) onChanged) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13)),
          Text(price, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black87)),
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: const Color(0xFF2979FF),
      dense: true,
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black87)),
          Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String title, String method) {
    bool isSelected = _paymentMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600)),
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSelected ? const Color(0xFF2979FF) : Colors.grey),
          ],
        ),
      ),
    );
  }

  int _getTambahanCost() {
    int cost = 0;
    if (_karpet) cost += 500000;
    if (_meja) cost += 600000;
    return cost;
  }

  String _getSubtotal() {
    return '1${_getTambahanCost() == 1100000 ? "1.100.000" : _getTambahanCost() == 600000 ? "0.600.000" : _getTambahanCost() == 500000 ? "0.500.000" : "0.000.000"}';
  }

  String _getTax() {
    int subtotal = 10000000 + _getTambahanCost();
    int tax = (subtotal * 0.11).round();
    String t = tax.toString();
    if (t.length > 6) return '${t.substring(0, 1)}.${t.substring(1, 4)}.${t.substring(4)}';
    return '${t.substring(0, 3)}.${t.substring(3)}';
  }

  String _calculateTotal() {
    int subtotal = 10000000 + _getTambahanCost();
    int tax = (subtotal * 0.11).round();
    int total = subtotal + tax;
    String t = total.toString();
    if (t.length > 6) return '${t.substring(0, 2)}.${t.substring(2, 5)}.${t.substring(5)}';
    return '${t.substring(0, 3)}.${t.substring(3)}';
  }
}
