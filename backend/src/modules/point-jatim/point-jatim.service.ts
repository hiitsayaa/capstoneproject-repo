import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../../common/database/database.service';
import { CreatePointJatimSubmissionDto } from './point-jatim.dto';

@Injectable()
export class PointJatimService {
  constructor(private readonly database: DatabaseService) {}

  private readonly projects = [
    { id: 'integrated-farming-pujon', name: 'Peternakan Sapi Perah Terintegrasi Modern', sector: 'Peternakan', location: 'Pujon, Kabupaten Malang', investment_value: 125000000000, irr: 18.4, npv: 42000000000, payback_period: '5 tahun', status: 'Ready to Offer' },
    { id: 'health-tourism-batu', name: 'Health Tourism Batu Raya', sector: 'Kesehatan', location: 'Kota Batu', investment_value: 85000000000, irr: 15.2, npv: 26000000000, payback_period: '6 tahun', status: 'Feasibility Study' },
  ];

  async getProjects(sector?: string) {
    const rows = await this.database.query<Record<string, unknown>>(
      `
        SELECT id, name, sector, location, investment_value::float, irr::float, npv::float,
               payback_period, status, description
        FROM point_jatim.projects
        WHERE ($1::text IS NULL OR sector ILIKE $1)
        ORDER BY investment_value DESC
      `,
      [sector && sector !== 'Semua' ? sector : null],
    );
    if (rows) {
      return { data: rows };
    }

    return { data: this.projects.filter((project) => !sector || sector === 'Semua' || project.sector === sector) };
  }

  async getProject(id: string) {
    const row = await this.database.queryOne<Record<string, unknown>>(
      `
        SELECT id, name, sector, location, investment_value::float, irr::float, npv::float,
               payback_period, status, description
        FROM point_jatim.projects
        WHERE id = $1
      `,
      [id],
    );
    if (row) {
      return row;
    }

    const project = this.projects.find((item) => item.id === id);
    if (!project) {
      throw new NotFoundException('Proyek Point Jatim tidak ditemukan');
    }
    return project;
  }

  async createSubmission(payload: CreatePointJatimSubmissionDto) {
    const row = await this.database.queryOne<Record<string, unknown>>(
      `
        INSERT INTO point_jatim.submissions (project_id, nama_investor, email, telepon, catatan, status)
        VALUES ($1, $2, $3, $4, $5, 'Submitted')
        RETURNING id, project_id, nama_investor, email, telepon, catatan, status, submitted_at
      `,
      [payload.project_id, payload.nama_investor, payload.email, payload.telepon, payload.catatan ?? null],
    );
    return row ?? { id: `point-submission-${Date.now()}`, ...payload, status: 'Submitted', submitted_at: new Date().toISOString() };
  }
}
