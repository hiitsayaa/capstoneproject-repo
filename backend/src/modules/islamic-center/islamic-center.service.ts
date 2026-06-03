import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../../common/database/database.service';
import { CreateIslamicCenterBookingDto } from './islamic-center.dto';

@Injectable()
export class IslamicCenterService {
  constructor(private readonly database: DatabaseService) {}

  private readonly facilities = [
    { id: 'aula-utama', category: 'Aula', name: 'Aula Utama Islamic Center', capacity: 500, location: 'Surabaya', price_label: 'Gratis bersyarat', image_url: 'https://cdn.majadigi.go.id/demo/islamic/aula.jpg', available: true },
    { id: 'asrama-a', category: 'Asrama', name: 'Asrama Putra Blok A', capacity: 80, location: 'Surabaya', price_label: 'Rp150.000/malam', image_url: 'https://cdn.majadigi.go.id/demo/islamic/asrama.jpg', available: true },
    { id: 'masjid-raya', category: 'Masjid', name: 'Masjid Raya Islamic Center', capacity: 1200, location: 'Surabaya', price_label: 'Gratis', image_url: 'https://cdn.majadigi.go.id/demo/islamic/masjid.jpg', available: true },
  ];

  async getFacilities(category?: string) {
    const rows = await this.database.query<Record<string, unknown>>(
      `
        SELECT id, category, name, capacity, location, price_label, image_url, available
        FROM islamic_center.facilities
        WHERE ($1::text IS NULL OR category ILIKE $1)
        ORDER BY category, name
      `,
      [category ?? null],
    );
    if (rows) {
      return { data: rows };
    }

    return {
      data: this.facilities.filter((item) => !category || item.category.toLowerCase() === category.toLowerCase()),
    };
  }

  async getFacility(id: string) {
    const row = await this.database.queryOne<Record<string, unknown>>(
      'SELECT id, category, name, capacity, location, price_label, image_url, available, description FROM islamic_center.facilities WHERE id = $1',
      [id],
    );
    if (row) {
      return row;
    }

    const facility = this.facilities.find((item) => item.id === id);
    if (!facility) {
      throw new NotFoundException('Fasilitas Islamic Center tidak ditemukan');
    }
    return facility;
  }

  async createBooking(payload: CreateIslamicCenterBookingDto) {
    const row = await this.database.queryOne<Record<string, unknown>>(
      `
        INSERT INTO islamic_center.bookings (facility_id, nama_pemohon, telepon, email, tanggal, waktu, catatan, status)
        VALUES ($1, $2, $3, $4, $5, $6, $7, 'Submitted')
        RETURNING id, facility_id, nama_pemohon, telepon, email, tanggal::text, waktu, catatan, status, submitted_at
      `,
      [payload.facility_id, payload.nama_pemohon, payload.telepon, payload.email, payload.tanggal, payload.waktu, payload.catatan ?? null],
    );
    return row ?? { id: `booking-${Date.now()}`, ...payload, status: 'Submitted', submitted_at: new Date().toISOString() };
  }
}
