import 'package:flutter/material.dart';
import 'hasil_njkb.dart';

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
    'ALAT BERAT / ALAT BESAR',
    'BLIND VAN',
    'BUS',
    'JEEP',
    'KENDARAAN BERMOTOR AIR',
    'LIGHT TRUCK',
    'MICROBUS',
    'MINIBUS',
    'MOBIL R3',
    'PICKUP',
    'SEDAN',
    'SEPEDA MOTOR R2',
    'SEPEDA MOTOR R3',
    'TRUCK'
  ];

  final List<String> _modelList = [
    'AMBULANCE',
    'B E M O',
    'C O M B I',
    'CARAVAN',
    'CEL WAGON',
    'DIRECT FINDER MOBILE',
    'M U KESEHATAN',
    'MIKROLET',
    'MINIBUS',
    'MINIBUS LISTRIK',
    'MOB KAS KELILING',
    'MOBIL JENASAH',
    'MOBIL PAJAK KLLG',
    'MOBIL PATROLI'
  ];

  final List<String> _merkList = [
    'AUDI',
    'AUSTIN',
    'BAIC',
    'BAJAJ',
    'BEIJING',
    'BIMANTARA',
    'BMW',
    'CADILLAC',
    'CHANGAN',
    'CHERY',
    'CHEVROLET',
    'CHRYSLER',
    'CITROEN',
    'COMMER'
  ];

  final List<String> _tipeList = [
    'AVEO 1.4 LS (4X2) MT',
    'AVEO 1.4 LT AT',
    'AVEO 1.4 LT MT',
    'AVEO 1.5 L AT',
    'AVEO 1.5 L MT',
    'AVEO 1.6 LTZ AT',
    'BLAZER 01 DOHC',
    'BLAZER MONTERA 01 SOHC',
    'CAPTIVA 2.0 SOHC AT',
    'CAPTIVA 2.0 SOHC AWD AT',
    'CAPTIVA 2.0L AT',
    'CAPTIVA 2.0L AT FL',
    'CAPTIVA 2.0L AWD AT FL',
    'CAPTIVA 2.0L AWD AT L'
  ];

  final List<String> _tahunList = [
    '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018', '2019', '2020', '2021', '2022', '2023', '2024'
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
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HasilNjkbPage()));
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
