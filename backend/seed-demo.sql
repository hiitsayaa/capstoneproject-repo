INSERT INTO gateway.active_features (id, feature_key, version, status, flutter_route, required_role, last_updated) VALUES
  ('00000000-0000-0000-0000-000000000101', 'bapenda', '1.0.0', 'Active', '/bapenda', 'RegisteredUser', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000102', 'rsud_daha_husada', '1.0.0', 'Active', '/rsud/daha', 'Visitor', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000103', 'rsud_karsa_husada', '1.0.0', 'Active', '/rsud/karsa', 'Visitor', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000104', 'sapa_bansos', '0.9.0', 'Maintenance', '/bansos', 'RegisteredUser', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000105', 'klinik_hoaks', '1.0.0', 'Active', '/hoaks', 'Visitor', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000106', 'nomor_darurat', '1.0.0', 'Active', '/emergency', 'Visitor', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000107', 'islamic_center', '1.0.0', 'Active', '/islamic-center', 'RegisteredUser', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000108', 'point_jatim', '1.0.0', 'Active', '/point-jatim', 'RegisteredUser', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000109', 'skrining_tbc', '1.0.0', 'Active', '/tbc-screening', 'RegisteredUser', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000110', 'info_pkb', '1.0.0', 'Active', '/bapenda/pkb/check', 'RegisteredUser', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000111', 'info_njkb', '1.0.0', 'Active', '/bapenda/njkb', 'Visitor', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000112', 'rsud_haji', '1.0.0', 'Active', '/rsud/haji', 'Visitor', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000113', 'rsud_haji_rooms', '1.0.0', 'Active', '/rsud/haji/rooms', 'Visitor', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000114', 'rsud_karsa_rooms', '1.0.0', 'Active', '/rsud/karsa/rooms', 'Visitor', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000115', 'rsud_daha_surgeries', '1.0.0', 'Active', '/rsud/daha/surgeries', 'Visitor', '2026-05-30T08:00:00+07:00'),
  ('00000000-0000-0000-0000-000000000116', 'rsud_daha_queue', '1.0.0', 'Active', '/rsud/daha/queue', 'RegisteredUser', '2026-05-30T08:00:00+07:00')
ON CONFLICT (feature_key) DO UPDATE SET
  version = EXCLUDED.version,
  status = EXCLUDED.status,
  flutter_route = EXCLUDED.flutter_route,
  required_role = EXCLUDED.required_role,
  last_updated = EXCLUDED.last_updated;

INSERT INTO auth.users (id, email, password_hash, role, created_at) VALUES
  ('10000000-0000-0000-0000-000000000001', 'demo@majadigi.go.id', '$2b$10$z5E3Si.OQRA.KsV7oZZFuOU8k.V2KbvqbfzriNQvY591VlXFqX//6', 'RegisteredUser', '2026-05-01T08:00:00+07:00'),
  ('10000000-0000-0000-0000-000000000002', 'admin@majadigi.go.id', '$2b$10$z5E3Si.OQRA.KsV7oZZFuOU8k.V2KbvqbfzriNQvY591VlXFqX//6', 'Admin', '2026-05-01T08:05:00+07:00'),
  ('10000000-0000-0000-0000-000000000003', 'sinta@majadigi.go.id', '$2b$10$z5E3Si.OQRA.KsV7oZZFuOU8k.V2KbvqbfzriNQvY591VlXFqX//6', 'RegisteredUser', '2026-05-02T09:15:00+07:00'),
  ('10000000-0000-0000-0000-000000000004', 'budi@majadigi.go.id', '$2b$10$z5E3Si.OQRA.KsV7oZZFuOU8k.V2KbvqbfzriNQvY591VlXFqX//6', 'RegisteredUser', '2026-05-02T09:30:00+07:00'),
  ('10000000-0000-0000-0000-000000000005', 'ratna@majadigi.go.id', '$2b$10$z5E3Si.OQRA.KsV7oZZFuOU8k.V2KbvqbfzriNQvY591VlXFqX//6', 'RegisteredUser', '2026-05-03T10:00:00+07:00'),
  ('10000000-0000-0000-0000-000000000006', 'visitor@majadigi.go.id', '$2b$10$z5E3Si.OQRA.KsV7oZZFuOU8k.V2KbvqbfzriNQvY591VlXFqX//6', 'Visitor', '2026-05-03T10:30:00+07:00')
ON CONFLICT (email) DO UPDATE SET
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role;

INSERT INTO auth.profiles (id, user_id, nik, kk, nama_lengkap, tempat_lahir, tanggal_lahir, jenis_kelamin, telepon, alamat_lengkap) VALUES
  ('11000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '3573010101010001', '3573010101010000', 'Warga Demo Majadigi', 'Malang', '2001-01-01', 'L', '081234567890', 'Jl. Majadigi No. 1, Kota Malang'),
  ('11000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000002', '3578010202020002', '3578010202020000', 'Admin Majadigi Jatim', 'Surabaya', '1995-02-02', 'P', '081234567891', 'Jl. Pahlawan No. 10, Surabaya'),
  ('11000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000003', '3579020303030003', '3579020303030000', 'Sinta Ayu Prameswari', 'Batu', '1998-03-03', 'P', '081234567892', 'Jl. Semeru No. 12, Batu'),
  ('11000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000004', '3515040404040004', '3515040404040000', 'Budi Santoso', 'Kediri', '1992-04-04', 'L', '081234567893', 'Jl. Dhoho No. 25, Kediri'),
  ('11000000-0000-0000-0000-000000000005', '10000000-0000-0000-0000-000000000005', '3511050505050005', '3511050505050000', 'Ratna Kusuma Dewi', 'Madiun', '1989-05-05', 'P', '081234567894', 'Jl. Merak No. 7, Madiun'),
  ('11000000-0000-0000-0000-000000000006', '10000000-0000-0000-0000-000000000006', '3525060606060006', '3525060606060000', 'Pengunjung Majadigi', 'Gresik', '2000-06-06', 'L', '081234567895', 'Jl. Veteran No. 5, Gresik')
ON CONFLICT (nik) DO UPDATE SET
  kk = EXCLUDED.kk,
  nama_lengkap = EXCLUDED.nama_lengkap,
  tempat_lahir = EXCLUDED.tempat_lahir,
  tanggal_lahir = EXCLUDED.tanggal_lahir,
  jenis_kelamin = EXCLUDED.jenis_kelamin,
  telepon = EXCLUDED.telepon,
  alamat_lengkap = EXCLUDED.alamat_lengkap;

INSERT INTO auth.favorites (id, user_id, service_key, created_at) VALUES
  ('12000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'bapenda', '2026-05-10T08:00:00+07:00'),
  ('12000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', 'rsud_daha_husada', '2026-05-10T08:01:00+07:00'),
  ('12000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000003', 'klinik_hoaks', '2026-05-11T09:00:00+07:00'),
  ('12000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000004', 'sapa_bansos', '2026-05-12T10:00:00+07:00'),
  ('12000000-0000-0000-0000-000000000005', '10000000-0000-0000-0000-000000000005', 'bapenda', '2026-05-12T10:05:00+07:00')
ON CONFLICT (user_id, service_key) DO NOTHING;

INSERT INTO bapenda.vehicles (id, nopol, nik_pemilik, merk, tipe, tahun, no_rangka, no_mesin) VALUES
  ('20000000-0000-0000-0000-000000000001', 'N1234AB', '3573010101010001', 'Toyota', 'Avanza 1.3 G', 2021, 'MHKM1BA3JMK001234', '1NRF123456'),
  ('20000000-0000-0000-0000-000000000002', 'L54SA', '3573010101010001', 'Mazda', 'CX-3 Touring', 2020, 'JM7DK2W7LK001001', 'PEVPS1001'),
  ('20000000-0000-0000-0000-000000000003', 'N3579ANA', '3579020303030003', 'Honda', 'Vario 160 CBS', 2023, 'MH1KF411XPK002002', 'KF41E2002'),
  ('20000000-0000-0000-0000-000000000004', 'AG8842BK', '3515040404040004', 'Daihatsu', 'Terios R', 2022, 'MHKX3DA4JNK003003', '2NRV3003'),
  ('20000000-0000-0000-0000-000000000005', 'AE2026MDG', '3511050505050005', 'Yamaha', 'NMAX Connected', 2024, 'MH3SG5620RK004004', 'G3L8E4004'),
  ('20000000-0000-0000-0000-000000000006', 'W7001JT', '3525060606060006', 'Suzuki', 'Carry Pick Up', 2019, 'MHYDA41T2KJ005005', 'K15B5005')
ON CONFLICT (nopol) DO UPDATE SET
  nik_pemilik = EXCLUDED.nik_pemilik,
  merk = EXCLUDED.merk,
  tipe = EXCLUDED.tipe,
  tahun = EXCLUDED.tahun,
  no_rangka = EXCLUDED.no_rangka,
  no_mesin = EXCLUDED.no_mesin;

INSERT INTO bapenda.pkb_bills (id, vehicle_id, pokok_pkb, denda_pkb, swdkllj, denda_swdkllj, status, due_date) VALUES
  ('21000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 1750000, 0, 143000, 0, 'Unpaid', '2026-12-31'),
  ('21000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', 2890000, 125000, 143000, 35000, 'Unpaid', '2026-08-25'),
  ('21000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000003', 382000, 0, 35000, 0, 'Paid', '2026-12-25'),
  ('21000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000004', 2210000, 0, 143000, 0, 'Unpaid', '2026-09-12'),
  ('21000000-0000-0000-0000-000000000005', '20000000-0000-0000-0000-000000000005', 465000, 25000, 35000, 0, 'Unpaid', '2026-07-02'),
  ('21000000-0000-0000-0000-000000000006', '20000000-0000-0000-0000-000000000006', 1265000, 0, 143000, 0, 'Paid', '2026-10-18')
ON CONFLICT (id) DO UPDATE SET
  pokok_pkb = EXCLUDED.pokok_pkb,
  denda_pkb = EXCLUDED.denda_pkb,
  swdkllj = EXCLUDED.swdkllj,
  denda_swdkllj = EXCLUDED.denda_swdkllj,
  status = EXCLUDED.status,
  due_date = EXCLUDED.due_date;

INSERT INTO bapenda.pkb_payments (id, bill_id, payment_method, va_number, amount_paid, paid_at) VALUES
  ('22000000-0000-0000-0000-000000000001', '21000000-0000-0000-0000-000000000003', 'virtual_account', '888803030003', 417000, '2026-01-05T11:30:00+07:00'),
  ('22000000-0000-0000-0000-000000000002', '21000000-0000-0000-0000-000000000006', 'qris', 'QRIS-W7001JT-2026', 1408000, '2026-02-10T14:00:00+07:00')
ON CONFLICT (id) DO UPDATE SET
  payment_method = EXCLUDED.payment_method,
  va_number = EXCLUDED.va_number,
  amount_paid = EXCLUDED.amount_paid,
  paid_at = EXCLUDED.paid_at;

INSERT INTO bapenda.njkb_data (id, merk, tipe, tahun, nilai_njkb, bobot) VALUES
  ('23000000-0000-0000-0000-000000000001', 'Toyota', 'Avanza 1.3 G', 2021, 180000000, 1.000),
  ('23000000-0000-0000-0000-000000000002', 'Toyota', 'Innova Zenix G', 2024, 395000000, 1.050),
  ('23000000-0000-0000-0000-000000000003', 'Honda', 'Vario 160 CBS', 2023, 21000000, 1.000),
  ('23000000-0000-0000-0000-000000000004', 'Honda', 'Brio Satya E', 2022, 148000000, 1.000),
  ('23000000-0000-0000-0000-000000000005', 'Daihatsu', 'Terios R', 2022, 229000000, 1.000),
  ('23000000-0000-0000-0000-000000000006', 'Yamaha', 'NMAX Connected', 2024, 32500000, 1.000),
  ('23000000-0000-0000-0000-000000000007', 'Suzuki', 'Carry Pick Up', 2019, 112000000, 1.100),
  ('23000000-0000-0000-0000-000000000008', 'Mazda', 'CX-3 Touring', 2020, 286000000, 1.000)
ON CONFLICT (id) DO UPDATE SET
  merk = EXCLUDED.merk,
  tipe = EXCLUDED.tipe,
  tahun = EXCLUDED.tahun,
  nilai_njkb = EXCLUDED.nilai_njkb,
  bobot = EXCLUDED.bobot;

INSERT INTO rsud.hospitals (id, nama_rs, alamat, tipe) VALUES
  ('30000000-0000-0000-0000-000000000001', 'RSUD Daha Husada', 'Kediri, Jawa Timur', 'B'),
  ('30000000-0000-0000-0000-000000000002', 'RSUD Karsa Husada', 'Batu, Jawa Timur', 'B'),
  ('30000000-0000-0000-0000-000000000003', 'RSUD Haji Provinsi Jawa Timur', 'Surabaya, Jawa Timur', 'B')
ON CONFLICT (id) DO UPDATE SET
  nama_rs = EXCLUDED.nama_rs,
  alamat = EXCLUDED.alamat,
  tipe = EXCLUDED.tipe;

INSERT INTO rsud.room_availability (id, hospital_id, kelas_kamar, kapasitas_total, kamar_tersedia) VALUES
  ('31000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', 'VIP', 12, 4),
  ('31000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000001', 'I', 24, 8),
  ('31000000-0000-0000-0000-000000000003', '30000000-0000-0000-0000-000000000001', 'II', 40, 13),
  ('31000000-0000-0000-0000-000000000004', '30000000-0000-0000-0000-000000000001', 'III', 64, 11),
  ('31000000-0000-0000-0000-000000000005', '30000000-0000-0000-0000-000000000002', 'VIP', 8, 2),
  ('31000000-0000-0000-0000-000000000006', '30000000-0000-0000-0000-000000000002', 'ICU', 8, 2),
  ('31000000-0000-0000-0000-000000000007', '30000000-0000-0000-0000-000000000002', 'III', 52, 17),
  ('31000000-0000-0000-0000-000000000008', '30000000-0000-0000-0000-000000000003', 'VIP', 20, 6),
  ('31000000-0000-0000-0000-000000000009', '30000000-0000-0000-0000-000000000003', 'I', 36, 10),
  ('31000000-0000-0000-0000-000000000010', '30000000-0000-0000-0000-000000000003', 'ICU', 14, 3)
ON CONFLICT (id) DO UPDATE SET
  kelas_kamar = EXCLUDED.kelas_kamar,
  kapasitas_total = EXCLUDED.kapasitas_total,
  kamar_tersedia = EXCLUDED.kamar_tersedia;

INSERT INTO rsud.queues (id, hospital_id, nik, dokter_nama, spesialisasi, tanggal_kunjungan, nomor_antrian, status) VALUES
  ('32000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', '3573010101010001', 'dr. Sekar Ayu', 'Umum', '2026-06-01', 'A-001', 'Waiting'),
  ('32000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000001', '3579020303030003', 'dr. Bagas Pratama', 'Penyakit Dalam', '2026-06-01', 'A-002', 'Call'),
  ('32000000-0000-0000-0000-000000000003', '30000000-0000-0000-0000-000000000002', '3515040404040004', 'dr. Ratih Lestari', 'Anak', '2026-06-02', 'B-001', 'Waiting'),
  ('32000000-0000-0000-0000-000000000004', '30000000-0000-0000-0000-000000000003', '3511050505050005', 'dr. Arif Nugroho', 'Jantung', '2026-06-03', 'C-001', 'Done')
ON CONFLICT (id) DO UPDATE SET
  nik = EXCLUDED.nik,
  dokter_nama = EXCLUDED.dokter_nama,
  spesialisasi = EXCLUDED.spesialisasi,
  tanggal_kunjungan = EXCLUDED.tanggal_kunjungan,
  nomor_antrian = EXCLUDED.nomor_antrian,
  status = EXCLUDED.status;

INSERT INTO rsud.surgeries (id, hospital_id, dokter_nama, ruangan_operasi, jadwal_mulai, estimasi_durasi, status) VALUES
  ('33000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', 'dr. Sekar Ayu', 'OK-1', '2026-06-01T08:00:00+07:00', 120, 'Scheduled'),
  ('33000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000001', 'dr. Bagas Pratama', 'OK-2', '2026-06-01T11:00:00+07:00', 90, 'Scheduled'),
  ('33000000-0000-0000-0000-000000000003', '30000000-0000-0000-0000-000000000002', 'dr. Ratih Lestari', 'OK Anak', '2026-06-02T09:30:00+07:00', 75, 'Preparation'),
  ('33000000-0000-0000-0000-000000000004', '30000000-0000-0000-0000-000000000003', 'dr. Arif Nugroho', 'OK Jantung', '2026-06-03T13:00:00+07:00', 180, 'Scheduled')
ON CONFLICT (id) DO UPDATE SET
  dokter_nama = EXCLUDED.dokter_nama,
  ruangan_operasi = EXCLUDED.ruangan_operasi,
  jadwal_mulai = EXCLUDED.jadwal_mulai,
  estimasi_durasi = EXCLUDED.estimasi_durasi,
  status = EXCLUDED.status;

INSERT INTO bansos.bansos_programs (id, nama_program, deskripsi, persyaratan_json, periode) VALUES
  ('40000000-0000-0000-0000-000000000001', 'Program Keluarga Harapan', 'Bantuan sosial bersyarat untuk keluarga rentan.', '{"max_penghasilan_bulanan":2500000,"min_jumlah_tanggungan":1}', '2026'),
  ('40000000-0000-0000-0000-000000000002', 'Bantuan Pangan Non Tunai', 'Dukungan pangan bulanan untuk keluarga penerima manfaat.', '{"max_penghasilan_bulanan":2000000}', '2026'),
  ('40000000-0000-0000-0000-000000000003', 'BLT Daerah Jatim', 'Bantuan tunai untuk warga terdampak tekanan ekonomi.', '{"max_penghasilan_bulanan":1800000}', '2026-Q2'),
  ('40000000-0000-0000-0000-000000000004', 'Bantuan Disabilitas Produktif', 'Dukungan modal dan pendampingan untuk warga disabilitas produktif.', '{"requires_disability_card":true}', '2026')
ON CONFLICT (id) DO UPDATE SET
  nama_program = EXCLUDED.nama_program,
  deskripsi = EXCLUDED.deskripsi,
  persyaratan_json = EXCLUDED.persyaratan_json,
  periode = EXCLUDED.periode;

INSERT INTO bansos.applications (id, program_id, nik, nama_ibu_kandung, penghasilan_bulanan, jumlah_tanggungan, status, submitted_at) VALUES
  ('41000000-0000-0000-0000-000000000001', '40000000-0000-0000-0000-000000000001', '3573010101010001', 'Siti Aminah', 1500000, 2, 'Submitted', '2026-05-20T08:30:00+07:00'),
  ('41000000-0000-0000-0000-000000000002', '40000000-0000-0000-0000-000000000002', '3579020303030003', 'Sri Wahyuni', 1750000, 1, 'Verifying', '2026-05-21T09:00:00+07:00'),
  ('41000000-0000-0000-0000-000000000003', '40000000-0000-0000-0000-000000000003', '3515040404040004', 'Endang Lestari', 1200000, 3, 'Approved', '2026-05-22T10:15:00+07:00'),
  ('41000000-0000-0000-0000-000000000004', '40000000-0000-0000-0000-000000000004', '3511050505050005', 'Murni Rahayu', 3200000, 0, 'Rejected', '2026-05-23T11:45:00+07:00')
ON CONFLICT (id) DO UPDATE SET
  program_id = EXCLUDED.program_id,
  nik = EXCLUDED.nik,
  nama_ibu_kandung = EXCLUDED.nama_ibu_kandung,
  penghasilan_bulanan = EXCLUDED.penghasilan_bulanan,
  jumlah_tanggungan = EXCLUDED.jumlah_tanggungan,
  status = EXCLUDED.status,
  submitted_at = EXCLUDED.submitted_at;

INSERT INTO bansos.documents (id, application_id, document_type, file_url) VALUES
  ('42000000-0000-0000-0000-000000000001', '41000000-0000-0000-0000-000000000001', 'KTP', 'https://cdn.majadigi.go.id/demo/bansos/ktp-demo-001.pdf'),
  ('42000000-0000-0000-0000-000000000002', '41000000-0000-0000-0000-000000000001', 'KK', 'https://cdn.majadigi.go.id/demo/bansos/kk-demo-001.pdf'),
  ('42000000-0000-0000-0000-000000000003', '41000000-0000-0000-0000-000000000002', 'Surat Keterangan Tidak Mampu', 'https://cdn.majadigi.go.id/demo/bansos/sktm-demo-002.pdf'),
  ('42000000-0000-0000-0000-000000000004', '41000000-0000-0000-0000-000000000003', 'KTP', 'https://cdn.majadigi.go.id/demo/bansos/ktp-demo-003.pdf')
ON CONFLICT (id) DO UPDATE SET
  document_type = EXCLUDED.document_type,
  file_url = EXCLUDED.file_url;

INSERT INTO hoaks.hoax_articles (id, judul, konten, kategori, status_klarifikasi, url_sumber, published_at) VALUES
  ('50000000-0000-0000-0000-000000000001', 'Klarifikasi Informasi Layanan Pajak Kendaraan', 'Informasi resmi pembayaran PKB hanya melalui kanal yang diumumkan Pemerintah Provinsi Jawa Timur.', 'Layanan Publik', 'Fakta', 'https://kominfo.jatimprov.go.id', '2026-05-30T08:00:00+07:00'),
  ('50000000-0000-0000-0000-000000000002', 'Hoaks Pesan Berantai Bantuan Sosial Instan', 'Pesan yang meminta biaya administrasi untuk pencairan bansos adalah tidak benar.', 'Bansos', 'Hoaks', 'https://kominfo.jatimprov.go.id', '2026-05-29T09:15:00+07:00'),
  ('50000000-0000-0000-0000-000000000003', 'Disinformasi Jadwal Operasi RSUD', 'Jadwal operasi pasien hanya dapat dicek melalui kanal resmi RSUD terkait.', 'Kesehatan', 'Disinformasi', 'https://kominfo.jatimprov.go.id', '2026-05-28T10:00:00+07:00'),
  ('50000000-0000-0000-0000-000000000004', 'Fakta Kanal Aduan Klinik Hoaks Jatim', 'Warga dapat mengirim laporan dugaan hoaks melalui aplikasi Majadigi atau kanal resmi Kominfo Jatim.', 'Literasi Digital', 'Fakta', 'https://kominfo.jatimprov.go.id', '2026-05-27T14:00:00+07:00')
ON CONFLICT (id) DO UPDATE SET
  judul = EXCLUDED.judul,
  konten = EXCLUDED.konten,
  kategori = EXCLUDED.kategori,
  status_klarifikasi = EXCLUDED.status_klarifikasi,
  url_sumber = EXCLUDED.url_sumber,
  published_at = EXCLUDED.published_at;

INSERT INTO hoaks.hoax_reports (id, user_id, judul_laporan, deskripsi_kejadian, url_bukti, status_laporan) VALUES
  ('51000000-0000-0000-0000-000000000001', '3573010101010001', 'Pesan WhatsApp PKB gratis', 'Ada pesan yang mengaku dari Bapenda dan menjanjikan penghapusan pajak kendaraan.', 'https://example.com/bukti/pkb-gratis', 'Investigating'),
  ('51000000-0000-0000-0000-000000000002', 'anonymous', 'Link pendaftaran bansos palsu', 'Link meminta NIK dan biaya admin untuk pencairan bantuan.', 'https://example.com/bukti/bansos-palsu', 'Pending'),
  ('51000000-0000-0000-0000-000000000003', '3515040404040004', 'Kabar antrean RSUD ditutup', 'Unggahan media sosial menyebut antrean RSUD ditutup selama sepekan.', 'https://example.com/bukti/rsud-ditutup', 'Clarified')
ON CONFLICT (id) DO UPDATE SET
  user_id = EXCLUDED.user_id,
  judul_laporan = EXCLUDED.judul_laporan,
  deskripsi_kejadian = EXCLUDED.deskripsi_kejadian,
  url_bukti = EXCLUDED.url_bukti,
  status_laporan = EXCLUDED.status_laporan;

INSERT INTO emergency.contacts (id, region, name, category, phone, address, latitude, longitude) VALUES
  ('surabaya-112', 'Kota Surabaya', 'Command Center 112 Surabaya', 'Darurat Umum', '112', 'Kota Surabaya, Jawa Timur', -7.2575000, 112.7521000),
  ('jatim-110', 'Jawa Timur', 'Kepolisian', 'Keamanan', '110', 'Jawa Timur', -7.5361000, 112.2384000),
  ('jatim-118', 'Jawa Timur', 'Ambulans PSC', 'Kesehatan', '118', 'Jawa Timur', -7.5361000, 112.2384000),
  ('malang-112', 'Kota Malang', 'Ngalam 112', 'Darurat Umum', '112', 'Kota Malang, Jawa Timur', -7.9666000, 112.6326000),
  ('kediri-113', 'Kota Kediri', 'Pemadam Kebakaran Kediri', 'Kebakaran', '113', 'Kota Kediri, Jawa Timur', -7.8480000, 112.0178000),
  ('batu-119', 'Kota Batu', 'PSC Batu Sehat', 'Kesehatan', '119', 'Kota Batu, Jawa Timur', -7.8831000, 112.5334000)
ON CONFLICT (id) DO UPDATE SET
  region = EXCLUDED.region,
  name = EXCLUDED.name,
  category = EXCLUDED.category,
  phone = EXCLUDED.phone,
  address = EXCLUDED.address,
  latitude = EXCLUDED.latitude,
  longitude = EXCLUDED.longitude;

INSERT INTO islamic_center.facilities (id, category, name, capacity, location, price_label, image_url, available, description) VALUES
  ('aula-utama', 'Aula', 'Aula Utama Islamic Center', 500, 'Surabaya', 'Gratis bersyarat', 'https://cdn.majadigi.go.id/demo/islamic/aula.jpg', true, 'Aula besar untuk seminar, pelatihan, dan kegiatan masyarakat.'),
  ('aula-madinah', 'Aula', 'Aula Madinah', 180, 'Surabaya', 'Rp500.000/kegiatan', 'https://cdn.majadigi.go.id/demo/islamic/aula-madinah.jpg', true, 'Aula sedang untuk kegiatan komunitas dan rapat koordinasi.'),
  ('asrama-a', 'Asrama', 'Asrama Putra Blok A', 80, 'Surabaya', 'Rp150.000/malam', 'https://cdn.majadigi.go.id/demo/islamic/asrama.jpg', true, 'Asrama putra untuk kegiatan pelatihan dan pesantren kilat.'),
  ('asrama-b', 'Asrama', 'Asrama Putri Blok B', 80, 'Surabaya', 'Rp150.000/malam', 'https://cdn.majadigi.go.id/demo/islamic/asrama-b.jpg', true, 'Asrama putri dengan fasilitas kamar bersama.'),
  ('masjid-raya', 'Masjid', 'Masjid Raya Islamic Center', 1200, 'Surabaya', 'Gratis', 'https://cdn.majadigi.go.id/demo/islamic/masjid.jpg', true, 'Masjid utama untuk ibadah, kajian, dan kegiatan keagamaan.')
ON CONFLICT (id) DO UPDATE SET
  category = EXCLUDED.category,
  name = EXCLUDED.name,
  capacity = EXCLUDED.capacity,
  location = EXCLUDED.location,
  price_label = EXCLUDED.price_label,
  image_url = EXCLUDED.image_url,
  available = EXCLUDED.available,
  description = EXCLUDED.description;

INSERT INTO islamic_center.bookings (id, facility_id, nama_pemohon, telepon, email, tanggal, waktu, catatan, status, submitted_at) VALUES
  ('60000000-0000-0000-0000-000000000001', 'aula-utama', 'Budi Santoso', '081234567893', 'budi@majadigi.go.id', '2026-06-10', 'Siang', 'Seminar UMKM masjid', 'Submitted', '2026-05-25T10:00:00+07:00'),
  ('60000000-0000-0000-0000-000000000002', 'asrama-a', 'Sinta Ayu Prameswari', '081234567892', 'sinta@majadigi.go.id', '2026-06-15', 'Malam', 'Pesantren kilat pelajar', 'Approved', '2026-05-26T11:00:00+07:00')
ON CONFLICT (id) DO UPDATE SET
  facility_id = EXCLUDED.facility_id,
  nama_pemohon = EXCLUDED.nama_pemohon,
  telepon = EXCLUDED.telepon,
  email = EXCLUDED.email,
  tanggal = EXCLUDED.tanggal,
  waktu = EXCLUDED.waktu,
  catatan = EXCLUDED.catatan,
  status = EXCLUDED.status,
  submitted_at = EXCLUDED.submitted_at;

INSERT INTO point_jatim.projects (id, name, sector, location, investment_value, irr, npv, payback_period, status, description) VALUES
  ('integrated-farming-pujon', 'Peternakan Sapi Perah Terintegrasi Modern', 'Peternakan', 'Pujon, Kabupaten Malang', 125000000000, 18.40, 42000000000, '5 tahun', 'Ready to Offer', 'Proyek integrated farming sapi perah untuk rantai dingin, pakan, dan pengolahan susu.'),
  ('health-tourism-batu', 'Health Tourism Batu Raya', 'Kesehatan', 'Kota Batu', 85000000000, 15.20, 26000000000, '6 tahun', 'Feasibility Study', 'Kawasan wisata kesehatan terintegrasi dengan layanan rehabilitasi dan wellness.'),
  ('agro-processing-madiun', 'Agro Processing Madiun', 'Pertanian', 'Kabupaten Madiun', 64000000000, 16.10, 21000000000, '4.8 tahun', 'Ready to Offer', 'Sentra pengolahan hasil pertanian berbasis kemitraan petani lokal.'),
  ('tourism-harbor-pacitan', 'Pengembangan Wisata Bahari Pacitan', 'Pariwisata', 'Kabupaten Pacitan', 98000000000, 14.60, 31000000000, '6.5 tahun', 'Market Sounding', 'Pengembangan dermaga wisata, area UMKM, dan paket wisata bahari.')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  sector = EXCLUDED.sector,
  location = EXCLUDED.location,
  investment_value = EXCLUDED.investment_value,
  irr = EXCLUDED.irr,
  npv = EXCLUDED.npv,
  payback_period = EXCLUDED.payback_period,
  status = EXCLUDED.status,
  description = EXCLUDED.description;

INSERT INTO point_jatim.submissions (id, project_id, nama_investor, email, telepon, catatan, status, submitted_at) VALUES
  ('61000000-0000-0000-0000-000000000001', 'integrated-farming-pujon', 'PT Demo Investama', 'investor@example.com', '081200001111', 'Tertarik sesi paparan proyek.', 'Submitted', '2026-05-25T09:00:00+07:00'),
  ('61000000-0000-0000-0000-000000000002', 'health-tourism-batu', 'Koperasi Sehat Jatim', 'koperasi@example.com', '081200002222', 'Minta data feasibility study.', 'Contacted', '2026-05-26T13:30:00+07:00')
ON CONFLICT (id) DO UPDATE SET
  project_id = EXCLUDED.project_id,
  nama_investor = EXCLUDED.nama_investor,
  email = EXCLUDED.email,
  telepon = EXCLUDED.telepon,
  catatan = EXCLUDED.catatan,
  status = EXCLUDED.status,
  submitted_at = EXCLUDED.submitted_at;

INSERT INTO tbc_screening.questions (id, nomor, section, text) VALUES
  ('q-cough', 1, 'Gejala Fisik dan Keluhan', 'Batuk (lebih dari 2 minggu atau kurang dari 2 minggu)'),
  ('q-blood-cough', 2, 'Gejala Fisik dan Keluhan', 'Batuk berdarah'),
  ('q-fever', 3, 'Gejala Fisik dan Keluhan', 'Demam'),
  ('q-night-sweat', 4, 'Gejala Fisik dan Keluhan', 'Berkeringat di malam hari tanpa aktivitas'),
  ('q-short-breath', 5, 'Gejala Fisik dan Keluhan', 'Sesak napas'),
  ('q-chest-pain', 6, 'Gejala Fisik dan Keluhan', 'Nyeri dada'),
  ('q-appetite', 7, 'Gejala Fisik dan Keluhan', 'Nafsu makan menurun atau hilang selama berhari-hari'),
  ('q-fatigue', 8, 'Gejala Fisik dan Keluhan', 'Mudah lelah atau sering merasa kecapekan tanpa aktivitas fisik yang berat'),
  ('q-weight', 9, 'Gejala Fisik dan Keluhan', 'Berat badan turun drastis (bukan karena diet)'),
  ('q-swollen-neck', 10, 'Gejala Fisik dan Keluhan', 'Adanya bengkak di leher, bawah rahang, bawah telinga, atau ketiak'),
  ('q-family-contact', 11, 'Riwayat Kontak dan Penularan', 'Apakah ada anggota keluarga serumah yang sakit TBC?'),
  ('q-room-contact', 12, 'Riwayat Kontak dan Penularan', 'Apakah pernah berada dalam satu ruangan dengan penderita TBC (kantor, kelas, asrama, dll)?'),
  ('q-house-contact', 13, 'Riwayat Kontak dan Penularan', 'Apakah pernah tinggal serumah (minimal satu malam atau sering pada siang hari) dengan penderita TBC?'),
  ('q-treatment-done', 14, 'Riwayat Pengobatan dan Kondisi Kesehatan', 'Pernah berobat TBC dan tuntas'),
  ('q-treatment', 15, 'Riwayat Pengobatan dan Kondisi Kesehatan', 'Pernah berobat TBC tapi tidak tuntas'),
  ('q-diabetes', 16, 'Riwayat Pengobatan dan Kondisi Kesehatan', 'Memiliki riwayat penyakit Diabetes Melitus (kencing manis)'),
  ('q-hiv', 17, 'Riwayat Pengobatan dan Kondisi Kesehatan', 'Status sebagai Orang Dengan HIV'),
  ('q-pregnancy', 18, 'Riwayat Pengobatan dan Kondisi Kesehatan', 'Sedang hamil (Ibu Hamil)'),
  ('q-smoking', 19, 'Riwayat Pengobatan dan Kondisi Kesehatan', 'Memiliki kebiasaan merokok'),
  ('q-age', 20, 'Riwayat Pengobatan dan Kondisi Kesehatan', 'Status usia (0-14 tahun atau lansia di atas 60 tahun)'),
  ('q-nutrition', 21, 'Riwayat Pengobatan dan Kondisi Kesehatan', 'Kondisi gizi (kurang gizi atau kurus)'),
  ('q-underweight', 22, 'Riwayat Pengobatan dan Kondisi Kesehatan', 'Kurang Gizi (kurus)'),
  ('q-elderly', 23, 'Riwayat Pengobatan dan Kondisi Kesehatan', 'Lansia (diatas 60 tahun)')
ON CONFLICT (id) DO UPDATE SET
  nomor = EXCLUDED.nomor,
  section = EXCLUDED.section,
  text = EXCLUDED.text;

INSERT INTO tbc_screening.faskes (id, name, type, region, address, phone, latitude, longitude) VALUES
  ('pkm-klojen', 'Puskesmas Klojen', 'Puskesmas', 'Kota Malang', 'Klojen, Kota Malang', '0341-000001', -7.9730000, 112.6300000),
  ('pkm-sukolilo', 'Puskesmas Sukolilo', 'Puskesmas', 'Kota Surabaya', 'Sukolilo, Surabaya', '031-000001', -7.2890000, 112.7970000),
  ('rsud-daha', 'RSUD Daha Husada', 'Rumah Sakit', 'Kediri', 'Kediri, Jawa Timur', '0354-000001', -7.8480000, 112.0178000),
  ('klinik-batu-sehat', 'Klinik Batu Sehat', 'Klinik', 'Kota Batu', 'Batu, Jawa Timur', '0341-000002', -7.8831000, 112.5334000)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  type = EXCLUDED.type,
  region = EXCLUDED.region,
  address = EXCLUDED.address,
  phone = EXCLUDED.phone,
  latitude = EXCLUDED.latitude,
  longitude = EXCLUDED.longitude;

INSERT INTO tbc_screening.records (id, nik, nama, kabupaten_kota, risk_level, recommendation, answers_json, submitted_at) VALUES
  ('62000000-0000-0000-0000-000000000001', '3573010101010001', 'Warga Demo Majadigi', 'Kota Malang', 'Sedang', 'Pantau gejala dan konsultasi bila keluhan berlanjut.', '[{"question_id":"q-cough","answer":true},{"question_id":"q-fever","answer":false}]', '2026-05-27T08:00:00+07:00'),
  ('62000000-0000-0000-0000-000000000002', '3515040404040004', 'Budi Santoso', 'Kediri', 'Tinggi', 'Segera lakukan pemeriksaan dahak di faskes terdekat.', '[{"question_id":"q-cough","answer":true},{"question_id":"q-fever","answer":true},{"question_id":"q-contact","answer":true}]', '2026-05-28T09:00:00+07:00')
ON CONFLICT (id) DO UPDATE SET
  nik = EXCLUDED.nik,
  nama = EXCLUDED.nama,
  kabupaten_kota = EXCLUDED.kabupaten_kota,
  risk_level = EXCLUDED.risk_level,
  recommendation = EXCLUDED.recommendation,
  answers_json = EXCLUDED.answers_json,
  submitted_at = EXCLUDED.submitted_at;
