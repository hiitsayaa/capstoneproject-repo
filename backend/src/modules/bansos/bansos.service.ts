import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../../common/database/database.service';

@Injectable()
export class BansosService {
  constructor(private readonly database: DatabaseService) {}

  private readonly programs = [
    {
      id: 'pkh-2026',
      nama_program: 'Program Keluarga Harapan',
      deskripsi: 'Bantuan sosial bersyarat untuk keluarga rentan.',
      persyaratan_json: {
        max_penghasilan_bulanan: 2500000,
        min_jumlah_tanggungan: 1,
      },
      periode: '2026',
    },
    {
      id: 'bpnt-2026',
      nama_program: 'Bantuan Pangan Non Tunai',
      deskripsi: 'Dukungan pangan bulanan untuk keluarga penerima manfaat.',
      persyaratan_json: {
        max_penghasilan_bulanan: 2000000,
      },
      periode: '2026',
    },
  ];

  private readonly applications: Array<Record<string, unknown>> = [];

  async getPrograms() {
    const dbRows = await this.database.query<Record<string, unknown>>(
      'SELECT id, nama_program, deskripsi, persyaratan_json, periode FROM bansos.bansos_programs ORDER BY nama_program',
    );
    if (dbRows) {
      return { data: dbRows };
    }

    return { data: this.programs };
  }

  async apply(
    nik: string,
    payload: {
      program_id: string;
      nama_ibu_kandung: string;
      penghasilan_bulanan: number;
      jumlah_tanggungan: number;
      documents?: Array<{ document_type: string; file_url: string }>;
    },
  ) {
    const dbProgram = await this.database.queryOne<{ id: string }>('SELECT id FROM bansos.bansos_programs WHERE id = $1', [
      payload.program_id,
    ]);

    if (dbProgram) {
      const application = await this.database.queryOne<Record<string, unknown>>(
        `
          INSERT INTO bansos.applications
            (program_id, nik, nama_ibu_kandung, penghasilan_bulanan, jumlah_tanggungan, status)
          VALUES ($1, $2, $3, $4, $5, 'Submitted')
          RETURNING id, program_id, nik, nama_ibu_kandung, penghasilan_bulanan::float,
                    jumlah_tanggungan, status, submitted_at
        `,
        [payload.program_id, nik, payload.nama_ibu_kandung, payload.penghasilan_bulanan, payload.jumlah_tanggungan],
      );

      if (application && payload.documents?.length) {
        for (const document of payload.documents) {
          await this.database.query(
            `
              INSERT INTO bansos.documents (application_id, document_type, file_url)
              VALUES ($1, $2, $3)
            `,
            [application.id, document.document_type, document.file_url],
          );
        }
      }

      return application;
    }

    if (!this.programs.some((program) => program.id === payload.program_id)) {
      throw new NotFoundException('Program bansos tidak ditemukan');
    }

    const application = {
      id: `application-${Date.now()}`,
      nik,
      ...payload,
      status: 'Submitted',
      submitted_at: new Date().toISOString(),
    };
    this.applications.push(application);
    return application;
  }

  async getStatus(nik: string, applicationId?: string) {
    const dbRows = await this.database.query<Record<string, unknown>>(
      `
        SELECT a.id, a.program_id, p.nama_program, a.nik, a.nama_ibu_kandung,
               a.penghasilan_bulanan::float, a.jumlah_tanggungan, a.status, a.submitted_at
        FROM bansos.applications a
        JOIN bansos.bansos_programs p ON p.id = a.program_id
        WHERE a.nik = $1
          AND ($2::uuid IS NULL OR a.id = $2)
        ORDER BY a.submitted_at DESC
      `,
      [nik, applicationId ?? null],
    );
    if (dbRows) {
      return { data: dbRows };
    }

    const data = this.applications.filter((application) => {
      const matchesNik = application.nik === nik;
      const matchesId = !applicationId || application.id === applicationId;
      return matchesNik && matchesId;
    });

    return { data };
  }
}
