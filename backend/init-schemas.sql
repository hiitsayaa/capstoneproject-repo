CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS bapenda;
CREATE SCHEMA IF NOT EXISTS rsud;
CREATE SCHEMA IF NOT EXISTS bansos;
CREATE SCHEMA IF NOT EXISTS hoaks;
CREATE SCHEMA IF NOT EXISTS gateway;
CREATE SCHEMA IF NOT EXISTS emergency;
CREATE SCHEMA IF NOT EXISTS islamic_center;
CREATE SCHEMA IF NOT EXISTS point_jatim;
CREATE SCHEMA IF NOT EXISTS tbc_screening;

CREATE TABLE IF NOT EXISTS auth.users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('Admin', 'RegisteredUser', 'Visitor')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS auth.profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  nik TEXT UNIQUE NOT NULL,
  kk TEXT,
  nama_lengkap TEXT NOT NULL,
  tempat_lahir TEXT,
  tanggal_lahir DATE,
  jenis_kelamin TEXT,
  telepon TEXT,
  alamat_lengkap TEXT
);

CREATE TABLE IF NOT EXISTS auth.favorites (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  service_key TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, service_key)
);

CREATE TABLE IF NOT EXISTS bapenda.vehicles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nopol TEXT UNIQUE NOT NULL,
  nik_pemilik TEXT NOT NULL,
  merk TEXT NOT NULL,
  tipe TEXT NOT NULL,
  tahun INTEGER NOT NULL,
  no_rangka TEXT,
  no_mesin TEXT
);

CREATE TABLE IF NOT EXISTS bapenda.pkb_bills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  vehicle_id UUID NOT NULL REFERENCES bapenda.vehicles(id) ON DELETE CASCADE,
  pokok_pkb NUMERIC(14, 2) NOT NULL,
  denda_pkb NUMERIC(14, 2) NOT NULL DEFAULT 0,
  swdkllj NUMERIC(14, 2) NOT NULL DEFAULT 0,
  denda_swdkllj NUMERIC(14, 2) NOT NULL DEFAULT 0,
  status TEXT NOT NULL CHECK (status IN ('Unpaid', 'Paid')),
  due_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS bapenda.pkb_payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bill_id UUID NOT NULL REFERENCES bapenda.pkb_bills(id) ON DELETE CASCADE,
  payment_method TEXT NOT NULL,
  va_number TEXT NOT NULL,
  amount_paid NUMERIC(14, 2) NOT NULL,
  paid_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS bapenda.njkb_data (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  merk TEXT NOT NULL,
  tipe TEXT NOT NULL,
  tahun INTEGER NOT NULL,
  nilai_njkb NUMERIC(14, 2) NOT NULL,
  bobot NUMERIC(6, 3) NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS rsud.hospitals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nama_rs TEXT NOT NULL,
  alamat TEXT NOT NULL,
  tipe TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS rsud.room_availability (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  hospital_id UUID NOT NULL REFERENCES rsud.hospitals(id) ON DELETE CASCADE,
  kelas_kamar TEXT NOT NULL,
  kapasitas_total INTEGER NOT NULL,
  kamar_tersedia INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS rsud.queues (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  hospital_id UUID NOT NULL REFERENCES rsud.hospitals(id) ON DELETE CASCADE,
  nik TEXT NOT NULL,
  dokter_nama TEXT NOT NULL,
  spesialisasi TEXT NOT NULL,
  tanggal_kunjungan DATE NOT NULL,
  nomor_antrian TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('Waiting', 'Call', 'Done'))
);

CREATE TABLE IF NOT EXISTS rsud.surgeries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  hospital_id UUID NOT NULL REFERENCES rsud.hospitals(id) ON DELETE CASCADE,
  dokter_nama TEXT NOT NULL,
  ruangan_operasi TEXT NOT NULL,
  jadwal_mulai TIMESTAMPTZ NOT NULL,
  estimasi_durasi INTEGER NOT NULL,
  status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS bansos.bansos_programs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nama_program TEXT NOT NULL,
  deskripsi TEXT NOT NULL,
  persyaratan_json JSONB NOT NULL DEFAULT '{}',
  periode TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS bansos.applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  program_id UUID NOT NULL REFERENCES bansos.bansos_programs(id) ON DELETE CASCADE,
  nik TEXT NOT NULL,
  nama_ibu_kandung TEXT NOT NULL,
  penghasilan_bulanan NUMERIC(14, 2) NOT NULL,
  jumlah_tanggungan INTEGER NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('Submitted', 'Verifying', 'Approved', 'Rejected')),
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS bansos.documents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  application_id UUID NOT NULL REFERENCES bansos.applications(id) ON DELETE CASCADE,
  document_type TEXT NOT NULL,
  file_url TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS hoaks.hoax_articles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  judul TEXT NOT NULL,
  konten TEXT NOT NULL,
  kategori TEXT NOT NULL,
  status_klarifikasi TEXT NOT NULL CHECK (status_klarifikasi IN ('Fakta', 'Hoaks', 'Disinformasi')),
  url_sumber TEXT,
  published_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS hoaks.hoax_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id TEXT,
  judul_laporan TEXT NOT NULL,
  deskripsi_kejadian TEXT NOT NULL,
  url_bukti TEXT,
  status_laporan TEXT NOT NULL CHECK (status_laporan IN ('Pending', 'Investigating', 'Clarified'))
);

CREATE TABLE IF NOT EXISTS gateway.active_features (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  feature_key TEXT UNIQUE NOT NULL,
  version TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('Active', 'Maintenance', 'Inactive')),
  flutter_route TEXT NOT NULL,
  required_role TEXT NOT NULL CHECK (required_role IN ('RegisteredUser', 'Visitor')),
  last_updated TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS emergency.contacts (
  id TEXT PRIMARY KEY,
  region TEXT NOT NULL,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT NOT NULL,
  latitude NUMERIC(10, 7),
  longitude NUMERIC(10, 7)
);

CREATE TABLE IF NOT EXISTS islamic_center.facilities (
  id TEXT PRIMARY KEY,
  category TEXT NOT NULL,
  name TEXT NOT NULL,
  capacity INTEGER NOT NULL,
  location TEXT NOT NULL,
  price_label TEXT NOT NULL,
  image_url TEXT,
  available BOOLEAN NOT NULL DEFAULT true,
  description TEXT
);

CREATE TABLE IF NOT EXISTS islamic_center.bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  facility_id TEXT NOT NULL REFERENCES islamic_center.facilities(id) ON DELETE CASCADE,
  nama_pemohon TEXT NOT NULL,
  telepon TEXT NOT NULL,
  email TEXT NOT NULL,
  tanggal DATE NOT NULL,
  waktu TEXT NOT NULL,
  catatan TEXT,
  status TEXT NOT NULL CHECK (status IN ('Submitted', 'Approved', 'Rejected', 'Cancelled')),
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS point_jatim.projects (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  sector TEXT NOT NULL,
  location TEXT NOT NULL,
  investment_value NUMERIC(16, 2) NOT NULL,
  irr NUMERIC(6, 2) NOT NULL,
  npv NUMERIC(16, 2) NOT NULL,
  payback_period TEXT NOT NULL,
  status TEXT NOT NULL,
  description TEXT
);

CREATE TABLE IF NOT EXISTS point_jatim.submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id TEXT NOT NULL REFERENCES point_jatim.projects(id) ON DELETE CASCADE,
  nama_investor TEXT NOT NULL,
  email TEXT NOT NULL,
  telepon TEXT NOT NULL,
  catatan TEXT,
  status TEXT NOT NULL CHECK (status IN ('Submitted', 'Contacted', 'Closed')),
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tbc_screening.questions (
  id TEXT PRIMARY KEY,
  nomor INTEGER NOT NULL,
  section TEXT NOT NULL,
  text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS tbc_screening.faskes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  region TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT,
  latitude NUMERIC(10, 7),
  longitude NUMERIC(10, 7)
);

CREATE TABLE IF NOT EXISTS tbc_screening.records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nik TEXT NOT NULL,
  nama TEXT NOT NULL,
  kabupaten_kota TEXT,
  risk_level TEXT NOT NULL CHECK (risk_level IN ('Rendah', 'Sedang', 'Tinggi')),
  recommendation TEXT NOT NULL,
  answers_json JSONB NOT NULL DEFAULT '[]',
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE SCHEMA IF NOT EXISTS aktivitas;

CREATE TABLE IF NOT EXISTS aktivitas.user_activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  type TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('Dalam Proses', 'Selesai')),
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
