import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../../common/database/database.service';

@Injectable()
export class EmergencyService {
  constructor(private readonly database: DatabaseService) {}

  private readonly contacts = [
    { id: 'surabaya-112', region: 'Kota Surabaya', name: 'Command Center 112 Surabaya', category: 'Darurat Umum', phone: '112', address: 'Kota Surabaya, Jawa Timur', latitude: -7.2575, longitude: 112.7521 },
    { id: 'jatim-110', region: 'Jawa Timur', name: 'Kepolisian', category: 'Keamanan', phone: '110', address: 'Jawa Timur', latitude: -7.5361, longitude: 112.2384 },
    { id: 'jatim-118', region: 'Jawa Timur', name: 'Ambulans PSC', category: 'Kesehatan', phone: '118', address: 'Jawa Timur', latitude: -7.5361, longitude: 112.2384 },
    { id: 'malang-112', region: 'Kota Malang', name: 'Ngalam 112', category: 'Darurat Umum', phone: '112', address: 'Kota Malang, Jawa Timur', latitude: -7.9666, longitude: 112.6326 },
  ];

  async getRegions() {
    const rows = await this.database.query<{ region: string }>(
      'SELECT DISTINCT region FROM emergency.contacts ORDER BY region',
    );
    return { data: rows?.map((row) => row.region) ?? [...new Set(this.contacts.map((contact) => contact.region))] };
  }

  async getContacts(region?: string) {
    const rows = await this.database.query<Record<string, unknown>>(
      `
        SELECT id, region, name, category, phone, address, latitude::float, longitude::float
        FROM emergency.contacts
        WHERE ($1::text IS NULL OR region ILIKE '%' || $1 || '%')
        ORDER BY region, category, name
      `,
      [region ?? null],
    );
    if (rows) {
      return { data: rows };
    }

    return {
      data: this.contacts.filter((contact) => !region || contact.region.toLowerCase().includes(region.toLowerCase())),
    };
  }

  async getContact(id: string) {
    const row = await this.database.queryOne<Record<string, unknown>>(
      'SELECT id, region, name, category, phone, address, latitude::float, longitude::float FROM emergency.contacts WHERE id = $1',
      [id],
    );
    if (row) {
      return row;
    }

    const contact = this.contacts.find((item) => item.id === id);
    if (!contact) {
      throw new NotFoundException('Kontak darurat tidak ditemukan');
    }
    return contact;
  }
}
