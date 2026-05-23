import 'package:flutter/material.dart';
import 'sapa_bansos_penerima.dart';

class SapaBansosProgramDetailPage extends StatelessWidget {
  final ProgramBansosData program;

  const SapaBansosProgramDetailPage({
    super.key,
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          program.nama,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
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
              // Header Icon & Title
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: program.color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(program.icon, color: program.color, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      program.nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Deskripsi
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                program.deskripsi,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Total Dana
              const Text(
                'Total Dana',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Rp 27.000.000.000',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),

              // Sudah Tersalur
              const Text(
                'Sudah Tersalur',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Rp 26.727.300.000 ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const Text(
                    '(98,99%)',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Rekapitulasi Penyaluran
              const Text(
                'Rekapitulasi Penyaluran',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: const Row(
                        children: [
                          Expanded(flex: 2, child: Text('Kabupaten/Kota', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                          Expanded(flex: 1, child: Text('Kuota', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                          Expanded(flex: 2, child: Text('Dana', textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                        ],
                      ),
                    ),
                    _buildTableRow('Kota Batu', '332', 'Rp166.000.000'),
                    _buildTableRow('Kota Malang', '332', 'Rp166.000.000'),
                    _buildTableRow('Kota Pasuruan', '332', 'Rp166.000.000'),
                    _buildTableRow('Kota Surabaya', '332', 'Rp166.000.000'),
                    _buildTableRow('Kota Mojokerto', '332', 'Rp166.000.000'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Analisis Finansial
              const Text(
                'Analisis Finansial',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _FinansialItem(label: 'IRR', value: '19.82%'),
                    SizedBox(width: 1, height: 40, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFA5D6A7)))),
                    _FinansialItem(label: 'NPV', value: '7,85 M'),
                    SizedBox(width: 1, height: 40, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFA5D6A7)))),
                    _FinansialItem(label: 'Payback Period', value: '5.5 Tahun'),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(String kota, String kuota, String dana) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(kota, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF1A1A1A)))),
          Expanded(flex: 1, child: Text(kuota, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF1A1A1A)))),
          Expanded(flex: 2, child: Text(dana, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF1A1A1A)))),
        ],
      ),
    );
  }
}

class _FinansialItem extends StatelessWidget {
  final String label;
  final String value;

  const _FinansialItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            color: Color(0xFF43A047),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
      ],
    );
  }
}
