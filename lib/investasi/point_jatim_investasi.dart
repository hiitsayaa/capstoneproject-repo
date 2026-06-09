import 'package:flutter/material.dart';
import 'package:flutter_application_1/investasi/point_jatim_detail.dart';
import 'package:flutter_application_1/investasi/services/point_jatim_service.dart';

class InvestProject {
  final String id;
  final String name;
  final String location;
  final String sektor;
  final double nilaiInvestasi;
  final double irr;
  final double npv;
  final String paybackPeriod;
  final String status;
  final String description;
  final String imagePath; 

  InvestProject({
    required this.id,
    required this.name,
    required this.location,
    required this.sektor,
    required this.nilaiInvestasi,
    required this.irr,
    required this.npv,
    required this.paybackPeriod,
    required this.status,
    required this.description,
    required this.imagePath,
  });

  factory InvestProject.fromJson(Map<String, dynamic> json) {
    return InvestProject(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Tanpa Nama',
      location: json['location']?.toString() ?? '-',
      sektor: json['sector']?.toString() ?? 'Umum',
      nilaiInvestasi: (json['investment_value'] as num?)?.toDouble() ?? 0.0,
      irr: (json['irr'] as num?)?.toDouble() ?? 0.0,
      npv: (json['npv'] as num?)?.toDouble() ?? 0.0,
      paybackPeriod: json['payback_period']?.toString() ?? '-',
      status: json['status']?.toString() ?? 'Unknown',
      description: json['description']?.toString() ?? 'Deskripsi tidak tersedia.',
      imagePath: json['image_url']?.toString() ?? _getImagePathForSector(json['sector']?.toString() ?? ''),
    );
  }

  static String _getImagePathForSector(String sector) {
    // Sektor dari user:
    // Peternakan -> Lkv40bJeYxc
    // Pertanian/Agro -> PvwdlXqo85k
    // Kesehatan -> J0benOYAPbw
    // Pariwisata -> dSk8V5GBnmE
    final s = sector.toLowerCase();
    if (s.contains('ternak')) {
      return 'https://unsplash.com/photos/Lkv40bJeYxc/download?force=true&w=800';
    } else if (s.contains('tani') || s.contains('agro')) {
      return 'https://unsplash.com/photos/PvwdlXqo85k/download?force=true&w=800';
    } else if (s.contains('sehat')) {
      return 'https://unsplash.com/photos/J0benOYAPbw/download?force=true&w=800';
    } else if (s.contains('wisata')) {
      return 'https://unsplash.com/photos/dSk8V5GBnmE/download?force=true&w=800';
    }
    return 'https://picsum.photos/seed/${sector.replaceAll(' ', '')}/400/300';
  }

  String get nilaiInvestasiStr {
    if (nilaiInvestasi >= 1000000000000) {
      double val = nilaiInvestasi / 1000000000000;
      return 'Rp ${val == val.toInt() ? val.toInt() : val.toStringAsFixed(2)} Triliun';
    } else if (nilaiInvestasi >= 1000000000) {
      double val = nilaiInvestasi / 1000000000;
      return 'Rp ${val == val.toInt() ? val.toInt() : val.toStringAsFixed(2)} Miliar';
    } else if (nilaiInvestasi >= 1000000) {
      double val = nilaiInvestasi / 1000000;
      return 'Rp ${val == val.toInt() ? val.toInt() : val.toStringAsFixed(2)} Juta';
    }
    return 'Rp ${nilaiInvestasi.toInt()}';
  }

  String get npvStr {
    if (npv >= 1000000000000) {
      double val = npv / 1000000000000;
      return 'Rp ${val == val.toInt() ? val.toInt() : val.toStringAsFixed(2)}T';
    } else if (npv >= 1000000000) {
      double val = npv / 1000000000;
      return 'Rp ${val == val.toInt() ? val.toInt() : val.toStringAsFixed(2)}M';
    }
    return 'Rp ${npv.toInt()}';
  }

  String get irrStr => '${irr == irr.toInt() ? irr.toInt() : irr.toStringAsFixed(2)}%';
}

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

  final TextEditingController _searchController = TextEditingController();

  List<InvestProject> _allProjects = [];
  List<InvestProject> _filteredProjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProjects() async {
    setState(() => _isLoading = true);
    final data = await PointJatimService.getProjects();
    if (mounted) {
      setState(() {
        _allProjects = data.map((e) => InvestProject.fromJson(e)).toList();
        _applyFilters();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    
    _filteredProjects = _allProjects.where((p) {
      // Sektor filter
      if (_selectedSektor != 'Semua' && p.sektor != _selectedSektor) return false;
      
      // Lokasi filter
      if (_selectedLokasi != null && p.location != _selectedLokasi) return false;

      // Range filters
      final nilaiMiliar = p.nilaiInvestasi / 1000000000;
      if (nilaiMiliar < _nilaiInvestasiValues.start || nilaiMiliar > _nilaiInvestasiValues.end) return false;

      if (p.irr < _irrValues.start || p.irr > _irrValues.end) return false;

      final npvMiliar = p.npv / 1000000000;
      if (npvMiliar < _npvValues.start || npvMiliar > _npvValues.end) return false;

      // Payback period
      // parse numeric from string, e.g. "5 tahun" -> 5
      final match = RegExp(r'\d+').firstMatch(p.paybackPeriod);
      if (match != null) {
        final val = double.tryParse(match.group(0) ?? '0') ?? 0;
        if (val < _paybackValues.start || val > _paybackValues.end) return false;
      }

      // Search filter
      if (query.isNotEmpty) {
        if (!p.name.toLowerCase().contains(query) && 
            !p.location.toLowerCase().contains(query) &&
            !p.sektor.toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();

    // Sort
    _filteredProjects.sort((a, b) {
      if (_sortBy == 'IRR') {
        return b.irr.compareTo(a.irr);
      } else if (_sortBy == 'NPV') {
        return b.npv.compareTo(a.npv);
      } else if (_sortBy == 'Payback Period') {
        // Asumsi string PP adalah "X tahun" sehingga kita ambil angka depannya saja. Karena sulit membandingkan string secara umum, fallback ke IRR jika format bukan angka simple.
        // Atau asumsikan string number bisa diparse jika ambil karakter pertama.
        return a.paybackPeriod.compareTo(b.paybackPeriod); 
      }
      return 0;
    });

    if (mounted) {
      setState(() {});
    }
  }

  RangeValues _nilaiInvestasiValues = const RangeValues(0, 500); // 0 to 500 Miliar
  RangeValues _irrValues = const RangeValues(0, 50); // 0 to 50%
  RangeValues _npvValues = const RangeValues(0, 500); // 0 to 500 Miliar
  RangeValues _paybackValues = const RangeValues(0, 20); // 0 to 20 years
  String? _selectedLokasi;

  void _showFilterModal() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _FilterModalContent(
          initialSektor: _selectedSektor,
          initialLokasi: _selectedLokasi,
          initialNilaiInvestasi: _nilaiInvestasiValues,
          initialIrr: _irrValues,
          initialNpv: _npvValues,
          initialPayback: _paybackValues,
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedSektor = result['sektor'];
        _selectedLokasi = result['lokasi'];
        _nilaiInvestasiValues = result['nilaiInvestasi'];
        _irrValues = result['irr'];
        _npvValues = result['npv'];
        _paybackValues = result['payback'];
        _applyFilters();
      });
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
                        controller: _searchController,
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
                        onTap: () {
                          setState(() {
                            _selectedSektor = item;
                            _applyFilters();
                          });
                        },
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
                          onTap: () {
                            setState(() {
                              _sortBy = item;
                              _applyFilters();
                            });
                          },
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
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2979FF)))
                : _filteredProjects.isEmpty
                    ? const Center(child: Text('Tidak ada proyek ditemukan', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF9CA3AF))))
                    : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65, // Adjust to fit content
              ),
              itemCount: _filteredProjects.length,
              itemBuilder: (context, index) {
                final project = _filteredProjects[index];
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
                        // Image
                        Container(
                          height: 100,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: project.imagePath.startsWith('http')
                              ? Image.network(
                                  project.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image, color: Color(0xFF9CA3AF), size: 32)),
                                )
                              : Image.asset(
                                  project.imagePath,
                                  fit: BoxFit.cover,
                                ),
                          ),
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
  final String initialSektor;
  final String? initialLokasi;
  final RangeValues initialNilaiInvestasi;
  final RangeValues initialIrr;
  final RangeValues initialNpv;
  final RangeValues initialPayback;

  const _FilterModalContent({
    required this.initialSektor,
    this.initialLokasi,
    required this.initialNilaiInvestasi,
    required this.initialIrr,
    required this.initialNpv,
    required this.initialPayback,
  });

  @override
  State<_FilterModalContent> createState() => _FilterModalContentState();
}

class _FilterModalContentState extends State<_FilterModalContent> {
  final List<String> _sektorList = ['Semua', 'Peternakan', 'Industri', 'Kesehatan', 'Pariwisata', 'Pertanian'];
  late String _selectedSektor;
  late String? _selectedLokasi;
  late RangeValues _nilaiInvestasiValues;
  late RangeValues _irrValues;
  late RangeValues _npvValues;
  late RangeValues _paybackValues;

  @override
  void initState() {
    super.initState();
    _selectedSektor = widget.initialSektor;
    _selectedLokasi = widget.initialLokasi;
    _nilaiInvestasiValues = widget.initialNilaiInvestasi;
    _irrValues = widget.initialIrr;
    _npvValues = widget.initialNpv;
    _paybackValues = widget.initialPayback;
  }

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
                  _buildSliderLabel('Nilai Investasi', 'Rp ${_nilaiInvestasiValues.start.toInt()} M', 'Rp ${_nilaiInvestasiValues.end.toInt()} M+'),
                  RangeSlider(
                    values: _nilaiInvestasiValues,
                    min: 0,
                    max: 500,
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
                  _buildSliderLabel('NPV', 'Rp ${_npvValues.start.toInt()} M', 'Rp ${_npvValues.end.toInt()} M+'),
                  RangeSlider(
                    values: _npvValues,
                    min: 0,
                    max: 500,
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
                    max: 20,
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
                        _nilaiInvestasiValues = const RangeValues(0, 500);
                        _irrValues = const RangeValues(0, 50);
                        _npvValues = const RangeValues(0, 500);
                        _paybackValues = const RangeValues(0, 20);
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
                    onPressed: () {
                      Navigator.pop(context, {
                        'sektor': _selectedSektor,
                        'lokasi': _selectedLokasi,
                        'nilaiInvestasi': _nilaiInvestasiValues,
                        'irr': _irrValues,
                        'npv': _npvValues,
                        'payback': _paybackValues,
                      });
                    },
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
