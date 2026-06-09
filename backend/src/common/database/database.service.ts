import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { Pool, QueryResultRow } from 'pg';

@Injectable()
export class DatabaseService implements OnModuleDestroy {
  private readonly pool?: Pool;

  constructor() {
    if (process.env.DATABASE_URL) {
      this.pool = new Pool({
        connectionString: process.env.DATABASE_URL,
      });
    }
  }

  async query<T extends QueryResultRow = QueryResultRow>(text: string, params: unknown[] = []): Promise<T[] | null> {
    if (!this.pool) {
      return null;
    }

    try {
      const result = await this.pool.query<T>(text, params);
      return result.rows;
    } catch (e) {
      console.error('DB Error:', e);
      return null;
    }
  }

  async queryOne<T extends QueryResultRow = QueryResultRow>(text: string, params: unknown[] = []): Promise<T | null> {
    const rows = await this.query<T>(text, params);
    return rows?.[0] ?? null;
  }

  async onModuleDestroy() {
    await this.pool?.end();
  }
}
