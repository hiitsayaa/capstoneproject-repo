import { INestApplication, ValidationPipe } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import * as request from 'supertest';
import { AppModule } from './app.module';

describe('Majadigi integration contract', () => {
  let app: INestApplication;
  let httpServer: Parameters<typeof request>[0];

  beforeAll(async () => {
    process.env.JWT_SECRET = 'test-secret';

    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleRef.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );
    await app.init();
    httpServer = app.getHttpAdapter().getInstance();
  });

  afterAll(async () => {
    await app.close();
  });

  async function login() {
    const response = await request(httpServer)
      .post('/auth/login')
      .send({ email: 'demo@majadigi.go.id', password: 'password' })
      .expect(201);

    return response.body.access_token as string;
  }

  it('publishes an OpenAPI contract for Flutter integration', async () => {
    const response = await request(httpServer).get('/openapi.json').expect(200);

    expect(response.body.openapi).toBe('3.0.3');
    expect(response.body.paths).toHaveProperty('/gateway/features');
    expect(response.body.paths).toHaveProperty('/auth/login');
    expect(response.body.paths).toHaveProperty('/bapenda/pkb/check');
    expect(response.body.paths).toHaveProperty('/hoaks/report');
    expect(response.body.paths).toHaveProperty('/emergency/contacts');
    expect(response.body.paths).toHaveProperty('/islamic-center/facilities');
    expect(response.body.paths).toHaveProperty('/point-jatim/projects');
    expect(response.body.paths).toHaveProperty('/tbc-screening/questions');
    expect(response.body.paths).toHaveProperty('/tickets/{id}');

    await request(httpServer)
      .get('/docs')
      .expect(200)
      .expect('Content-Type', /html/)
      .expect(({ text }) => {
        expect(text).toContain('Quick Start');
        expect(text).toContain('Endpoint Catalog');
        expect(text).toContain('Android emulator');
        expect(text).toContain('Bearer token');
        expect(text).not.toContain('<pre>{');
      });
  });

  it('issues signed JWTs and uses them for protected profile access', async () => {
    const token = await login();
    const [encodedHeader] = token.split('.');
    const header = JSON.parse(Buffer.from(encodedHeader, 'base64url').toString());

    expect(header.alg).toBe('HS256');
    expect(token.endsWith('.demo-signature')).toBe(false);

    await request(httpServer)
      .get('/profile/me')
      .set('Authorization', `Bearer ${token}`)
      .expect(200)
      .expect(({ body }) => {
        expect(body.nik).toBe('3573010101010001');
        expect(body.favorites).toEqual(expect.arrayContaining(['bapenda']));
      });

    await request(httpServer).get('/profile/me').expect(401);
    await request(httpServer)
      .get('/profile/me')
      .set('Authorization', 'Bearer test-mock-token')
      .expect(401);
  });

  it('validates auth and Bapenda request contracts', async () => {
    await request(httpServer)
      .post('/auth/register')
      .send({ email: 'not-email', password: 'short', nik: '123', nama_lengkap: '' })
      .expect(400);

    const token = await login();

    await request(httpServer)
      .get('/bapenda/pkb/check')
      .set('Authorization', `Bearer ${token}`)
      .expect(400);

    await request(httpServer)
      .post('/bapenda/pkb/pay')
      .set('Authorization', `Bearer ${token}`)
      .send({ bill_id: 'bill-001', payment_method: 'virtual_account', unexpected: true })
      .expect(400);
  });

  it('serves stable module payloads for Flutter screens', async () => {
    const token = await login();

    await request(httpServer)
      .get('/gateway/features')
      .expect(200)
      .expect(({ body }) => {
        expect(body.active_features).toEqual(
          expect.arrayContaining([
            expect.objectContaining({ key: 'bapenda', route: '/bapenda', requires_auth: true }),
            expect.objectContaining({ key: 'klinik_hoaks', route: '/hoaks', requires_auth: false }),
            expect.objectContaining({ key: 'nomor_darurat', route: '/emergency', requires_auth: false }),
            expect.objectContaining({ key: 'rsud_haji', route: '/rsud/haji', requires_auth: false }),
            expect.objectContaining({ key: 'point_jatim', route: '/point-jatim', requires_auth: true }),
            expect.objectContaining({ key: 'skrining_tbc', route: '/tbc-screening', requires_auth: true }),
          ]),
        );
      });

    await request(httpServer)
      .get('/bapenda/pkb/check?nopol=N%201234%20AB')
      .set('Authorization', `Bearer ${token}`)
      .expect(200)
      .expect(({ body }) => {
        expect(body.vehicle.nopol).toBe('N1234AB');
        expect(body.bills[0].total).toBe(1893000);
      });

    await request(httpServer)
      .get('/bapenda/njkb?merk=toyota&tahun=2021')
      .expect(200)
      .expect(({ body }) => {
        expect(body.data[0]).toEqual(expect.objectContaining({ merk: 'Toyota', tahun: 2021 }));
      });

    await request(httpServer)
      .get('/rsud/haji')
      .expect(200)
      .expect(({ body }) => {
        expect(body).toEqual(expect.objectContaining({ id: 'haji', nama_rs: expect.stringContaining('RSUD Haji') }));
      });

    await request(httpServer)
      .get('/rsud/haji/rooms')
      .expect(200)
      .expect(({ body }) => {
        expect(body.rooms).toEqual(expect.arrayContaining([expect.objectContaining({ hospital_id: 'haji' })]));
      });

    await request(httpServer)
      .post('/rsud/daha/queue')
      .set('Authorization', `Bearer ${token}`)
      .send({
        nik: '3573010101010001',
        dokter_nama: 'dr. Sekar Ayu',
        spesialisasi: 'Umum',
        tanggal_kunjungan: '2026-06-01',
      })
      .expect(201)
      .expect(({ body }) => {
        expect(body.nomor_antrian).toBe('A-001');
      });

    await request(httpServer)
      .post('/bansos/apply')
      .set('Authorization', `Bearer ${token}`)
      .send({
        program_id: 'pkh-2026',
        nama_ibu_kandung: 'Siti',
        penghasilan_bulanan: 1500000,
        jumlah_tanggungan: 2,
      })
      .expect(201)
      .expect(({ body }) => {
        expect(body.status).toBe('Submitted');
      });

    await request(httpServer)
      .post('/hoaks/report')
      .send({ judul_laporan: 'Hoaks layanan publik', deskripsi_kejadian: 'Narasi tidak benar beredar.' })
      .expect(201)
      .expect(({ body }) => {
        expect(body.user_id).toBe('anonymous');
        expect(body.status_laporan).toBe('Pending');
      });
  });

  it('covers the additional capstone Flutter service screens', async () => {
    const token = await login();

    await request(httpServer)
      .get('/emergency/contacts?region=Surabaya')
      .expect(200)
      .expect(({ body }) => {
        expect(body.data[0]).toEqual(expect.objectContaining({ phone: '112' }));
      });

    await request(httpServer)
      .get('/islamic-center/facilities?category=Aula')
      .expect(200)
      .expect(({ body }) => {
        expect(body.data[0]).toEqual(expect.objectContaining({ category: 'Aula' }));
      });

    await request(httpServer)
      .post('/islamic-center/bookings')
      .set('Authorization', `Bearer ${token}`)
      .send({
        facility_id: 'aula-utama',
        nama_pemohon: 'Budi Santoso',
        telepon: '081234567893',
        email: 'budi@majadigi.go.id',
        tanggal: '2026-06-10',
        waktu: 'Siang',
      })
      .expect(201)
      .expect(({ body }) => {
        expect(body.status).toBe('Submitted');
      });

    await request(httpServer)
      .get('/point-jatim/projects?sector=Peternakan')
      .expect(200)
      .expect(({ body }) => {
        expect(body.data[0]).toEqual(expect.objectContaining({ sector: 'Peternakan' }));
      });

    await request(httpServer)
      .post('/point-jatim/submissions')
      .set('Authorization', `Bearer ${token}`)
      .send({
        project_id: 'integrated-farming-pujon',
        nama_investor: 'PT Demo Investama',
        email: 'investor@example.com',
        telepon: '081200001111',
      })
      .expect(201)
      .expect(({ body }) => {
        expect(body.status).toBe('Submitted');
      });

    await request(httpServer)
      .get('/tbc-screening/questions')
      .expect(200)
      .expect(({ body }) => {
        expect(body.data[0]).toEqual(expect.objectContaining({ id: 'q-cough' }));
        expect(body.data).toHaveLength(23);
      });

    await request(httpServer)
      .post('/tbc-screening/records')
      .set('Authorization', `Bearer ${token}`)
      .send({
        nama: 'Warga Demo Majadigi',
        nik: '3573010101010001',
        kabupaten_kota: 'Kota Malang',
        answers: [{ question_id: 'q-cough', answer: true }],
      })
      .expect(201)
      .expect(({ body }) => {
        expect(body.risk_level).toBe('Sedang');
      });

    await request(httpServer)
      .get('/tickets/51000000-0000-0000-0000-000000000001')
      .expect(200)
      .expect(({ body }) => {
        expect(body.source).toBe('hoaks');
      });
  });
});
