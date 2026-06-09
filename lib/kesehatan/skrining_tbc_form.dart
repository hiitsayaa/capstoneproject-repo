import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/kesehatan/skrining_tbc_hasil.dart';
import 'package:flutter_application_1/kesehatan/services/skrining_tbc_service.dart';
import 'package:flutter_application_1/auth/services/auth_service.dart';

// ─────────────────────────────────────────────
// Screening History Storage (in-memory)
// ─────────────────────────────────────────────
class SkriningRecord {
  final String namaLengkap;
  final String nik;
  final DateTime tanggal;
  final bool terindikasi;
  final String? faskes;
  final Map<String, dynamic> identitas;
  final Map<int, bool> jawaban;

  SkriningRecord({
    required this.namaLengkap,
    required this.nik,
    required this.tanggal,
    required this.terindikasi,
    this.faskes,
    required this.identitas,
    required this.jawaban,
  });
}

// Global storage for screening history
final List<SkriningRecord> riwayatSkrining = [
  SkriningRecord(
    namaLengkap: 'Ahmad Putra',
    nik: '3216540506050001',
    tanggal: DateTime(2026, 4, 12),
    terindikasi: true,
    faskes: 'Puskesmas Ciputunjo',
    identitas: {},
    jawaban: {},
  ),
  SkriningRecord(
    namaLengkap: 'Ahmad Putra',
    nik: '3216540506050001',
    tanggal: DateTime(2026, 4, 12),
    terindikasi: false,
    faskes: null,
    identitas: {},
    jawaban: {},
  ),
];

// ─────────────────────────────────────────────
// Dropdown Data
// ─────────────────────────────────────────────
const List<String> pekerjaanList = [
  'Buruh',
  'Guru/Dosen',
  'Pegawai Swasta/SUMN/BUMD',
  'Pelajar/Mahasiswa',
  'Petani/Peternak/Nelayan',
  'PNS',
  'Sopir',
  'Tenaga Profesional Medis',
  'Tenaga Profesional Non Medis',
  'TNI/Polri',
  'Wiraswasta',
  'Asisten Rumah Tangga',
  'Lainnya',
];

const List<String> kabupatenKotaList = [
  'Kab. Pacitan',
  'Kab. Ponorogo',
  'Kab. Trenggalek',
  'Kab. Tulungagung',
  'Kab. Blitar',
  'Kab. Kediri',
  'Kab. Malang',
  'Kab. Lumajang',
  'Kab. Jember',
  'Kab. Banyuwangi',
  'Kab. Bondowoso',
  'Kab. Situbondo',
  'Kab. Probolinggo',
  'Kab. Pasuruan',
  'Kab. Sidoarjo',
  'Kab. Mojokerto',
  'Kab. Jombang',
  'Kab. Nganjuk',
  'Kab. Madiun',
  'Kab. Magetan',
  'Kab. Ngawi',
  'Kab. Bojonegoro',
  'Kab. Tuban',
  'Kab. Lamongan',
  'Kab. Gresik',
  'Kab. Bangkalan',
  'Kab. Sampang',
  'Kab. Pamekasan',
  'Kab. Sumenep',
  'Kota Kediri',
  'Kota Blitar',
  'Kota Malang',
  'Kota Probolinggo',
  'Kota Pasuruan',
  'Kota Mojokerto',
  'Kota Madiun',
  'Kota Surabaya',
  'Kota Batu',
];

const Map<String, List<String>> kecamatanMap = {
  'Kota Malang': ['Blimbing', 'Klojen', 'Kedungkandang', 'Sukun', 'Lowokwaru'],
  'Kota Surabaya': ['Gubeng', 'Genteng', 'Tegalsari', 'Wonokromo', 'Rungkut', 'Sukolilo'],
  'Kab. Malang': ['Singosari', 'Lawang', 'Batu', 'Kepanjen', 'Gondanglegi'],
};

const Map<String, List<String>> kelurahanMap = {
  'Lowokwaru': ['Tunggulwulung', 'Mojolangu', 'Tlogomas', 'Dinoyo', 'Sumbersari', 'Ketawanggede', 'Jatimulyo', 'Tunjungsekar', 'Mojolangu', 'Tulusrejo', 'Lowokwaru', 'Tasik Madu'],
  'Blimbing': ['Blimbing', 'Purwodadi', 'Polowijen', 'Arjosari', 'Pandanwangi', 'Purwantoro', 'Bunulrejo', 'Kesatrian', 'Polehan', 'Jodipan', 'Ksatrian'],
  'Klojen': ['Klojen', 'Rampal Celaket', 'Samaan', 'Kiduldalem', 'Sukoharjo', 'Kasin', 'Kauman', 'Oro-oro Dowo', 'Bareng', 'Gadingkasri', 'Penanggungan'],
  'Kedungkandang': ['Kedungkandang', 'Sawojajar', 'Madyopuro', 'Lesanpuro', 'Kotalama', 'Mergosono', 'Bumiayu', 'Wonokoyo', 'Tlogowaru', 'Arjowinangun', 'Cemorokandang', 'Buring'],
  'Sukun': ['Sukun', 'Ciptomulyo', 'Gadang', 'Kebonsari', 'Bandungrejosari', 'Mulyorejo', 'Bakalan Krajan', 'Karangbesuki', 'Pisang Candi', 'Bandulan', 'Tanjungrejo'],
};

const List<String> kelompokList = ['Lainnya', 'Kader', 'Nakes'];

// ─────────────────────────────────────────────
// Screening Questions
// ─────────────────────────────────────────────
class SkriningQuestion {
  final int nomor;
  final String text;
  final String section;

  const SkriningQuestion({
    required this.nomor,
    required this.text,
    required this.section,
  });
}

const List<SkriningQuestion> skriningQuestions = [
  // Gejala Fisik dan Keluhan
  SkriningQuestion(nomor: 1, text: 'Batuk (lebih dari 2 minggu atau kurang dari 2 minggu)', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 2, text: 'Batuk berdarah', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 3, text: 'Demam', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 4, text: 'Berkeringat di malam hari tanpa aktivitas', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 5, text: 'Sesak napas', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 6, text: 'Nyeri dada', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 7, text: 'Nafsu makan menurun atau hilang selama berhari-hari', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 8, text: 'Mudah lelah atau sering merasa kecapekan tanpa aktivitas fisik yang berat', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 9, text: 'Berat badan turun drastis (bukan karena diet)', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 10, text: 'Adanya bengkak di leher, bawah rahang, bawah telinga, atau ketiak', section: 'Gejala Fisik dan Keluhan'),
  // Riwayat Kontak dan Penularan
  SkriningQuestion(nomor: 11, text: 'Apakah ada anggota keluarga serumah yang sakit TBC?', section: 'Riwayat Kontak dan Penularan'),
  SkriningQuestion(nomor: 12, text: 'Apakah pernah berada dalam satu ruangan dengan penderita TBC (kantor, kelas, asrama, dll)?', section: 'Riwayat Kontak dan Penularan'),
  SkriningQuestion(nomor: 13, text: 'Apakah pernah tinggal serumah (minimal satu malam atau sering pada siang hari) dengan penderita TBC?', section: 'Riwayat Kontak dan Penularan'),
  // Riwayat Pengobatan dan Kondisi Kesehatan
  SkriningQuestion(nomor: 14, text: 'Pernah berobat TBC dan tuntas', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 15, text: 'Pernah berobat TBC tapi tidak tuntas', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 16, text: 'Memiliki riwayat penyakit Diabetes Melitus (kencing manis)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 17, text: 'Status sebagai Orang Dengan HIV', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 18, text: 'Sedang hamil (Ibu Hamil)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 19, text: 'Memiliki kebiasaan merokok', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 20, text: 'Status usia (0-14 tahun atau lansia di atas 60 tahun)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 21, text: 'Kondisi gizi (kurang gizi atau kurus)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 22, text: 'Kurang Gizi (kurus)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 23, text: 'Lansia (diatas 60 tahun)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
];

// ─────────────────────────────────────────────
// Main Form Page
// ─────────────────────────────────────────────

class SkriningTbcFormPage extends StatefulWidget {
  const SkriningTbcFormPage({super.key});

  @override
  State<SkriningTbcFormPage> createState() => _SkriningTbcFormPageState();
}

class _SkriningTbcFormPageState extends State<SkriningTbcFormPage> {
  int _currentStep = 0; // 0=initial, 1=identity, 2=questionnaire, 3=preview

  // Step 0
  bool? _isSelf; // null=not chosen, true=Ya, false=Tidak
  final _namaCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  // For non-self (pelapor)
  final _pelaporNamaCtrl = TextEditingController();
  String? _pelaporKelompok;
  final _pelaporInstansiCtrl = TextEditingController();
  final _pelaporTeleponCtrl = TextEditingController();

  // Step 1 - Identity
  String? _jenisKelamin;
  final _teleponCtrl = TextEditingController();
  DateTime? _tanggalLahir;
  final _beratCtrl = TextEditingController();
  final _tinggiCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();
  final _pekerjaanCtrl = TextEditingController();
  final _kabupatenKotaCtrl = TextEditingController();
  final _kecamatanCtrl = TextEditingController();
  final _kelurahanCtrl = TextEditingController();

  // Step 2 - Questions
  final Map<int, bool> _jawaban = {};

  bool _isLoading = false;
  List<dynamic> _realRiwayat = [];

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  Future<void> _fetchRiwayat() async {
    final data = await SkriningTbcService.getRiwayat();
    if (mounted) {
      setState(() {
        _realRiwayat = data;
      });
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nikCtrl.dispose();
    _pelaporNamaCtrl.dispose();
    _pelaporInstansiCtrl.dispose();
    _pelaporTeleponCtrl.dispose();
    _teleponCtrl.dispose();
    _beratCtrl.dispose();
    _tinggiCtrl.dispose();
    _alamatCtrl.dispose();
    _pekerjaanCtrl.dispose();
    _kabupatenKotaCtrl.dispose();
    _kecamatanCtrl.dispose();
    _kelurahanCtrl.dispose();
    super.dispose();
  }

  // User Profile
  Future<void> _loadUserProfile() async {
    final authService = AuthService();
    final profile = await authService.getFullProfile();
    if (mounted && profile != null) {
      setState(() {
        _namaCtrl.text = profile['nama_lengkap'] ?? '';
        _nikCtrl.text = profile['nik'] ?? '';
        _teleponCtrl.text = profile['telepon'] ?? '';
        _alamatCtrl.text = profile['alamat_lengkap'] ?? '';
        
        if (profile['tanggal_lahir'] != null && profile['tanggal_lahir'].toString().isNotEmpty) {
          _tanggalLahir = DateTime.tryParse(profile['tanggal_lahir'].toString());
        }
        if (profile['jenis_kelamin'] != null && profile['jenis_kelamin'].toString().isNotEmpty) {
          _jenisKelamin = profile['jenis_kelamin'] == 'L' ? 'Laki-laki' : (profile['jenis_kelamin'] == 'P' ? 'Perempuan' : profile['jenis_kelamin']);
        }
      });
    }
  }

  int _calculateUsia() {
    if (_tanggalLahir == null) return 0;
    return DateTime.now().difference(_tanggalLahir!).inDays ~/ 365;
  }

  double _calculateBMI() {
    final berat = double.tryParse(_beratCtrl.text) ?? 0;
    final tinggiCm = double.tryParse(_tinggiCtrl.text) ?? 0;
    if (berat <= 0 || tinggiCm <= 0) return 0;
    final tinggiM = tinggiCm / 100;
    return berat / (tinggiM * tinggiM);
  }

  bool _isTerminated() {
    // Count positive symptoms (questions 1-10)
    int symptomCount = 0;
    for (int i = 1; i <= 10; i++) {
      if (_jawaban[i] == true) symptomCount++;
    }
    // Count contact history (questions 11-13)
    int contactCount = 0;
    for (int i = 11; i <= 13; i++) {
      if (_jawaban[i] == true) contactCount++;
    }
    // Count risk factors (14-23)
    int riskCount = 0;
    for (int i = 14; i <= 23; i++) {
      if (_jawaban[i] == true) riskCount++;
    }
    // Terindikasi if has symptoms + (contact or risk factors)
    return symptomCount >= 2 || (symptomCount >= 1 && contactCount >= 1) || (symptomCount >= 1 && riskCount >= 2);
  }

  void _goNext() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submitData() async {
    setState(() => _isLoading = true);
    final terindikasi = _isTerminated();
    
    final data = {
      'is_self': _isSelf,
      'nama': _isSelf == true ? _namaCtrl.text : _pelaporNamaCtrl.text,
      'nik': _isSelf == true ? _nikCtrl.text : '1234567890123456', // For demo
      'pelapor_kelompok': _pelaporKelompok,
      'pelapor_instansi': _pelaporInstansiCtrl.text,
      'pelapor_telepon': _pelaporTeleponCtrl.text,
      'jenis_kelamin': _jenisKelamin,
      'telepon': _teleponCtrl.text,
      'tanggal_lahir': _tanggalLahir?.toIso8601String(),
      'berat_badan': double.tryParse(_beratCtrl.text) ?? 0,
      'tinggi_badan': double.tryParse(_tinggiCtrl.text) ?? 0,
      'usia': _calculateUsia(),
      'alamat': _alamatCtrl.text,
      'pekerjaan': _pekerjaanCtrl.text,
      'kabupaten_kota': _kabupatenKotaCtrl.text,
      'kecamatan': _kecamatanCtrl.text,
      'kelurahan': _kelurahanCtrl.text,
      'answers': _jawaban.entries.map((e) => {
        'question_id': e.key.toString(),
        'answer': e.value
      }).toList(),
    };

    final result = await SkriningTbcService.submitScreening(data);
    setState(() => _isLoading = false);

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil menyimpan riwayat skrining.'),
          backgroundColor: Color(0xFF43A047),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SkriningTbcHasilPage(
            recordId: result['id'].toString(),
            terindikasi: terindikasi,
            namaLengkap: _isSelf == true ? _namaCtrl.text : _pelaporNamaCtrl.text,
            waktuSkrining: DateTime.now(),
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan skrining.')),
      );
    }
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Data sudah sesuai?',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Pastikan data sudah sesuai, karena data yang dikirim tidak dapat diubah.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280)),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2979FF)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Cek Ulang', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    Navigator.pop(ctx);
                    _submitData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Submit', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),

                ),
              ),
            ],
          ),
        ],
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
        title: const Text('Skrining Mandiri (E-TIBI)', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () {
            if (_currentStep > 0) {
              _goBack();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _currentStep == 3 ? const Color(0xFF2979FF) : const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Skrining Mandiri (E-TIBI)',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _currentStep == 3 ? Colors.white : const Color(0xFF2979FF),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Semakin dini gejala TBC terdeteksi, maka semakin cepat diobati dan tidak menulari keluarga yang Anda sayangi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: _currentStep == 3 ? Colors.white70 : const Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Step Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildStepContent(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep0();
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  // ─────────────────────────────────────────────
  // STEP 0: Initial Question
  // ─────────────────────────────────────────────
  Widget _buildStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Apakah anda melakukan skrining untuk diri sendiri?',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildRadioChip('Ya', _isSelf == true, () {
              setState(() => _isSelf = true);
              _loadUserProfile();
            }),
            const SizedBox(width: 12),
            _buildRadioChip('Tidak', _isSelf == false, () {
              setState(() {
                _isSelf = false;
                _namaCtrl.clear();
                _nikCtrl.clear();
                _alamatCtrl.clear();
              });
            }),
          ],
        ),
        const SizedBox(height: 24),

        if (_isSelf == true) ..._buildSelfIdentity(),
        if (_isSelf == false) ..._buildNonSelfIdentity(),

        if (_isSelf != null) ...[
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_namaCtrl.text.isNotEmpty && _nikCtrl.text.isNotEmpty) ? _goNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2979FF),
                disabledBackgroundColor: const Color(0xFF90CAF9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Selanjutnya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],

        // Riwayat Skrining Section
        const SizedBox(height: 32),
        const Text('Riwayat Skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 12),
        _buildRiwayatTable(),
      ],
    );
  }

  List<Widget> _buildSelfIdentity() {
    return [
      const Text('Masukkan Identitas Anda', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
      const SizedBox(height: 16),
      _buildTextField('Nama Lengkap', _namaCtrl, hint: 'Masukkan nama', readOnly: _isSelf == true),
      const SizedBox(height: 12),
      _buildTextField('NIK', _nikCtrl, hint: 'NIK harus 16 digit angka', keyboardType: TextInputType.number, readOnly: _isSelf == true),
    ];
  }

  List<Widget> _buildNonSelfIdentity() {
    return [
      const Text('Data Pelapor', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
      const SizedBox(height: 16),
      _buildTextField('Nama lengkap', _pelaporNamaCtrl, hint: 'Masukkan nama'),
      const SizedBox(height: 12),
      _buildDropdownField('Kelompok', _pelaporKelompok, kelompokList, (v) => setState(() => _pelaporKelompok = v)),
      const SizedBox(height: 12),
      _buildTextField('Nama Instansi', _pelaporInstansiCtrl, hint: 'Masukkan nama instansi'),
      const SizedBox(height: 12),
      _buildTextField('Nomor Telepon', _pelaporTeleponCtrl, hint: 'Masukkan nomor telepon', keyboardType: TextInputType.phone),
      const SizedBox(height: 24),
      const Text('Data yang Diskrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
      const SizedBox(height: 16),
      _buildTextField('Nama lengkap', _namaCtrl, hint: 'Masukkan nama'),
      const SizedBox(height: 12),
      _buildTextField('NIK', _nikCtrl, hint: 'NIK harus 16 digit angka', keyboardType: TextInputType.number),
    ];
  }

  // ─────────────────────────────────────────────
  // STEP 1: Detail Identity
  // ─────────────────────────────────────────────
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lengkapi Identitas Anda', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 16),

        // Jenis Kelamin
        const Text('Jenis Kelamin', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRadioChip('Laki-laki', _jenisKelamin == 'Laki-laki', () => setState(() => _jenisKelamin = 'Laki-laki')),
            const SizedBox(width: 12),
            _buildRadioChip('Perempuan', _jenisKelamin == 'Perempuan', () => setState(() => _jenisKelamin = 'Perempuan')),
          ],
        ),
        const SizedBox(height: 16),

        _buildTextField('Nomor Telepon/HP', _teleponCtrl, hint: '08xxxxxxxxxx', keyboardType: TextInputType.phone),
        const SizedBox(height: 16),

        // Tanggal Lahir
        const Text('Tanggal Lahir', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _tanggalLahir ?? DateTime(2000, 1, 1),
              firstDate: DateTime(1920),
              lastDate: DateTime.now(),
              locale: const Locale('id', 'ID'),
            );
            if (picked != null) setState(() => _tanggalLahir = picked);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _tanggalLahir != null ? DateFormat('d MMM yyyy', 'id_ID').format(_tanggalLahir!) : 'Masukkan tanggal lahir',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: _tanggalLahir != null ? const Color(0xFF1A1A1A) : const Color(0xFF9CA3AF),
                  ),
                ),
                const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        _buildTextField('Berat Badan (kg)', _beratCtrl, hint: 'Cth: 60', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField('Tinggi Badan (cm)', _tinggiCtrl, hint: 'Cth: 170', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField('Alamat Domisili', _alamatCtrl, hint: 'Cth: Jl. Merdeka No. 20'),
        const SizedBox(height: 16),

        _buildTextField('Pekerjaan', _pekerjaanCtrl, hint: 'Cth: Buruh, Wiraswasta, PNS'),
        const SizedBox(height: 16),
        _buildTextField('Kota/Kabupaten', _kabupatenKotaCtrl, hint: 'Cth: Kota Malang'),
        const SizedBox(height: 16),
        _buildTextField('Kecamatan', _kecamatanCtrl, hint: 'Cth: Lowokwaru'),
        const SizedBox(height: 16),
        _buildTextField('Desa/Kelurahan', _kelurahanCtrl, hint: 'Cth: Jatimulyo'),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _goNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2979FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Selanjutnya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _goBack,
            child: const Text('Kembali', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // STEP 2: Screening Questionnaire
  // ─────────────────────────────────────────────
  Widget _buildStep2() {
    String? currentSection;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mulai Skrining Anda', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 4),
        const Text('Jawab pertanyaan berikut dengan jujur.', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
        const SizedBox(height: 20),

        ...skriningQuestions.map((q) {
          final List<Widget> widgets = [];

          // Section header
          if (q.section != currentSection) {
            currentSection = q.section;
            widgets.add(
              Padding(
                padding: EdgeInsets.only(top: q.nomor == 1 ? 0 : 20, bottom: 12),
                child: Text(
                  q.section,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                ),
              ),
            );
          }

          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${q.nomor}. ${q.text}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xFF1A1A1A),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildYaTidakChip('Ya', _jawaban[q.nomor] == true, 
                        () => setState(() => _jawaban[q.nomor] = true)),
                      const SizedBox(width: 12),
                      _buildYaTidakChip('Tidak', _jawaban[q.nomor] == false, 
                        () => setState(() => _jawaban[q.nomor] = false)),
                    ],
                  ),
                ],
              ),
            ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          );
        }),

        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _goNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2979FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Selanjutnya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _goBack,
            child: const Text('Kembali', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // STEP 3: Preview
  // ─────────────────────────────────────────────
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pratinjau Skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 4),
        const Text('Periksa kembali data dan jawaban anda sebelum mengirim.', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
        const SizedBox(height: 20),

        // Skrining type
        _buildPreviewRow('Skrining untuk diri sendiri', _isSelf == true ? 'Ya' : 'Tidak'),
        const SizedBox(height: 16),

        // Data yang di Skrining
        const Text('Data yang di Skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const Divider(color: Color(0xFFE5E7EB)),
        _buildPreviewRow('Nama Lengkap', _namaCtrl.text),
        _buildPreviewRow('Nomor Induk Kependudukan (NIK)', _nikCtrl.text),
        _buildPreviewRow('Jenis Kelamin', _jenisKelamin ?? '-'),
        _buildPreviewRow('Nomor Telepon', _teleponCtrl.text.isEmpty ? '-' : _teleponCtrl.text),
        _buildPreviewRow('Tanggal Lahir', _tanggalLahir != null ? DateFormat('d MMM yyyy', 'id_ID').format(_tanggalLahir!) : '-'),
        _buildPreviewRow('Usia', _calculateUsia() > 0 ? '${_calculateUsia()} tahun' : '-'),
        _buildPreviewRow('Berat Badan', _beratCtrl.text.isEmpty ? '-' : '${_beratCtrl.text} kg'),
        _buildPreviewRow('Tinggi Badan', _tinggiCtrl.text.isEmpty ? '-' : '${_tinggiCtrl.text} cm'),
        _buildPreviewRow('Indeks Massa Tubuh', _calculateBMI() > 0 ? _calculateBMI().toStringAsFixed(1) : '-'),
        _buildPreviewRow('Alamat Domisili', _alamatCtrl.text.isEmpty ? '-' : _alamatCtrl.text),
        _buildPreviewRow('Pekerjaan', _pekerjaanCtrl.text.isEmpty ? '-' : _pekerjaanCtrl.text),
        _buildPreviewRow('Kota/Kabupaten', _kabupatenKotaCtrl.text.isEmpty ? '-' : _kabupatenKotaCtrl.text),
        _buildPreviewRow('Kecamatan', _kecamatanCtrl.text.isEmpty ? '-' : _kecamatanCtrl.text),
        _buildPreviewRow('Kelurahan/Desa', _kelurahanCtrl.text.isEmpty ? '-' : _kelurahanCtrl.text),

        const SizedBox(height: 20),

        // Keluhan yang Dirasakan
        const Text('Keluhan yang Dirasakan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const Divider(color: Color(0xFFE5E7EB)),
        ...skriningQuestions.where((q) => q.nomor <= 10).map(
          (q) => _buildPreviewRow(q.text, _jawaban[q.nomor] == null ? 'Belum diisi' : (_jawaban[q.nomor] == true ? 'Ya' : 'Tidak')),
        ),

        const SizedBox(height: 20),

        // Informasi Lainnya
        const Text('Informasi Lainnya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const Divider(color: Color(0xFFE5E7EB)),
        ...skriningQuestions.where((q) => q.nomor > 10).map(
          (q) => _buildPreviewRow(q.text, _jawaban[q.nomor] == null ? 'Belum diisi' : (_jawaban[q.nomor] == true ? 'Ya' : 'Tidak')),
        ),

        const SizedBox(height: 24),

        // Submit
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showConfirmDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2979FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Submit Data', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _goBack,
            child: const Text('Edit', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Shared Widgets
  // ─────────────────────────────────────────────

  Widget _buildRadioChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2979FF) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF2979FF) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYaTidakChip(String label, bool isSelected, VoidCallback? onTap) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2979FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2979FF) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 14,
              color: !enabled
                  ? const Color(0xFFBDBDBD)
                  : isSelected
                      ? Colors.white
                      : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: !enabled
                    ? const Color(0xFFBDBDBD)
                    : isSelected
                        ? Colors.white
                        : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint, TextInputType? keyboardType, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2979FF))),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text('Pilih $label', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF))),
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF1A1A1A)),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
          ),
          const Text(' : ', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: value == 'Ya'
                    ? const Color(0xFF43A047)
                    : value == 'Tidak'
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatTable() {
    if (_realRiwayat.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Center(
          child: Text('Belum ada riwayat skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF9CA3AF))),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Table Header
            Container(
              color: const Color(0xFFF9FAFB),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: const Row(
                children: [
                  Expanded(flex: 2, child: Text('Tanggal Skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                  Expanded(flex: 2, child: Text('Hasil Skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                  Expanded(flex: 2, child: Text('Faskes', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                ],
              ),
            ),
            ..._realRiwayat.take(5).map((r) {
              final isTerindikasi = r['hasil'] == 'Terindikasi TBC';
              final tanggal = r['submitted_at'] != null ? DateTime.parse(r['submitted_at']) : DateTime.now();
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SkriningTbcHasilPage(
                        recordId: r['id']?.toString(),
                        terindikasi: isTerindikasi,
                        namaLengkap: r['nama']?.toString() ?? 'Pengguna',
                        waktuSkrining: tanggal,
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          DateFormat('dd MMMM yyyy', 'id_ID').format(tanggal),
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF1A1A1A)),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isTerindikasi ? const Color(0xFFFEE2E2) : const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isTerindikasi ? 'Terindikasi TBC' : 'Tidak Terindikasi TBC',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: isTerindikasi ? const Color(0xFFEF4444) : const Color(0xFF43A047),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          r['faskes_name'] ?? '-',
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Searchable List Bottom Sheet
// ─────────────────────────────────────────────
