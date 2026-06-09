import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../../common/database/database.service';

@Injectable()
export class TicketsService {
  constructor(private readonly database: DatabaseService) {}

  private readonly fallbackTickets = [
    {
      id: '51000000-0000-0000-0000-000000000001',
      source: 'hoaks',
      title: 'Pesan WhatsApp PKB gratis',
      status: 'Investigating',
      updated_at: '2026-05-30T08:00:00+07:00',
    },
  ];

  async getTickets(nik?: string) {
    const rows = await this.database.query<Record<string, unknown>>(
      `
        SELECT id, 'hoaks' AS source, judul_laporan AS title, status_laporan AS status, user_id, created_at AS updated_at
        FROM hoaks.hoax_reports
        WHERE ($1::text IS NULL OR user_id = $1)
        ORDER BY id DESC
      `,
      [nik ?? null],
    );
    return { data: rows ?? this.fallbackTickets };
  }

  async getTicket(id: string) {
    const row = await this.database.queryOne<Record<string, unknown>>(
      `
        SELECT id, 'hoaks' AS source, judul_laporan AS title, deskripsi_kejadian AS description,
               url_bukti, status_laporan AS status, user_id, created_at AS updated_at
        FROM hoaks.hoax_reports
        WHERE id::text = $1
      `,
      [id],
    );
    if (row) return row;

    const ticket = this.fallbackTickets.find((item) => item.id === id);
    if (!ticket) {
      throw new NotFoundException('Tiket tidak ditemukan');
    }
    return ticket;
  }
}
