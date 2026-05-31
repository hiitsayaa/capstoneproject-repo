import 'package:flutter/material.dart';
import 'package:flutter_application_1/investasi/point_jatim_detail.dart';

class InvestProject {
  final String id;
  final String name;
  final String location;
  final String sektor;
  final String nilaiInvestasiStr; // e.g., "Rp 15,00 Miliar (5,5 Th)"
  final String irrStr; // e.g., "21,76%"
  final String npvStr; // e.g., "Rp 9,32M"
  final String imagePath; // placeholder

  InvestProject({
    required this.id,
    required this.name,
    required this.location,
    required this.sektor,
    required this.nilaiInvestasiStr,
    required this.irrStr,
    required this.npvStr,
    required this.imagePath,
  });
}

final List<InvestProject> mockProjects = [
  InvestProject(
    id: '1',
    name: 'Peternakan Sapi Perah Terintegrasi Modern',
    location: 'Pujon, Malang',
    sektor: 'Peternakan',
    nilaiInvestasiStr: 'Rp 15,00 Miliar (5,5 Th)',
    irrStr: '21,76%',
    npvStr: 'Rp 9,32M',
    imagePath: 'assets/cow.jpg',
  ),
  InvestProject(
    id: '2',
    name: 'Peternakan Sapi Perah Terintegrasi Modern',
    location: 'Pujon, Malang',
    sektor: 'Peternakan',
    nilaiInvestasiStr: 'Rp 15,00 Miliar (5,5 Th)',
    irrStr: '21,76%',
    npvStr: 'Rp 9,32M',
    imagePath: 'assets/cow.jpg',
  ),
  InvestProject(
    id: '3',
    name: 'Peternakan Sapi Perah Terintegrasi Modern',
    location: 'Pujon, Malang',
    sektor: 'Peternakan',
    nilaiInvestasiStr: 'Rp 15,00 Miliar (5,5 Th)',
    irrStr: '21,76%',
    npvStr: 'Rp 9,32M',
    imagePath: 'assets/cow.jpg',
  ),
  InvestProject(
    id: '4',
    name: 'Peternakan Sapi Perah Terintegrasi Modern',
    location: 'Pujon, Malang',
    sektor: 'Peternakan',
    nilaiInvestasiStr: 'Rp 15,00 Miliar (5,5 Th)',
    irrStr: '21,76%',
    npvStr: 'Rp 9,32M',
    imagePath: 'assets/cow.jpg',
  ),
];

class PointJatimInvestasiPage extends StatefulWidget {
  const PointJatimInvestasiPage({super.key});

  @override
  State<PointJatimInvestasiPage> createState() => _PointJatimInvestasiPageState();
}

class _PointJatimInvestasiPageState extends State<PointJatimInvestasiPage> {
  String _selectedSektor = 'Semua';
  final List<String> _sektorList = ['Semua', 'Industri', 'Kesehatan', 'Pariwisata', 'Pertanian', 'Peternakan'];

  String _sortBy = 'IRR'; // default
  final List<String> _sortOptions = ['IRR', 'NPV', 'Payback Period'];

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const _FilterModalContent();
      },
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
          'POINT JATIM',
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
      body: Column(
        children: [
          // Search & Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Cari proyek, lokasi, sektor',
                          hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: _showFilterModal,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.tune, color: Color(0xFF1A1A1A), size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Categories
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _sektorList.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final item = _sektorList[index];
                      final isSelected = item == _selectedSektor;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSektor = item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF2979FF) : Colors.white,
                            border: Border.all(color: isSelected ? const Color(0xFF2979FF) : const Color(0xFFD1D5DB)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Sort By
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text('Urut berdasarkan', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 28,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _sortOptions.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final item = _sortOptions[index];
                        final isSelected = item == _sortBy;
                        return GestureDetector(
                          onTap: () => setState(() => _sortBy = item),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
                              border: Border.all(color: isSelected ? const Color(0xFF2979FF) : const Color(0xFFD1D5DB)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  item,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected ? const Color(0xFF2979FF) : const Color(0xFF6B7280),
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_downward, size: 12, color: Color(0xFF2979FF)),
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Project List
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65, // Adjust to fit content
              ),
              itemCount: mockProjects.length,
              itemBuilder: (context, index) {
                final project = mockProjects[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PointJatimDetailPage(project: project),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Placeholder
                        Container(
                          height: 100,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: const Center(child: Icon(Icons.image, color: Color(0xFF9CA3AF), size: 32)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFF2979FF)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  project.sektor,
                                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: FontWeight.w600, color: Color(0xFF2979FF)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                project.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A), height: 1.2),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                project.location,
                                style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Color(0xFF6B7280)),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                project.nilaiInvestasiStr,
                                style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'IRR: ${project.irrStr}',
                                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'NPV: ${project.npvStr}',
                                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Filter Modal Content
// ─────────────────────────────────────────────
class _FilterModalContent extends StatefulWidget {
  const _FilterModalContent();

  @override
  State<_FilterModalContent> createState() => _FilterModalContentState();
}

class _FilterModalContentState extends State<_FilterModalContent> {
  final List<String> _sektorList = ['Semua', 'Peternakan', 'Industri', 'Kesehatan', 'Pariwisata', 'Pertanian'];
  String _selectedSektor = 'Semua';

  String? _selectedLokasi;

  RangeValues _nilaiInvestasiValues = const RangeValues(0, 100);
  RangeValues _irrValues = const RangeValues(0, 50);
  RangeValues _npvValues = const RangeValues(0, 100);
  RangeValues _paybackValues = const RangeValues(0, 10);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24), // balance
                const Text(
                  'Filter',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sektor
                  const Text('Sektor', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _sektorList.map((s) {
                      final isSelected = s == _selectedSektor;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSektor = s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: isSelected ? const Color(0xFF2979FF) : const Color(0xFFD1D5DB)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: isSelected ? const Color(0xFF2979FF) : const Color(0xFF1A1A1A)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Lokasi
                  const Text('Lokasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedLokasi,
                    hint: const Text('Pilih kab/kota', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF9CA3AF))),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                    ),
                    items: ['Kab. Malang', 'Kota Surabaya', 'Kota Batu'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                      );
                    }).toList(),
                    onChanged: (newValue) => setState(() => _selectedLokasi = newValue),
                  ),
                  const SizedBox(height: 24),

                  // Nilai Investasi Range
                  _buildSliderLabel('Nilai Investasi', 'Rp ${_nilaiInvestasiValues.start.toInt()}', 'Rp ${_nilaiInvestasiValues.end.toInt()} M+'),
                  RangeSlider(
                    values: _nilaiInvestasiValues,
                    min: 0,
                    max: 100,
                    activeColor: const Color(0xFF2979FF),
                    inactiveColor: const Color(0xFFE5E7EB),
                    onChanged: (values) => setState(() => _nilaiInvestasiValues = values),
                  ),
                  const SizedBox(height: 16),

                  // IRR Range
                  _buildSliderLabel('IRR (%)', '${_irrValues.start.toInt()}%', '+${_irrValues.end.toInt()}%'),
                  RangeSlider(
                    values: _irrValues,
                    min: 0,
                    max: 50,
                    activeColor: const Color(0xFF2979FF),
                    inactiveColor: const Color(0xFFE5E7EB),
                    onChanged: (values) => setState(() => _irrValues = values),
                  ),
                  const SizedBox(height: 16),

                  // NPV Range
                  _buildSliderLabel('NPV (Rp)', 'Rp ${_npvValues.start.toInt()}', 'Rp ${_npvValues.end.toInt()} M+'),
                  RangeSlider(
                    values: _npvValues,
                    min: 0,
                    max: 100,
                    activeColor: const Color(0xFF2979FF),
                    inactiveColor: const Color(0xFFE5E7EB),
                    onChanged: (values) => setState(() => _npvValues = values),
                  ),
                  const SizedBox(height: 16),

                  // Payback Range
                  _buildSliderLabel('Payback Period (Tahun)', '${_paybackValues.start.toInt()} Tahun', '${_paybackValues.end.toInt()}+ Tahun'),
                  RangeSlider(
                    values: _paybackValues,
                    min: 0,
                    max: 10,
                    activeColor: const Color(0xFF2979FF),
                    inactiveColor: const Color(0xFFE5E7EB),
                    onChanged: (values) => setState(() => _paybackValues = values),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedSektor = 'Semua';
                        _selectedLokasi = null;
                        _nilaiInvestasiValues = const RangeValues(0, 100);
                        _irrValues = const RangeValues(0, 50);
                        _npvValues = const RangeValues(0, 100);
                        _paybackValues = const RangeValues(0, 10);
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2979FF)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Reset', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2979FF))),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Terapkan Filter', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSliderLabel(String title, String left, String right) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(left, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
            Text(right, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
          ],
        ),
      ],
    );
  }
}
