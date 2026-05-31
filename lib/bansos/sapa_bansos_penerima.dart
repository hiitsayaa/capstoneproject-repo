import 'package:flutter/material.dart';
import 'package:flutter_application_1/bansos/sapa_bansos_hasil.dart';
import 'package:flutter_application_1/bansos/sapa_bansos_program_detail.dart';

class ProgramBansosData {
  final String nama;
  final String deskripsi;
  final String iconPath; // We'll just use Icons since we don't have assets
  final IconData icon;
  final Color color;

  const ProgramBansosData({
    required this.nama,
    required this.deskripsi,
    required this.iconPath,
    required this.icon,
    required this.color,
  });
}

const List<ProgramBansosData> programBansosList = [
  ProgramBansosData(
    nama: 'Program Keluarga Harapan Plus',
    deskripsi: 'Meningkatkan taraf hidup dan kesejahteraan bagi KPM (Lanjut Usia) melalui pemanfaatan bantuan sosial berupa uang yang disalurkan secara non tunai.',
    iconPath: 'assets/pkh_plus.png',
    icon: Icons.family_restroom,
    color: Color(0xFF00ACC1),
  ),
  ProgramBansosData(
    nama: 'Asistensi Sosial Penyandang Disabilitas',
    deskripsi: 'Bantuan uang tunai bagi penyandang disabilitas berat untuk kebutuhan dasar hidup.',
    iconPath: 'assets/aspd.png',
    icon: Icons.accessible,
    color: Color(0xFFFF8F00),
  ),
  ProgramBansosData(
    nama: 'Keluarga Penerima Manfaat Jawa Timur Wani Sejahtera',
    deskripsi: 'Bantuan uang tunai (cash transfer) untuk tambahan modal usaha bagi kelompok rentan.',
    iconPath: 'assets/kpm.png',
    icon: Icons.storefront,
    color: Color(0xFFE53935),
  ),
  ProgramBansosData(
    nama: 'Perempuan Tangguh Mandiri Jawa Timur Wani Sejahtera',
    deskripsi: 'Bantuan uang tunai (cash transfer) untuk pemberdayaan perempuan melalui program kewirausahaan.',
    iconPath: 'assets/ptm.png',
    icon: Icons.woman,
    color: Color(0xFF8E24AA),
  ),
  ProgramBansosData(
    nama: 'Kemiskinan Ekstrem',
    deskripsi: 'Bantuan tunai langsung untuk modal usaha dan meringankan beban hidup masyarakat miskin ekstrem.',
    iconPath: 'assets/ke.png',
    icon: Icons.house_siding,
    color: Color(0xFF795548),
  ),
  ProgramBansosData(
    nama: 'Bantuan Langsung Tunai Dana Bagi Hasil Cukai Hasil Tembakau',
    deskripsi: 'Bantuan tunai bagi buruh pabrik rokok yang bekerja di luar domisili KTP (lintas wilayah).',
    iconPath: 'assets/blt.png',
    icon: Icons.payments,
    color: Color(0xFF1E88E5),
  ),
  ProgramBansosData(
    nama: 'Eks Pemerlu Pelayanan Kesejahteraan Sosial Jawa Timur Wani Sejahtera',
    deskripsi: 'Dukungan modal usaha berupa uang tunai bagi kelompok rentan untuk kemandirian ekonomi.',
    iconPath: 'assets/eks.png',
    icon: Icons.handshake,
    color: Color(0xFF607D8B),
  ),
];

class SapaBansosPenerimaPage extends StatefulWidget {
  const SapaBansosPenerimaPage({super.key});

  @override
  State<SapaBansosPenerimaPage> createState() => _SapaBansosPenerimaPageState();
}

class _SapaBansosPenerimaPageState extends State<SapaBansosPenerimaPage> {
  final _nikCtrl = TextEditingController();
  bool _isNotRobot = false;

  @override
  void dispose() {
    _nikCtrl.dispose();
    super.dispose();
  }

  void _searchData() {
    if (_nikCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan NIK terlebih dahulu')),
      );
      return;
    }
    if (!_isNotRobot) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan verifikasi captcha')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SapaBansosHasilPage(nik: _nikCtrl.text),
      ),
    );
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
          'Data Penerima & Info Program Bansos',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cari Data Penerima Bansos',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Masukkan NIK untuk mengetahui informasi penerimaan secara akurat dan cepat.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nikCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Masukkan NIK',
                        hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF2979FF)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Captcha Simulation
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _isNotRobot = !_isNotRobot),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _isNotRobot ? const Color(0xFF43A047) : Colors.white,
                                border: Border.all(color: _isNotRobot ? const Color(0xFF43A047) : const Color(0xFF9CA3AF)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: _isNotRobot
                                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Saya bukan robot',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.autorenew, color: Color(0xFF9CA3AF)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _searchData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2979FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Cari Data',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Program Information Section
              const Text(
                'Informasi Program',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),

              // Expandable Cards
              ...programBansosList.map((program) => _buildProgramExpandableCard(program)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgramExpandableCard(ProgramBansosData program) {
    return _ProgramExpandableCard(program: program);
  }
}

class _ProgramExpandableCard extends StatefulWidget {
  final ProgramBansosData program;

  const _ProgramExpandableCard({required this.program});

  @override
  State<_ProgramExpandableCard> createState() => _ProgramExpandableCardState();
}

class _ProgramExpandableCardState extends State<_ProgramExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: _isExpanded
                ? const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                : BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.program.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.program.icon, color: widget.program.color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.program.nama,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.program.deskripsi,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SapaBansosProgramDetailPage(program: widget.program),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Lihat Detail',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2979FF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
