import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { DatabaseService } from '../../common/database/database.service';

@Injectable()
export class HoaksService {
  constructor(private readonly database: DatabaseService) {}

  private readonly articles = [
    {
      id: 'article-001',
      judul: 'Klarifikasi Informasi Layanan Pajak Kendaraan',
      konten: 'Informasi resmi pembayaran PKB hanya melalui kanal yang diumumkan Pemerintah Provinsi Jawa Timur.',
      kategori: 'Layanan Publik',
      status_klarifikasi: 'Fakta',
      url_sumber: 'https://kominfo.jatimprov.go.id',
      published_at: '2026-05-30T00:00:00+07:00',
    },
  ];

  private readonly reports: Array<Record<string, unknown>> = [];

  async getArticles() {
    const dbRows = await this.database.query<Record<string, unknown>>(
      `
        SELECT id, judul, konten, kategori, status_klarifikasi, url_sumber, published_at
        FROM hoaks.hoax_articles
        ORDER BY published_at DESC
      `,
    );
    if (dbRows) {
      return { data: dbRows };
    }

    return { data: this.articles };
  }

  async report(payload: { judul_laporan: string; deskripsi_kejadian: string; url_bukti?: string }, nik?: string) {
    if (payload.deskripsi_kejadian && payload.deskripsi_kejadian.trim().length > 0) {
      const existing = await this.database.queryOne(
        `SELECT id FROM hoaks.hoax_reports WHERE deskripsi_kejadian = $1`,
        [payload.deskripsi_kejadian]
      );
      if (existing) {
        throw new HttpException('Konten ini sudah pernah dilaporkan sebagai hoaks', HttpStatus.CONFLICT);
      }
    }

    const dbReport = await this.database.queryOne<Record<string, unknown>>(
      `
        INSERT INTO hoaks.hoax_reports (user_id, judul_laporan, deskripsi_kejadian, url_bukti, status_laporan)
        VALUES ($1, $2, $3, $4, 'Sedang Diverifikasi')
        RETURNING id, user_id, judul_laporan, deskripsi_kejadian, url_bukti, status_laporan
      `,
      [nik ?? 'anonymous', payload.judul_laporan, payload.deskripsi_kejadian, payload.url_bukti ?? null],
    );

    if (dbReport) {
      return {
        ...dbReport,
        submitted_at: new Date().toISOString(),
      };
    }

    const report = {
      id: `report-${Date.now()}`,
      user_id: nik ?? 'anonymous',
      ...payload,
      status_laporan: 'Sedang Diverifikasi',
      submitted_at: new Date().toISOString(),
    };
    this.reports.push(report);
    return report;
  }
}
