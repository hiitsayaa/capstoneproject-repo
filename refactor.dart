import 'dart:io';

void main() async {
  final Map<String, String> fileMap = {
    // auth
    'login.dart': 'auth',
    'register.dart': 'auth',
    'register_step2.dart': 'auth',
    'lupa_sandi.dart': 'auth',
    'verifikasi_email.dart': 'auth',
    // account
    'account.dart': 'account',
    'account_visitor.dart': 'account',
    'data_diri.dart': 'account',
    'visitor.dart': 'account',
    'visitorterdaftar.dart': 'account',
    // pajak
    'bapenda_jatim.dart': 'pajak',
    'cek_pajak_lain.dart': 'pajak',
    'detail_kendaraan.dart': 'pajak',
    'hasil_njkb.dart': 'pajak',
    'info_njkb.dart': 'pajak',
    'info_pkb.dart': 'pajak',
    'pembayaran_pkb.dart': 'pajak',
    // kesehatan
    'rsud_daha_husada.dart': 'kesehatan',
    'rsud_daha_husada_antrian.dart': 'kesehatan',
    'rsud_daha_husada_jadwal_operasi.dart': 'kesehatan',
    'rsud_daha_husada_ketersediaan_kamar.dart': 'kesehatan',
    'rsud_haji.dart': 'kesehatan',
    'rsud_haji_detail_kamar.dart': 'kesehatan',
    'rsud_haji_ketersediaan_kamar.dart': 'kesehatan',
    'rsud_karsa_husada.dart': 'kesehatan',
    'rsud_karsa_husada_detail_kamar.dart': 'kesehatan',
    'rsud_karsa_husada_ketersediaan_kamar.dart': 'kesehatan',
    'skrining_tbc.dart': 'kesehatan',
    'skrining_tbc_detail_faskes.dart': 'kesehatan',
    'skrining_tbc_form.dart': 'kesehatan',
    'skrining_tbc_hasil.dart': 'kesehatan',
    // hoaks
    'halaman_klinik_hoaks.dart': 'hoaks',
    'klinik_hoaks.dart': 'hoaks',
    'laporan_hoaks.dart': 'hoaks',
    'semua_berita_hoaks.dart': 'hoaks',
    'lacak_tiket.dart': 'hoaks',
    // bansos
    'sapa_bansos.dart': 'bansos',
    'sapa_bansos_ajukan.dart': 'bansos',
    'sapa_bansos_hasil.dart': 'bansos',
    'sapa_bansos_penerima.dart': 'bansos',
    'sapa_bansos_program_detail.dart': 'bansos',
    // islamic_center
    'islamic_center.dart': 'islamic_center',
    'islamic_center_booking.dart': 'islamic_center',
    'islamic_center_detail.dart': 'islamic_center',
    'islamic_center_form.dart': 'islamic_center',
    'islamic_center_list.dart': 'islamic_center',
    // darurat
    'nomor_darurat.dart': 'darurat',
    'nomor_darurat_detail.dart': 'darurat',
    'nomor_darurat_kontak.dart': 'darurat',
    'nomor_darurat_wilayah.dart': 'darurat',
    // investasi
    'point_jatim.dart': 'investasi',
    'point_jatim_ajukan.dart': 'investasi',
    'point_jatim_detail.dart': 'investasi',
    'point_jatim_investasi.dart': 'investasi',
    // core
    'main.dart': 'core',
    'semua_layanan.dart': 'core',
    'kelola_favorit.dart': 'core',
    'pilih_bahasa.dart': 'core',
  };

  final libDir = Directory('lib');
  
  // Create directories
  final dirs = fileMap.values.toSet();
  for (final d in dirs) {
    final dir = Directory('lib/$d');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  // Move files
  for (final entry in fileMap.entries) {
    final file = File('lib/${entry.key}');
    if (file.existsSync()) {
      file.renameSync('lib/${entry.value}/${entry.key}');
    }
  }

  // Rewrite imports
  final allFiles = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList();
  
  for (final file in allFiles) {
    String content = file.readAsStringSync();
    bool changed = false;
    
    for (final entry in fileMap.entries) {
      final fileName = entry.key;
      final folder = entry.value;
      
      // Look for import 'fileName';
      final regex1 = RegExp('import\\s+[\'"]$fileName[\'"]\\s*;');
      if (regex1.hasMatch(content)) {
        content = content.replaceAll(regex1, "import 'package:flutter_application_1/$folder/$fileName';");
        changed = true;
      }
      
      // Also maybe they had package imports to the root
      final regex2 = RegExp('import\\s+[\'"]package:flutter_application_1/$fileName[\'"]\\s*;');
      if (regex2.hasMatch(content)) {
        content = content.replaceAll(regex2, "import 'package:flutter_application_1/$folder/$fileName';");
        changed = true;
      }
    }
    
    if (changed) {
      file.writeAsStringSync(content);
    }
  }
  
  print('Refactoring complete.');
}
