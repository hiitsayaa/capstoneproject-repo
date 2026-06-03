import 'package:flutter/material.dart';
import 'package:flutter_application_1/pajak/hasil_njkb.dart';

class InfoNjkbPage extends StatefulWidget {
  const InfoNjkbPage({super.key});

  @override
  State<InfoNjkbPage> createState() => _InfoNjkbPageState();
}

class _InfoNjkbPageState extends State<InfoNjkbPage> {
  String? _selectedJenis;
  String? _selectedModel;
  String? _selectedMerk;
  String? _selectedTipe;
  String? _selectedTahun;

  final List<String> _jenisList = [
    'MOBIL',
    'SEPEDA MOTOR'
  ];

  final List<String> _modelList = [
    'MINIBUS',
    'SUV',
    'PICK UP',
    'SEPEDA MOTOR'
  ];

  final List<String> _merkList = [
    'Toyota',
    'Honda',
    'Daihatsu',
    'Yamaha',
    'Suzuki',
    'Mazda'
  ];

  final List<String> _tipeList = [
    'Avanza 1.3 G',
    'Innova Zenix G',
    'Vario 160 CBS',
    'Brio Satya E',
    'Terios R',
    'NMAX Connected',
    'Carry Pick Up',
    'CX-3 Touring'
  ];

  final List<String> _tahunList = [
    '2019', '2020', '2021', '2022', '2023', '2024'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Informasi NJKB',
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
            _buildDropdownField('Jenis Kendaraan', 'Pilih Jenis Kendaraan', _jenisList, _selectedJenis, (val) => setState(() => _selectedJenis = val)),
            const SizedBox(height: 20),
            _buildDropdownField('Model Kendaraan', 'Pilih Model Kendaraan', _modelList, _selectedModel, (val) => setState(() => _selectedModel = val)),
            const SizedBox(height: 20),
            _buildDropdownField('Merk Kendaraan', 'Pilih Merk Kendaraan', _merkList, _selectedMerk, (val) => setState(() => _selectedMerk = val)),
            const SizedBox(height: 20),
            _buildDropdownField('Tipe Kendaraan', 'Pilih Tipe Kendaraan', _tipeList, _selectedTipe, (val) => setState(() => _selectedTipe = val)),
            const SizedBox(height: 20),
            _buildDropdownField('Tahun Kendaraan', 'Pilih Tahun Kendaraan', _tahunList, _selectedTahun, (val) => setState(() => _selectedTahun = val)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => HasilNjkbPage(
                    merk: _selectedMerk,
                    tipe: _selectedTipe,
                    tahun: _selectedTahun,
                    model: _selectedModel,
                  )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Cari', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String hint, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13)),
            );
          }).toList(),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFADB5BD), fontFamily: 'Poppins', fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          ),
          dropdownColor: Colors.white,
          isExpanded: true, // Important to prevent overflow for long text
        ),
      ],
    );
  }
}
