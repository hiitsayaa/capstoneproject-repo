export const openApiDocument = {
  openapi: '3.0.3',
  info: {
    title: 'Majadigi Backend API',
    version: '1.0.0',
    description: 'Integration API contract for the Majadigi Flutter capstone app.',
  },
  servers: [{ url: 'http://localhost:3000' }],
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
      },
    },
  },
  paths: {
    '/gateway/features': {
      get: {
        summary: 'List enabled Majadigi service features',
        responses: {
          '200': {
            description: 'Feature catalog',
            content: {
              'application/json': {
                example: {
                  active_features: [
                    {
                      key: 'bapenda',
                      name: 'Bapenda Jatim (PKB & NJKB)',
                      active: true,
                      route: '/bapenda',
                      requires_auth: true,
                      icon_url: 'https://cdn.majadigi.go.id/icons/bapenda.png',
                      version: '1.0.0',
                    },
                  ],
                },
              },
            },
          },
        },
      },
    },
    '/auth/register': {
      post: {
        summary: 'Register a new Majadigi user',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              example: {
                email: 'warga@majadigi.go.id',
                password: 'password123',
                nik: '3573010101010002',
                nama_lengkap: 'Warga Demo Baru',
              },
            },
          },
        },
        responses: { '201': { description: 'Registered user profile' }, '400': { description: 'Invalid payload' } },
      },
    },
    '/auth/login': {
      post: {
        summary: 'Login and receive a signed JWT',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              example: { email: 'demo@majadigi.go.id', password: 'password' },
            },
          },
        },
        responses: { '201': { description: 'Bearer token and user summary' }, '401': { description: 'Invalid credentials' } },
      },
    },
    '/auth/forgot-password': {
      post: {
        summary: 'Request a forgot-password verification code',
        requestBody: { required: true, content: { 'application/json': { example: { email: 'demo@majadigi.go.id' } } } },
        responses: { '201': { description: 'Verification instruction' }, '400': { description: 'Invalid payload' } },
      },
    },
    '/auth/verify-email': {
      post: {
        summary: 'Verify email using verification code',
        requestBody: { required: true, content: { 'application/json': { example: { email: 'demo@majadigi.go.id', code: '123456' } } } },
        responses: { '201': { description: 'Verification result' }, '400': { description: 'Invalid payload' } },
      },
    },
    '/profile/me': {
      get: {
        summary: 'Read the current user profile',
        security: [{ bearerAuth: [] }],
        responses: { '200': { description: 'Profile with favorites' }, '401': { description: 'Missing or invalid token' } },
      },
      patch: {
        summary: 'Update current user profile fields',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              example: { nama_lengkap: 'Warga Demo Majadigi', telepon: '081234567890', alamat_lengkap: 'Jl. Majadigi No. 1' },
            },
          },
        },
        responses: { '200': { description: 'Updated profile' }, '400': { description: 'Invalid payload' } },
      },
    },
    '/profile/favorites': {
      patch: {
        summary: 'Replace current user favorite service keys',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: { 'application/json': { example: { service_keys: ['bapenda', 'klinik_hoaks'] } } },
        },
        responses: { '200': { description: 'Updated favorites' }, '400': { description: 'Invalid payload' } },
      },
    },
    '/bapenda/pkb/check': {
      get: {
        summary: 'Check vehicle tax bill by license plate',
        security: [{ bearerAuth: [] }],
        parameters: [{ name: 'nopol', in: 'query', required: true, schema: { type: 'string' }, example: 'N 1234 AB' }],
        responses: { '200': { description: 'Vehicle and PKB bills' }, '400': { description: 'Missing nopol' } },
      },
    },
    '/bapenda/pkb/pay': {
      post: {
        summary: 'Create a PKB payment instruction',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: { 'application/json': { example: { bill_id: 'bill-001', payment_method: 'virtual_account' } } },
        },
        responses: { '201': { description: 'Payment instruction' }, '400': { description: 'Invalid payload' } },
      },
    },
    '/bapenda/pkb/payments/{paymentId}': {
      get: {
        summary: 'Read PKB payment instruction status',
        security: [{ bearerAuth: [] }],
        parameters: [{ name: 'paymentId', in: 'path', required: true, schema: { type: 'string' }, example: 'payment-123' }],
        responses: { '200': { description: 'Payment status' }, '404': { description: 'Payment not found' } },
      },
    },
    '/bapenda/njkb': {
      get: {
        summary: 'Search NJKB reference data',
        parameters: [
          { name: 'merk', in: 'query', schema: { type: 'string' }, example: 'Toyota' },
          { name: 'tahun', in: 'query', schema: { type: 'integer' }, example: 2021 },
        ],
        responses: { '200': { description: 'NJKB data list' } },
      },
    },
    '/rsud/hospitals': {
      get: { summary: 'List RSUD hospitals', responses: { '200': { description: 'Hospital list' } } },
    },
    '/rsud/{hospitalId}': {
      get: {
        summary: 'Read RSUD profile/detail',
        parameters: [{ name: 'hospitalId', in: 'path', required: true, schema: { type: 'string' }, example: 'daha' }],
        responses: { '200': { description: 'Hospital profile' }, '404': { description: 'Hospital not found' } },
      },
    },
    '/rsud/{hospitalId}/rooms': {
      get: {
        summary: 'List room availability for a hospital',
        parameters: [{ name: 'hospitalId', in: 'path', required: true, schema: { type: 'string' }, example: 'daha' }],
        responses: { '200': { description: 'Room availability' } },
      },
    },
    '/rsud/{hospitalId}/rooms/{roomId}': {
      get: {
        summary: 'Read RSUD room detail',
        parameters: [
          { name: 'hospitalId', in: 'path', required: true, schema: { type: 'string' }, example: 'daha' },
          { name: 'roomId', in: 'path', required: true, schema: { type: 'string' }, example: 'room-001' },
        ],
        responses: { '200': { description: 'Room detail' }, '404': { description: 'Room not found' } },
      },
    },
    '/rsud/{hospitalId}/queue': {
      post: {
        summary: 'Create outpatient queue registration',
        security: [{ bearerAuth: [] }],
        parameters: [{ name: 'hospitalId', in: 'path', required: true, schema: { type: 'string' }, example: 'daha' }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              example: {
                nik: '3573010101010001',
                dokter_nama: 'dr. Sekar Ayu',
                spesialisasi: 'Umum',
                tanggal_kunjungan: '2026-06-01',
              },
            },
          },
        },
        responses: { '201': { description: 'Queue ticket' }, '400': { description: 'Invalid payload' } },
      },
    },
    '/rsud/{hospitalId}/surgeries': {
      get: {
        summary: 'List surgery schedules',
        parameters: [
          { name: 'hospitalId', in: 'path', required: true, schema: { type: 'string' }, example: 'daha' },
          { name: 'tanggal', in: 'query', schema: { type: 'string', format: 'date' }, example: '2026-06-01' },
        ],
        responses: { '200': { description: 'Surgery schedules' } },
      },
    },
    '/bansos/programs': {
      get: { summary: 'List social assistance programs', responses: { '200': { description: 'Program list' } } },
    },
    '/bansos/apply': {
      post: {
        summary: 'Submit a bansos application',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              example: {
                program_id: 'pkh-2026',
                nama_ibu_kandung: 'Siti',
                penghasilan_bulanan: 1500000,
                jumlah_tanggungan: 2,
              },
            },
          },
        },
        responses: { '201': { description: 'Application record' }, '400': { description: 'Invalid payload' } },
      },
    },
    '/bansos/status': {
      get: {
        summary: 'Read current user bansos application status',
        security: [{ bearerAuth: [] }],
        parameters: [{ name: 'application_id', in: 'query', schema: { type: 'string' } }],
        responses: { '200': { description: 'Matching applications' } },
      },
    },
    '/hoaks/articles': {
      get: { summary: 'List fact-check articles', responses: { '200': { description: 'Article list' } } },
    },
    '/hoaks/report': {
      post: {
        summary: 'Submit an anonymous hoax report',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              example: {
                judul_laporan: 'Hoaks layanan publik',
                deskripsi_kejadian: 'Narasi tidak benar beredar.',
                url_bukti: 'https://example.com/bukti',
              },
            },
          },
        },
        responses: { '201': { description: 'Hoax report ticket' }, '400': { description: 'Invalid payload' } },
      },
    },
    '/tickets': {
      get: {
        summary: 'List report tickets, including Klinik Hoaks tickets',
        parameters: [{ name: 'nik', in: 'query', schema: { type: 'string' }, example: '3573010101010001' }],
        responses: { '200': { description: 'Ticket list' } },
      },
    },
    '/tickets/{id}': {
      get: {
        summary: 'Track a ticket by id',
        parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'string' }, example: '51000000-0000-0000-0000-000000000001' }],
        responses: { '200': { description: 'Ticket detail' }, '404': { description: 'Ticket not found' } },
      },
    },
    '/emergency/regions': {
      get: { summary: 'List emergency contact regions', responses: { '200': { description: 'Region list' } } },
    },
    '/emergency/contacts': {
      get: {
        summary: 'List emergency contacts by optional region',
        parameters: [{ name: 'region', in: 'query', schema: { type: 'string' }, example: 'Surabaya' }],
        responses: { '200': { description: 'Emergency contacts' } },
      },
    },
    '/emergency/contacts/{id}': {
      get: {
        summary: 'Read emergency contact detail',
        parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'string' }, example: 'surabaya-112' }],
        responses: { '200': { description: 'Emergency contact detail' }, '404': { description: 'Contact not found' } },
      },
    },
    '/islamic-center/facilities': {
      get: {
        summary: 'List Islamic Center facilities by optional category',
        parameters: [{ name: 'category', in: 'query', schema: { type: 'string' }, example: 'Aula' }],
        responses: { '200': { description: 'Facility list' } },
      },
    },
    '/islamic-center/facilities/{id}': {
      get: {
        summary: 'Read Islamic Center facility detail',
        parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'string' }, example: 'aula-utama' }],
        responses: { '200': { description: 'Facility detail' }, '404': { description: 'Facility not found' } },
      },
    },
    '/islamic-center/bookings': {
      post: {
        summary: 'Submit Islamic Center facility booking',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              example: { facility_id: 'aula-utama', nama_pemohon: 'Budi Santoso', telepon: '081234567893', email: 'budi@majadigi.go.id', tanggal: '2026-06-10', waktu: 'Siang' },
            },
          },
        },
        responses: { '201': { description: 'Booking submission' }, '400': { description: 'Invalid payload' } },
      },
    },
    '/point-jatim/projects': {
      get: {
        summary: 'List Point Jatim investment projects',
        parameters: [{ name: 'sector', in: 'query', schema: { type: 'string' }, example: 'Peternakan' }],
        responses: { '200': { description: 'Investment project list' } },
      },
    },
    '/point-jatim/projects/{id}': {
      get: {
        summary: 'Read Point Jatim project detail',
        parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'string' }, example: 'integrated-farming-pujon' }],
        responses: { '200': { description: 'Investment project detail' }, '404': { description: 'Project not found' } },
      },
    },
    '/point-jatim/submissions': {
      post: {
        summary: 'Submit investor interest for Point Jatim',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: { 'application/json': { example: { project_id: 'integrated-farming-pujon', nama_investor: 'PT Demo Investama', email: 'investor@example.com', telepon: '081200001111' } } },
        },
        responses: { '201': { description: 'Investor submission' }, '400': { description: 'Invalid payload' } },
      },
    },
    '/tbc-screening/questions': {
      get: { summary: 'List TBC screening questions', responses: { '200': { description: 'Question list' } } },
    },
    '/tbc-screening/faskes': {
      get: {
        summary: 'List TBC referral facilities',
        parameters: [
          { name: 'region', in: 'query', schema: { type: 'string' }, example: 'Malang' },
          { name: 'type', in: 'query', schema: { type: 'string' }, example: 'Puskesmas' },
        ],
        responses: { '200': { description: 'Facility list' } },
      },
    },
    '/tbc-screening/records': {
      get: {
        summary: 'List TBC screening history',
        security: [{ bearerAuth: [] }],
        parameters: [{ name: 'nik', in: 'query', schema: { type: 'string' }, example: '3573010101010001' }],
        responses: { '200': { description: 'Screening history' } },
      },
      post: {
        summary: 'Submit TBC screening answers',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              example: {
                nama: 'Warga Demo Majadigi',
                nik: '3573010101010001',
                kabupaten_kota: 'Kota Malang',
                answers: [{ question_id: 'q-cough', answer: true }],
              },
            },
          },
        },
        responses: { '201': { description: 'Risk result' }, '400': { description: 'Invalid payload' } },
      },
    },
  },
} as const;
