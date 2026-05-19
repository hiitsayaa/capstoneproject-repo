import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pembayaran_pkb.dart';

class CekPajakLainPage extends StatefulWidget {
  const CekPajakLainPage({super.key});

  @override
  State<CekPajakLainPage> createState() => _CekPajakLainPageState();
}

class _CekPajakLainPageState extends State<CekPajakLainPage> {
  int _step = 0; // 0: Plat Nomor, 1: NIK & No Rangka, 2: Hasil Info
  
  String _selectedPlateColor = 'Hitam/Putih';
  final _platKodeWilayahController = TextEditingController();
  final _platAngkaController = TextEditingController();
  final _platSeriController = TextEditingController();
  
  final _nikController = TextEditingController();
  final _rangkaController = TextEditingController();

  @override
  void dispose() {
    _platKodeWilayahController.dispose();
    _platAngkaController.dispose();
    _platSeriController.dispose();
    _nikController.dispose();
    _rangkaController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      // Step 2 is the detail, next is Pembayaran
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PembayaranPkbPage()),
      );
    }
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
          'Cek Pajak Kendaraan Lain',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: _buildBody(),
      ),
      bottomNavigationBar: _step == 2 ? null : Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: _nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2979FF),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            _step == 0 ? 'Lihat Info' : 'Lanjutkan',
            style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_step == 0) return _buildStep0();
    if (_step == 1) return _buildStep1();
    return _buildStep2();
  }

  // ─────────────────────────────────────────────
  // STEP 0: PLAT NOMOR
  // ─────────────────────────────────────────────
  Widget _buildStep0() {
    Color platBgColor;
    Color platTextColor;
    
    switch (_selectedPlateColor) {
      case 'Hitam/Putih':
        platBgColor = Colors.black;
        platTextColor = Colors.white;
        break;
      case 'Merah':
        platBgColor = const Color(0xFFE53935);
        platTextColor = Colors.white;
        break;
      case 'Kuning':
        platBgColor = const Color(0xFFFFB300);
        platTextColor = Colors.black;
        break;
      default:
        platBgColor = Colors.black;
        platTextColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Placeholder for car illustration
          Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_car, size: 80, color: Color(0xFF2979FF)),
          ),
          const SizedBox(height: 40),
          
          const Text(
            'Pilih warna plat, lalu masukkan nomor plat kendaraan bermotor Anda:',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 24),

          // Color selector chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPlateColorChip('Hitam/Putih'),
              const SizedBox(width: 8),
              _buildPlateColorChip('Merah'),
              const SizedBox(width: 8),
              _buildPlateColorChip('Kuning'),
            ],
          ),
          const SizedBox(height: 32),

          // Plate input display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: platBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildPlateInput(_platKodeWilayahController, 'XX', platTextColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: _buildPlateInput(_platAngkaController, 'XXXX', platTextColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: _buildPlateInput(_platSeriController, 'XXX', platTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlateColorChip(String label) {
    final isSelected = _selectedPlateColor == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlateColor = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2979FF) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(Icons.check_circle, color: Colors.white, size: 14),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPlateInput(TextEditingController controller, String hint, Color textColor) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      textCapitalization: TextCapitalization.characters,
      style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
        border: InputBorder.none,
        isDense: true,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STEP 1: NIK & NOMOR RANGKA
  // ─────────────────────────────────────────────
  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Masukkan NIK dan No. Rangka',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 24),
          const Text('NIK', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280))),
          const SizedBox(height: 8),
          TextField(
            controller: _nikController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Masukkan NIK',
              hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2979FF))),
              filled: true, fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text('5 Digit Terakhir Nomor Rangka', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280))),
          const SizedBox(height: 8),
          TextField(
            controller: _rangkaController,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Masukkan 5 Digit Terakhir Nomor Rangka',
              hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2979FF))),
              filled: true, fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STEP 2: INFORMASI DETAIL
  // ─────────────────────────────────────────────
  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informasi Kendaraan Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Informasi Kendaraan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildInfoPair('Merk', 'Toyota Innova')),
                    Expanded(child: _buildInfoPair('Model', 'V 2.4 A/T')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildInfoPair('No. Polisi', 'N 1 AB')),
                    Expanded(child: _buildInfoPair('Warna', 'BLACK')),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoPair('Tahun Pembuatan', '2023'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Informasi PKB dan PNBP Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Informasi PKB dan PNBP', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildInfoPair('Masa Berlaku Pajak', '15 Juli 2026 - 15 Juli 2027')),
                    Expanded(child: _buildInfoPair('Tgl. STNK', '14 Juli 2029')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildInfoPair('Wilayah', 'MALANG')),
                    Expanded(child: _buildInfoPair('Tgl. Proses', '1 April 2026 17.31.26')),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoPair('Milik ke', '2'),
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
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Informasi Biaya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text('Detail', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF2979FF))),
                          Icon(Icons.chevron_right, size: 16, color: Color(0xFF2979FF)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                    Row(
                      children: const [
                        Text('Rp. ', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
                        Text('1.069.100', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2979FF),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Bayar Pajak Kendaraan', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 32),
        ],
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
}
