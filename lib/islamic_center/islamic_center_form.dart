import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/islamic_center/services/islamic_center_service.dart';
import 'package:flutter_application_1/auth/services/auth_service.dart';
import 'package:intl/intl.dart';

class IslamicCenterFormPage extends StatefulWidget {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String price;
  final String pax;

  const IslamicCenterFormPage({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.pax,
  });

  @override
  State<IslamicCenterFormPage> createState() => _IslamicCenterFormPageState();
}

class _IslamicCenterFormPageState extends State<IslamicCenterFormPage> {
  int _currentStep = 1;

  // Step 1 Form Data
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  late TextEditingController _paxController;
  String _waktu = 'Siang';
  
  bool _karpet = false;
  bool _meja = false;

  // Step 3 state
  String? _paymentMethod;
  bool _showPaymentInstruction = false;
  bool _isCreatingBooking = false;
  Map<String, dynamic>? _bookingResult;

  int _basePrice = 0;
  Timer? _timer;
  Duration _remainingTime = const Duration(hours: 24);

  void _startTimer() {
    _timer?.cancel();
    _remainingTime = const Duration(hours: 24);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _paxController = TextEditingController(text: widget.pax);
    _parseBasePrice();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final profile = await AuthService().getFullProfile();
    if (profile != null && mounted) {
      setState(() {
        if (_nameController.text.isEmpty) {
          _nameController.text = profile['nama_lengkap'] ?? '';
        }
        if (_phoneController.text.isEmpty) {
          _phoneController.text = profile['telepon'] ?? '';
        }
      });
    }
  }

  void _parseBasePrice() {
    if (widget.price.toLowerCase().contains('gratis')) {
      _basePrice = 0;
    } else {
      String clean = widget.price.replaceAll(RegExp(r'[^0-9]'), '');
      if (clean.isNotEmpty) {
        _basePrice = int.parse(clean);
      }
    }
  }

  String _formatCurrency(int amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(amount);
  }

  DateTime? _selectedDate;

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
        _dateController.text = "${picked.day} ${months[picked.month - 1]} ${picked.year}";
      });
    }
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

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
        _buildTextField('Pilih Tanggal Acara', 'Masukkan tanggal acara', _dateController, icon: Icons.calendar_today, readOnly: true, onTap: _showDatePicker),
        const SizedBox(height: 12),
        _buildTextField('Jumlah Tamu', 'Masukkan perkiraan jumlah tamu', _paxController),
        const SizedBox(height: 16),
        const Text('Waktu', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
        Row(
          children: [
            Radio(value: 'Siang', groupValue: _waktu, onChanged: (v) => setState(() => _waktu = v.toString())),
            const Text('Siang (08.00 - 15.00)', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
          ],
        ),
        Row(
          children: [
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
            Text(_formatCurrency(_calculateTotal()), style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
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
              _buildCostRow('Harga Sewa Gedung', _formatCurrency(_basePrice)),
              _buildCostRow('Fasilitas Tambahan', _formatCurrency(_getTambahanCost())),
              const Divider(height: 24),
              _buildCostRow('Subtotal', _formatCurrency(_getSubtotal())),
              _buildCostRow('Pajak & Layanan (11%)', _formatCurrency(_getTax())),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(_formatCurrency(_calculateTotal()), style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Besok', style: TextStyle(fontFamily: 'Poppins', fontSize: 11)),
                        Text('23.59 WIB', style: TextStyle(fontFamily: 'Poppins', fontSize: 11)),
                      ],
                    ),
                    Text(_formatDuration(_remainingTime), style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
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
                  Text(_formatCurrency(_calculateTotal()), style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
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
              _buildCostRow('No. Pesanan', _bookingResult?['id'] ?? 'IC-123456789'),
              _buildCostRow('Ruangan', '${widget.category} - ${widget.title}'),
              _buildCostRow('Tanggal', _dateController.text.isEmpty ? '12 Juni 2025' : _dateController.text),
              _buildCostRow('Jumlah Tamu', _paxController.text.isEmpty ? '0 Orang' : '${_paxController.text} Orang'),
              _buildCostRow('Waktu', _waktu == 'Siang' ? 'Siang (08.00 - 15.00)' : 'Malam (18.00 - 22.00)'),
              _buildCostRow('Metode Pembayaran', _paymentMethod ?? 'QRIS'),
              const Divider(height: 24),
              _buildCostRow('Total Pembayaran', _formatCurrency(_calculateTotal())),
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

  Future<void> _handlePayment() async {
    setState(() => _isCreatingBooking = true);
    
    // Create booking in database
    List<String> catatanTambahan = [];
    if (_karpet) catatanTambahan.add('Karpet');
    if (_meja) catatanTambahan.add('Meja & Kursi');

    String formatTanggal(DateTime? d) {
      if (d == null) return '2025-06-12';
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }

    final result = await IslamicCenterService.createBooking(
      facilityId: widget.id,
      namaPemohon: _nameController.text.isEmpty ? 'Ahmad Putra' : _nameController.text,
      telepon: _phoneController.text.isEmpty ? '081234567890' : _phoneController.text,
      email: 'user@example.com',
      tanggal: formatTanggal(_selectedDate),
      waktu: _waktu,
      catatan: catatanTambahan.isNotEmpty ? 'Fasilitas: ${catatanTambahan.join(', ')}' : null,
    );

    setState(() {
      _isCreatingBooking = false;
      _currentStep = 4;
      if (result != null) {
        _bookingResult = result;
      } else {
        // Fallback agar no pesanan tidak bergerak jika server error
        _bookingResult = {
          'id': 'INV-${DateTime.now().millisecondsSinceEpoch}',
        };
      }
    });

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan ke database, tapi simulasi sukses.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Berhasil Menyimpan')));
    }
  }

  Widget? _buildBottomBar() {
    if (_currentStep == 4) return null;

    if (_currentStep == 3 && _showPaymentInstruction) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCreatingBooking ? null : _handlePayment,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2979FF), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _isCreatingBooking 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Saya Sudah Membayar', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
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
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
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
                  _startTimer();
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
    String finalImage = widget.imageUrl;
    if (finalImage.isEmpty || finalImage.contains('majadigi.go.id')) {
      if (widget.category == 'Asrama') {
        finalImage = 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&q=80&w=400';
      } else if (widget.category == 'Masjid') {
        finalImage = 'https://images.unsplash.com/photo-1564683214965-3619addd900d?auto=format&fit=crop&q=80&w=400';
      } else {
        finalImage = 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&q=80&w=400';
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200, 
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(finalImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(widget.category, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {IconData? icon, bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
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
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value, 
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
              textAlign: TextAlign.right,
            ),
          ),
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

  int _getSubtotal() {
    return _basePrice + _getTambahanCost();
  }

  int _getTax() {
    int subtotal = _getSubtotal();
    return (subtotal * 0.11).round();
  }

  int _calculateTotal() {
    return _getSubtotal() + _getTax();
  }
}
