import { Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { DatabaseService } from '../../common/database/database.service';
import { AuthService } from '../auth/auth.service';

@Injectable()
export class BapendaService {
  constructor(
    private readonly authService: AuthService,
    private readonly database: DatabaseService,
  ) {}

  private readonly vehicles = [
    {
      id: 'vehicle-001',
      nopol: 'N1234AB',
      nik_pemilik: '3573010101010001',
      merk: 'Toyota',
      tipe: 'Avanza',
      tahun: 2021,
      no_rangka: 'MHKM1BA3JMK001234',
      no_mesin: '1NRF123456',
    },
  ];

  private readonly bills = [
    {
      id: 'bill-001',
      vehicle_id: 'vehicle-001',
      pokok_pkb: 1750000,
      denda_pkb: 0,
      swdkllj: 143000,
      denda_swdkllj: 0,
      status: 'Unpaid',
      due_date: '2026-12-31',
    },
  ];

  private readonly njkb = [
    {
      id: 'njkb-001',
      merk: 'Toyota',
      tipe: 'Avanza',
      tahun: 2021,
      nilai_njkb: 180000000,
      bobot: 1,
    },
    {
      id: 'njkb-002',
      merk: 'Honda',
      tipe: 'Vario',
      tahun: 2023,
      nilai_njkb: 21000000,
      bobot: 1,
    },
  ];

  async getMyVehicles(nik: string) {
    const dbVehicles = await this.database.query<Record<string, unknown>>(
      'SELECT id, nopol, nik_pemilik, merk, tipe, tahun, no_rangka, no_mesin FROM bapenda.vehicles WHERE nik_pemilik = $1',
      [nik],
    );

    if (dbVehicles && dbVehicles.length > 0) {
      return dbVehicles;
    }

    return this.vehicles.filter((v) => v.nik_pemilik === nik);
  }

  async checkPkb(nopol: string) {
    const normalizedNopol = nopol?.replace(/\s/g, '').toUpperCase();
    const dbVehicle = await this.database.queryOne<Record<string, unknown>>(
      'SELECT id, nopol, nik_pemilik, merk, tipe, tahun, no_rangka, no_mesin FROM bapenda.vehicles WHERE nopol = $1',
      [normalizedNopol],
    );

    if (dbVehicle) {
      const bills = await this.database.query<Record<string, unknown>>(
        `
          SELECT id, vehicle_id, pokok_pkb::float, denda_pkb::float, swdkllj::float,
                 denda_swdkllj::float, status, due_date::text,
                 (pokok_pkb + denda_pkb + swdkllj + denda_swdkllj)::float AS total
          FROM bapenda.pkb_bills
          WHERE vehicle_id = $1
          ORDER BY due_date DESC
        `,
        [dbVehicle.id],
      );

      return {
        vehicle: dbVehicle,
        bills: bills ?? [],
      };
    }

    const vehicle = this.vehicles.find((item) => item.nopol === normalizedNopol);
    if (!vehicle) {
      throw new NotFoundException('Kendaraan tidak ditemukan');
    }

    return {
      vehicle,
      bills: this.bills
        .filter((bill) => bill.vehicle_id === vehicle.id)
        .map((bill) => ({
          ...bill,
          total: bill.pokok_pkb + bill.denda_pkb + bill.swdkllj + bill.denda_swdkllj,
        })),
    };
  }

  async createPayment(billId: string, paymentMethod: string | undefined, nik: string) {
    if (!(await this.authService.verifyNikHybrid(nik))) {
      throw new UnauthorizedException('NIK tidak terdaftar');
    }

    const dbBill = await this.database.queryOne<{
      id: string;
      pokok_pkb: number;
      denda_pkb: number;
      swdkllj: number;
      denda_swdkllj: number;
    }>(
      `
        SELECT id, pokok_pkb::float, denda_pkb::float, swdkllj::float, denda_swdkllj::float
        FROM bapenda.pkb_bills
        WHERE id = $1
      `,
      [billId],
    );

    if (dbBill) {
      const amountPaid = dbBill.pokok_pkb + dbBill.denda_pkb + dbBill.swdkllj + dbBill.denda_swdkllj;
      const vaNumber = `8888${nik.slice(-8)}`;
      const inserted = await this.database.queryOne<{ id: string }>(
        `
          INSERT INTO bapenda.pkb_payments (bill_id, payment_method, va_number, amount_paid)
          VALUES ($1, $2, $3, $4)
          RETURNING id
        `,
        [billId, paymentMethod ?? 'virtual_account', vaNumber, amountPaid],
      );

      return {
        id: inserted?.id ?? `payment-${Date.now()}`,
        bill_id: billId,
        payment_method: paymentMethod ?? 'virtual_account',
        va_number: vaNumber,
        amount_paid: amountPaid,
        status: 'Pending',
        expires_at: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
      };
    }

    const bill = this.bills.find((candidate) => candidate.id === billId);
    if (!bill) {
      throw new NotFoundException('Tagihan PKB tidak ditemukan');
    }

    return {
      id: `payment-${Date.now()}`,
      bill_id: billId,
      payment_method: paymentMethod ?? 'virtual_account',
      va_number: `8888${nik.slice(-8)}`,
      amount_paid: bill.pokok_pkb + bill.denda_pkb + bill.swdkllj + bill.denda_swdkllj,
      status: 'Pending',
      expires_at: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
    };
  }

  async getPayment(paymentId: string) {
    const dbPayment = await this.database.queryOne<Record<string, unknown>>(
      `
        SELECT id, bill_id, payment_method, va_number, amount_paid::float, paid_at,
               CASE WHEN paid_at IS NULL THEN 'Pending' ELSE 'Paid' END AS status
        FROM bapenda.pkb_payments
        WHERE id::text = $1
      `,
      [paymentId],
    );

    if (dbPayment) return dbPayment;

    if (paymentId.startsWith('payment-')) {
      return {
        id: paymentId,
        status: 'Pending',
        message: 'Instruksi pembayaran masih menunggu pembayaran.',
      };
    }

    throw new NotFoundException('Pembayaran PKB tidak ditemukan');
  }

  async searchNjkb(filter: { merk?: string; tahun?: number }) {
    const dbRows = await this.database.query<Record<string, unknown>>(
      `
        SELECT id, merk, tipe, tahun, nilai_njkb::float, bobot::float
        FROM bapenda.njkb_data
        WHERE ($1::text IS NULL OR merk ILIKE '%' || $1 || '%')
          AND ($2::int IS NULL OR tahun = $2)
        ORDER BY merk, tipe, tahun DESC
      `,
      [filter.merk ?? null, filter.tahun ?? null],
    );

    if (dbRows) {
      return { data: dbRows };
    }

    return {
      data: this.njkb.filter((item) => {
        const matchesMerk = !filter.merk || item.merk.toLowerCase().includes(filter.merk.toLowerCase());
        const matchesTahun = !filter.tahun || item.tahun === filter.tahun;
        return matchesMerk && matchesTahun;
      }),
    };
  }
}
