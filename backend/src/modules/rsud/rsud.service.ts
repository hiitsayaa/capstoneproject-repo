import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../../common/database/database.service';

@Injectable()
export class RsudService {
  constructor(private readonly database: DatabaseService) {}

  private readonly hospitals = [
    {
      id: 'daha',
      nama_rs: 'RSUD Daha Husada',
      alamat: 'Kediri, Jawa Timur',
      tipe: 'B',
    },
    {
      id: 'karsa',
      nama_rs: 'RSUD Karsa Husada',
      alamat: 'Batu, Jawa Timur',
      tipe: 'B',
    },
    {
      id: 'haji',
      nama_rs: 'RSUD Haji Provinsi Jawa Timur',
      alamat: 'Surabaya, Jawa Timur',
      tipe: 'B',
    },
  ];

  private readonly rooms = [
    { id: 'room-001', hospital_id: 'daha', kelas_kamar: 'VIP', kapasitas_total: 12, kamar_tersedia: 4 },
    { id: 'room-002', hospital_id: 'daha', kelas_kamar: 'III', kapasitas_total: 64, kamar_tersedia: 11 },
    { id: 'room-003', hospital_id: 'karsa', kelas_kamar: 'ICU', kapasitas_total: 8, kamar_tersedia: 2 },
    { id: 'room-004', hospital_id: 'karsa', kelas_kamar: 'III', kapasitas_total: 52, kamar_tersedia: 17 },
    { id: 'room-005', hospital_id: 'haji', kelas_kamar: 'VIP', kapasitas_total: 20, kamar_tersedia: 6 },
    { id: 'room-006', hospital_id: 'haji', kelas_kamar: 'ICU', kapasitas_total: 14, kamar_tersedia: 3 },
  ];

  private readonly queues: Array<Record<string, unknown>> = [];

  private readonly surgeries = [
    {
      id: 'surgery-001',
      hospital_id: 'daha',
      dokter_nama: 'dr. Sekar Ayu',
      ruangan_operasi: 'OK-1',
      jadwal_mulai: '2026-06-01T08:00:00+07:00',
      estimasi_durasi: 120,
      status: 'Scheduled',
    },
    {
      id: 'surgery-002',
      hospital_id: 'haji',
      dokter_nama: 'dr. Arif Nugroho',
      ruangan_operasi: 'OK Jantung',
      jadwal_mulai: '2026-06-03T13:00:00+07:00',
      estimasi_durasi: 180,
      status: 'Scheduled',
    },
  ];

  async getHospitals() {
    const dbRows = await this.database.query<Record<string, unknown>>(
      'SELECT id, nama_rs, alamat, tipe FROM rsud.hospitals ORDER BY nama_rs',
    );
    if (dbRows) {
      return { data: dbRows.map((row) => ({ ...row, slug: this.slugFromHospitalName(String(row.nama_rs)) })) };
    }

    return { data: this.hospitals };
  }

  async getHospital(hospitalId: string) {
    const dbHospital = await this.findDbHospital(hospitalId);
    if (dbHospital) {
      return { ...dbHospital, slug: this.slugFromHospitalName(dbHospital.nama_rs) };
    }

    const hospital = this.hospitals.find((item) => item.id === hospitalId);
    if (!hospital) throw new NotFoundException('RSUD tidak ditemukan');
    return hospital;
  }

  async getRooms(hospitalId: string) {
    const dbHospital = await this.findDbHospital(hospitalId);
    if (dbHospital) {
      const rooms = await this.database.query<Record<string, unknown>>(
        `
          SELECT id, hospital_id, kelas_kamar, kapasitas_total, kamar_tersedia
          FROM rsud.room_availability
          WHERE hospital_id = $1
          ORDER BY kelas_kamar
        `,
        [dbHospital.id],
      );
      return {
        hospital_id: hospitalId,
        rooms: rooms ?? [],
      };
    }

    this.assertHospitalExists(hospitalId);
    return {
      hospital_id: hospitalId,
      rooms: this.rooms.filter((room) => room.hospital_id === hospitalId),
    };
  }

  async getRoom(hospitalId: string, roomId: string) {
    const dbHospital = await this.findDbHospital(hospitalId);
    if (dbHospital) {
      const room = await this.database.queryOne<Record<string, unknown>>(
        `
          SELECT id, hospital_id, kelas_kamar, kapasitas_total, kamar_tersedia
          FROM rsud.room_availability
          WHERE hospital_id = $1 AND id::text = $2
        `,
        [dbHospital.id, roomId],
      );
      if (room) return room;
    }

    const room = this.rooms.find((item) => item.hospital_id === hospitalId && item.id === roomId);
    if (!room) throw new NotFoundException('Kamar RSUD tidak ditemukan');
    return room;
  }

  async createQueue(
    hospitalId: string,
    payload: { nik: string; dokter_nama: string; spesialisasi: string; tanggal_kunjungan: string },
  ) {
    const dbHospital = await this.findDbHospital(hospitalId);
    if (dbHospital) {
      const existingToday = await this.database.query<{ count: string }>(
        'SELECT COUNT(*)::text FROM rsud.queues WHERE hospital_id = $1 AND tanggal_kunjungan = $2',
        [dbHospital.id, payload.tanggal_kunjungan],
      );
      const queueNumber = Number(existingToday?.[0]?.count ?? 0) + 1;
      const queue = await this.database.queryOne<Record<string, unknown>>(
        `
          INSERT INTO rsud.queues (hospital_id, nik, dokter_nama, spesialisasi, tanggal_kunjungan, nomor_antrian, status)
          VALUES ($1, $2, $3, $4, $5, $6, 'Waiting')
          RETURNING id, hospital_id, nik, dokter_nama, spesialisasi, tanggal_kunjungan::text, nomor_antrian, status
        `,
        [dbHospital.id, payload.nik, payload.dokter_nama, payload.spesialisasi, payload.tanggal_kunjungan, `A-${String(queueNumber).padStart(3, '0')}`],
      );
      return queue;
    }

    this.assertHospitalExists(hospitalId);
    const existingToday = this.queues.filter(
      (queue) => queue.hospital_id === hospitalId && queue.tanggal_kunjungan === payload.tanggal_kunjungan,
    );
    const queue = {
      id: `queue-${Date.now()}`,
      hospital_id: hospitalId,
      ...payload,
      nomor_antrian: `A-${String(existingToday.length + 1).padStart(3, '0')}`,
      status: 'Waiting',
    };
    this.queues.push(queue);
    return queue;
  }

  async getSurgeries(hospitalId: string, tanggal?: string) {
    const dbHospital = await this.findDbHospital(hospitalId);
    if (dbHospital) {
      const surgeries = await this.database.query<Record<string, unknown>>(
        `
          SELECT id, hospital_id, dokter_nama, ruangan_operasi, jadwal_mulai, estimasi_durasi, status
          FROM rsud.surgeries
          WHERE hospital_id = $1
            AND ($2::text IS NULL OR jadwal_mulai::text LIKE $2 || '%')
          ORDER BY jadwal_mulai
        `,
        [dbHospital.id, tanggal ?? null],
      );
      return {
        hospital_id: hospitalId,
        surgeries: surgeries ?? [],
      };
    }

    this.assertHospitalExists(hospitalId);
    return {
      hospital_id: hospitalId,
      surgeries: this.surgeries.filter((surgery) => {
        const matchesHospital = surgery.hospital_id === hospitalId;
        const matchesDate = !tanggal || surgery.jadwal_mulai.startsWith(tanggal);
        return matchesHospital && matchesDate;
      }),
    };
  }

  async getQueues(hospitalId: string, spesialisasi?: string, dokter_nama?: string) {
    const dbHospital = await this.findDbHospital(hospitalId);
    if (dbHospital) {
      const queues = await this.database.query<Record<string, unknown>>(
        `
          SELECT id, hospital_id, nik, dokter_nama, spesialisasi, tanggal_kunjungan, nomor_antrian, status
          FROM rsud.queues
          WHERE hospital_id = $1
            AND ($2::text IS NULL OR spesialisasi = $2)
            AND ($3::text IS NULL OR dokter_nama = $3)
          ORDER BY nomor_antrian
        `,
        [dbHospital.id, spesialisasi ?? null, dokter_nama ?? null],
      );
      return {
        hospital_id: hospitalId,
        queues: queues ?? [],
      };
    }

    this.assertHospitalExists(hospitalId);
    return {
      hospital_id: hospitalId,
      queues: this.queues.filter((q) => {
        const matchesHospital = q.hospital_id === hospitalId;
        const matchesPoli = !spesialisasi || q.spesialisasi === spesialisasi;
        const matchesDokter = !dokter_nama || q.dokter_nama === dokter_nama;
        return matchesHospital && matchesPoli && matchesDokter;
      }),
    };
  }

  private assertHospitalExists(hospitalId: string) {
    if (!this.hospitals.some((hospital) => hospital.id === hospitalId)) {
      throw new NotFoundException('RSUD tidak ditemukan');
    }
  }

  private async findDbHospital(hospitalId: string) {
    const direct = await this.database.queryOne<{ id: string; nama_rs: string }>(
      'SELECT id, nama_rs FROM rsud.hospitals WHERE id::text = $1',
      [hospitalId],
    );
    if (direct) {
      return direct;
    }

    const normalized = hospitalId.toLowerCase();
    return this.database.queryOne<{ id: string; nama_rs: string }>(
      `
        SELECT id, nama_rs
        FROM rsud.hospitals
        WHERE lower(nama_rs) LIKE $1
        LIMIT 1
      `,
      [`%${normalized}%`],
    );
  }

  private slugFromHospitalName(name: string) {
    if (name.toLowerCase().includes('daha')) return 'daha';
    if (name.toLowerCase().includes('karsa')) return 'karsa';
    if (name.toLowerCase().includes('haji')) return 'haji';
    return name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
  }
}
