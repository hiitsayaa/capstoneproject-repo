import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../../common/database/database.service';
import { SubmitTbcScreeningDto } from './tbc-screening.dto';

@Injectable()
export class TbcScreeningService {
  constructor(private readonly database: DatabaseService) {}

  private readonly questions = [
    { id: 'q-cough', nomor: 1, section: 'Gejala Fisik dan Keluhan', text: 'Batuk (lebih dari 2 minggu atau kurang dari 2 minggu)' },
    { id: 'q-blood-cough', nomor: 2, section: 'Gejala Fisik dan Keluhan', text: 'Batuk berdarah' },
    { id: 'q-fever', nomor: 3, section: 'Gejala Fisik dan Keluhan', text: 'Demam' },
    { id: 'q-night-sweat', nomor: 4, section: 'Gejala Fisik dan Keluhan', text: 'Berkeringat di malam hari tanpa aktivitas' },
    { id: 'q-short-breath', nomor: 5, section: 'Gejala Fisik dan Keluhan', text: 'Sesak napas' },
    { id: 'q-chest-pain', nomor: 6, section: 'Gejala Fisik dan Keluhan', text: 'Nyeri dada' },
    { id: 'q-appetite', nomor: 7, section: 'Gejala Fisik dan Keluhan', text: 'Nafsu makan menurun atau hilang selama berhari-hari' },
    { id: 'q-fatigue', nomor: 8, section: 'Gejala Fisik dan Keluhan', text: 'Mudah lelah atau sering merasa kecapekan tanpa aktivitas fisik yang berat' },
    { id: 'q-weight', nomor: 9, section: 'Gejala Fisik dan Keluhan', text: 'Berat badan turun drastis (bukan karena diet)' },
    { id: 'q-swollen-neck', nomor: 10, section: 'Gejala Fisik dan Keluhan', text: 'Adanya bengkak di leher, bawah rahang, bawah telinga, atau ketiak' },
    { id: 'q-family-contact', nomor: 11, section: 'Riwayat Kontak dan Penularan', text: 'Apakah ada anggota keluarga serumah yang sakit TBC?' },
    { id: 'q-room-contact', nomor: 12, section: 'Riwayat Kontak dan Penularan', text: 'Apakah pernah berada dalam satu ruangan dengan penderita TBC (kantor, kelas, asrama, dll)?' },
    { id: 'q-house-contact', nomor: 13, section: 'Riwayat Kontak dan Penularan', text: 'Apakah pernah tinggal serumah (minimal satu malam atau sering pada siang hari) dengan penderita TBC?' },
    { id: 'q-treatment-done', nomor: 14, section: 'Riwayat Pengobatan dan Kondisi Kesehatan', text: 'Pernah berobat TBC dan tuntas' },
    { id: 'q-treatment', nomor: 15, section: 'Riwayat Pengobatan dan Kondisi Kesehatan', text: 'Pernah berobat TBC tapi tidak tuntas' },
    { id: 'q-diabetes', nomor: 16, section: 'Riwayat Pengobatan dan Kondisi Kesehatan', text: 'Memiliki riwayat penyakit Diabetes Melitus (kencing manis)' },
    { id: 'q-hiv', nomor: 17, section: 'Riwayat Pengobatan dan Kondisi Kesehatan', text: 'Status sebagai Orang Dengan HIV' },
    { id: 'q-pregnancy', nomor: 18, section: 'Riwayat Pengobatan dan Kondisi Kesehatan', text: 'Sedang hamil (Ibu Hamil)' },
    { id: 'q-smoking', nomor: 19, section: 'Riwayat Pengobatan dan Kondisi Kesehatan', text: 'Memiliki kebiasaan merokok' },
    { id: 'q-age', nomor: 20, section: 'Riwayat Pengobatan dan Kondisi Kesehatan', text: 'Status usia (0-14 tahun atau lansia di atas 60 tahun)' },
    { id: 'q-nutrition', nomor: 21, section: 'Riwayat Pengobatan dan Kondisi Kesehatan', text: 'Kondisi gizi (kurang gizi atau kurus)' },
    { id: 'q-underweight', nomor: 22, section: 'Riwayat Pengobatan dan Kondisi Kesehatan', text: 'Kurang Gizi (kurus)' },
    { id: 'q-elderly', nomor: 23, section: 'Riwayat Pengobatan dan Kondisi Kesehatan', text: 'Lansia (diatas 60 tahun)' },
  ];

  private readonly faskes = [
    { id: 'pkm-klojen', name: 'Puskesmas Klojen', type: 'Puskesmas', region: 'Kota Malang', address: 'Klojen, Kota Malang', phone: '0341-000001' },
    { id: 'rsud-daha', name: 'RSUD Daha Husada', type: 'Rumah Sakit', region: 'Kediri', address: 'Kediri, Jawa Timur', phone: '0354-000001' },
  ];

  async getQuestions() {
    const rows = await this.database.query<Record<string, unknown>>(
      'SELECT id, nomor, section, text FROM tbc_screening.questions ORDER BY nomor',
    );
    return { data: rows ?? this.questions };
  }

  async getFaskes(region?: string, type?: string) {
    const rows = await this.database.query<Record<string, unknown>>(
      `
        SELECT id, name, type, region, address, phone, latitude::float, longitude::float
        FROM tbc_screening.faskes
        WHERE ($1::text IS NULL OR region ILIKE '%' || $1 || '%')
          AND ($2::text IS NULL OR type ILIKE $2)
        ORDER BY region, name
      `,
      [region ?? null, type && type !== 'Semua Tipe' ? type : null],
    );
    if (rows) return { data: rows };

    return {
      data: this.faskes.filter((item) => (!region || item.region.includes(region)) && (!type || type === 'Semua Tipe' || item.type === type)),
    };
  }

  async submit(payload: SubmitTbcScreeningDto, userId?: string) {
    const positiveAnswers = payload.answers.filter((answer) => answer.answer).length;
    // Calculate hasil based on positive answers
    const hasil = positiveAnswers >= 1 ? 'Terindikasi TBC' : 'Tidak Terindikasi TBC';
    const recommendation = hasil === 'Terindikasi TBC' ? 'Segera lakukan pemeriksaan dahak di faskes terdekat.' : 'Pantau gejala dan konsultasi bila keluhan berlanjut.';
    const row = await this.database.queryOne<Record<string, unknown>>(
      `
        INSERT INTO tbc_screening.records (
          nik, nama, kabupaten_kota, hasil, recommendation, answers_json,
          is_self, pelapor_nama, pelapor_kelompok, pelapor_instansi, pelapor_telepon,
          jenis_kelamin, telepon, tanggal_lahir, usia, berat_badan, tinggi_badan,
          alamat, pekerjaan, kecamatan, kelurahan, user_id
        )
        VALUES (
          $1, $2, $3, $4, $5, $6,
          $7, $8, $9, $10, $11,
          $12, $13, $14, $15, $16, $17,
          $18, $19, $20, $21, $22
        )
        RETURNING id, nik, nama, kabupaten_kota, hasil, recommendation, answers_json, submitted_at, user_id
      `,
      [
        payload.nik, payload.nama, payload.kabupaten_kota ?? null, hasil, recommendation, JSON.stringify(payload.answers),
        payload.is_self ?? true, payload.pelapor_nama ?? null, payload.pelapor_kelompok ?? null, payload.pelapor_instansi ?? null, payload.pelapor_telepon ?? null,
        payload.jenis_kelamin ?? null, payload.telepon ?? null, payload.tanggal_lahir ?? null, payload.usia ?? null, payload.berat_badan ?? null, payload.tinggi_badan ?? null,
        payload.alamat ?? null, payload.pekerjaan ?? null, payload.kecamatan ?? null, payload.kelurahan ?? null, userId ?? null
      ],
    );
    return row ?? { id: `screening-${Date.now()}`, ...payload, hasil, recommendation, submitted_at: new Date().toISOString() };
  }

  async getHistory(userId?: string, nik?: string) {
    const rows = await this.database.query<Record<string, unknown>>(
      `
        SELECT id, nik, nama, kabupaten_kota, hasil, recommendation, answers_json, submitted_at, faskes_name
        FROM tbc_screening.records
        WHERE ($1::text IS NULL OR user_id = $1)
          AND ($2::text IS NULL OR nik = $2)
        ORDER BY submitted_at DESC
      `,
      [userId ?? null, nik ?? null],
    );
    return { data: rows ?? [] };
  }

  async updateFaskes(id: string, faskesName: string) {
    const row = await this.database.queryOne(
      `
        UPDATE tbc_screening.records
        SET faskes_name = $2
        WHERE id = $1
        RETURNING id, faskes_name
      `,
      [id, faskesName]
    );
    return row;
  }
}
