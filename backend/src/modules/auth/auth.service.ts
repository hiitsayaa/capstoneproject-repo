import { Injectable, UnauthorizedException } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import { createHmac, timingSafeEqual } from 'node:crypto';
import { DatabaseService } from '../../common/database/database.service';
import { UpdateProfileDto } from './auth.dto';

type DemoUser = {
  id: string;
  email: string;
  password_hash: string;
  role: 'Admin' | 'RegisteredUser' | 'Visitor';
  profile: {
    nik: string;
    kk: string;
    nama_lengkap: string;
    tempat_lahir: string;
    tanggal_lahir: string;
    jenis_kelamin: string;
    telepon: string;
    alamat_lengkap: string;
  };
  favorites: string[];
};

@Injectable()
export class AuthService {
  constructor(private readonly database: DatabaseService) {}

  private readonly users: DemoUser[] = [
    {
      id: 'user-001',
      email: 'demo@majadigi.go.id',
      password_hash: bcrypt.hashSync('password', 10),
      role: 'RegisteredUser',
      profile: {
        nik: '3573010101010001',
        kk: '3573010101010000',
        nama_lengkap: 'Warga Demo Majadigi',
        tempat_lahir: 'Malang',
        tanggal_lahir: '2001-01-01',
        jenis_kelamin: 'L',
        telepon: '081234567890',
        alamat_lengkap: 'Jl. Majadigi No. 1, Jawa Timur',
      },
      favorites: ['bapenda', 'rsud_daha_husada'],
    },
  ];

  async register(payload: { email: string; password: string; nik: string; nama_lengkap: string }) {
    const passwordHash = bcrypt.hashSync(payload.password, 10);
    const created = await this.database.queryOne<{
      id: string;
      email: string;
      role: DemoUser['role'];
      nik: string;
      kk: string;
      nama_lengkap: string;
      tempat_lahir: string;
      tanggal_lahir: string;
      jenis_kelamin: string;
      telepon: string;
      alamat_lengkap: string;
    }>(
      `
        WITH inserted_user AS (
          INSERT INTO auth.users (email, password_hash, role)
          VALUES ($1, $2, 'RegisteredUser')
          RETURNING id, email, role
        ),
        inserted_profile AS (
          INSERT INTO auth.profiles (user_id, nik, nama_lengkap)
          SELECT id, $3, $4 FROM inserted_user
          RETURNING user_id, nik, kk, nama_lengkap, tempat_lahir, tanggal_lahir::text, jenis_kelamin, telepon, alamat_lengkap
        )
        SELECT u.id, u.email, u.role, p.nik, p.kk, p.nama_lengkap, p.tempat_lahir, p.tanggal_lahir,
               p.jenis_kelamin, p.telepon, p.alamat_lengkap
        FROM inserted_user u
        JOIN inserted_profile p ON p.user_id = u.id
      `,
      [payload.email, passwordHash, payload.nik, payload.nama_lengkap],
    );

    if (created) {
      return {
        id: created.id,
        email: created.email,
        role: created.role,
        profile: {
          nik: created.nik,
          kk: created.kk ?? '',
          nama_lengkap: created.nama_lengkap,
          tempat_lahir: created.tempat_lahir ?? '',
          tanggal_lahir: created.tanggal_lahir ?? '',
          jenis_kelamin: created.jenis_kelamin ?? '',
          telepon: created.telepon ?? '',
          alamat_lengkap: created.alamat_lengkap ?? '',
        },
      };
    }

    const user: DemoUser = {
      id: `user-${this.users.length + 1}`.padStart(8, '0'),
      email: payload.email,
      password_hash: passwordHash,
      role: 'RegisteredUser',
      profile: {
        nik: payload.nik,
        kk: '',
        nama_lengkap: payload.nama_lengkap,
        tempat_lahir: '',
        tanggal_lahir: '',
        jenis_kelamin: '',
        telepon: '',
        alamat_lengkap: '',
      },
      favorites: [],
    };
    this.users.push(user);

    return {
      id: user.id,
      email: user.email,
      role: user.role,
      profile: user.profile,
    };
  }

  async login(email: string, password: string) {
    const dbUser = await this.database.queryOne<{
      id: string;
      email: string;
      password_hash: string;
      role: DemoUser['role'];
      nik: string;
    }>(
      `
        SELECT u.id, u.email, u.password_hash, u.role, p.nik
        FROM auth.users u
        JOIN auth.profiles p ON p.user_id = u.id
        WHERE u.email = $1
      `,
      [email],
    );

    if (dbUser) {
      if (!bcrypt.compareSync(password, dbUser.password_hash)) {
        throw new UnauthorizedException('Email atau password tidak valid');
      }

      return {
        access_token: this.createDemoJwt(dbUser.nik, [dbUser.role]),
        token_type: 'Bearer',
        expires_in: 3600,
        user: {
          id: dbUser.id,
          email: dbUser.email,
          role: dbUser.role,
          nik: dbUser.nik,
        },
      };
    }

    const user = this.users.find((candidate) => candidate.email === email);
    if (!user || !bcrypt.compareSync(password, user.password_hash)) {
      throw new UnauthorizedException('Email atau password tidak valid');
    }

    return {
      access_token: this.createDemoJwt(user.profile.nik, [user.role]),
      token_type: 'Bearer',
      expires_in: 3600,
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
        nik: user.profile.nik,
      },
    };
  }

  async getProfileByNik(nik: string) {
    const dbProfile = await this.database.queryOne<{
      nik: string;
      kk: string;
      nama_lengkap: string;
      tempat_lahir: string;
      tanggal_lahir: string;
      jenis_kelamin: string;
      telepon: string;
      alamat_lengkap: string;
      favorites: string[];
    }>(
      `
        SELECT p.nik, p.kk, p.nama_lengkap, p.tempat_lahir, p.tanggal_lahir::text,
               p.jenis_kelamin, p.telepon, p.alamat_lengkap,
               COALESCE(array_agg(f.service_key) FILTER (WHERE f.service_key IS NOT NULL), '{}') AS favorites
        FROM auth.profiles p
        JOIN auth.users u ON u.id = p.user_id
        LEFT JOIN auth.favorites f ON f.user_id = u.id
        WHERE p.nik = $1
        GROUP BY p.id
      `,
      [nik],
    );

    if (dbProfile) {
      return {
        ...dbProfile,
        kk: dbProfile.kk ?? '',
        tempat_lahir: dbProfile.tempat_lahir ?? '',
        tanggal_lahir: dbProfile.tanggal_lahir ?? '',
        jenis_kelamin: dbProfile.jenis_kelamin ?? '',
        telepon: dbProfile.telepon ?? '',
        alamat_lengkap: dbProfile.alamat_lengkap ?? '',
        favorites: dbProfile.favorites ?? [],
      };
    }

    const user = this.findByNik(nik);
    return {
      ...user.profile,
      favorites: user.favorites,
    };
  }

  async updateFavorites(nik: string, serviceKeys: string[]) {
    const userId = await this.database.queryOne<{ id: string }>(
      `
        SELECT u.id
        FROM auth.users u
        JOIN auth.profiles p ON p.user_id = u.id
        WHERE p.nik = $1
      `,
      [nik],
    );

    if (userId) {
      await this.database.query('DELETE FROM auth.favorites WHERE user_id = $1', [userId.id]);
      for (const serviceKey of [...new Set(serviceKeys)]) {
        await this.database.query(
          `
            INSERT INTO auth.favorites (user_id, service_key)
            VALUES ($1, $2)
            ON CONFLICT (user_id, service_key) DO NOTHING
          `,
          [userId.id, serviceKey],
        );
      }

      return {
        nik,
        service_keys: [...new Set(serviceKeys)],
      };
    }

    const user = this.findByNik(nik);
    user.favorites = [...new Set(serviceKeys)];
    return {
      nik,
      service_keys: user.favorites,
    };
  }

  async updateProfile(nik: string, payload: UpdateProfileDto) {
    const dbProfile = await this.database.queryOne<Record<string, unknown>>(
      `
        UPDATE auth.profiles
        SET kk = COALESCE($2, kk),
            nama_lengkap = COALESCE($3, nama_lengkap),
            tempat_lahir = COALESCE($4, tempat_lahir),
            tanggal_lahir = COALESCE($5::date, tanggal_lahir),
            jenis_kelamin = COALESCE($6, jenis_kelamin),
            telepon = COALESCE($7, telepon),
            alamat_lengkap = COALESCE($8, alamat_lengkap)
        WHERE nik = $1
        RETURNING nik, kk, nama_lengkap, tempat_lahir, tanggal_lahir::text, jenis_kelamin, telepon, alamat_lengkap
      `,
      [
        nik,
        payload.kk ?? null,
        payload.nama_lengkap ?? null,
        payload.tempat_lahir ?? null,
        payload.tanggal_lahir ?? null,
        payload.jenis_kelamin ?? null,
        payload.telepon ?? null,
        payload.alamat_lengkap ?? null,
      ],
    );

    if (dbProfile) return dbProfile;

    const user = this.findByNik(nik);
    user.profile = { ...user.profile, ...payload };
    return user.profile;
  }

  forgotPassword(email: string) {
    return {
      email,
      status: 'VerificationSent',
      message: 'Kode verifikasi telah dikirim ke alamat email Anda.',
      verification_code: '123456',
    };
  }

  verifyEmail(email: string, code: string) {
    return {
      email,
      verified: code === '123456',
      status: code === '123456' ? 'Verified' : 'InvalidCode',
    };
  }

  verifyNik(nik: string) {
    return this.users.some((user) => user.profile.nik === nik);
  }

  async verifyNikHybrid(nik: string) {
    const profile = await this.database.queryOne<{ nik: string }>('SELECT nik FROM auth.profiles WHERE nik = $1', [nik]);
    return Boolean(profile) || this.verifyNik(nik);
  }

  private findByNik(nik: string) {
    const user = this.users.find((candidate) => candidate.profile.nik === nik);
    if (!user) {
      throw new UnauthorizedException('Profil tidak ditemukan untuk token ini');
    }
    return user;
  }

  private createDemoJwt(nik: string, roles: string[]) {
    const now = Math.floor(Date.now() / 1000);
    const header = this.encodeBase64Url({ alg: 'HS256', typ: 'JWT' });
    const payload = this.encodeBase64Url({
      sub: nik,
      nik,
      roles,
      iat: now,
      exp: now + 3600,
    });
    const signature = this.sign(`${header}.${payload}`);
    return `${header}.${payload}.${signature}`;
  }

  verifyAccessToken(token: string) {
    const [encodedHeader, encodedPayload, signature] = token.split('.');
    if (!encodedHeader || !encodedPayload || !signature) {
      throw new UnauthorizedException('Invalid bearer token');
    }

    const header = this.decodeBase64Url<Record<string, unknown>>(encodedHeader);
    if (header.alg !== 'HS256') {
      throw new UnauthorizedException('Invalid bearer token');
    }

    const expectedSignature = this.sign(`${encodedHeader}.${encodedPayload}`);
    if (!this.isEqualSignature(signature, expectedSignature)) {
      throw new UnauthorizedException('Invalid bearer token');
    }

    const payload = this.decodeBase64Url<Record<string, unknown>>(encodedPayload);
    const expiresAt = Number(payload.exp ?? 0);
    if (!expiresAt || expiresAt < Math.floor(Date.now() / 1000)) {
      throw new UnauthorizedException('Bearer token expired');
    }

    return {
      nik: String(payload.nik ?? payload.sub ?? 'anonymous'),
      roles: Array.isArray(payload.roles) ? payload.roles.map(String) : ['RegisteredUser'],
    };
  }

  private encodeBase64Url(payload: Record<string, unknown>) {
    return Buffer.from(JSON.stringify(payload)).toString('base64url');
  }

  private decodeBase64Url<T>(value: string): T {
    try {
      return JSON.parse(Buffer.from(value, 'base64url').toString()) as T;
    } catch {
      throw new UnauthorizedException('Invalid bearer token');
    }
  }

  private sign(value: string) {
    return createHmac('sha256', process.env.JWT_SECRET ?? 'dev-secret')
      .update(value)
      .digest('base64url');
  }

  private isEqualSignature(left: string, right: string) {
    const leftBuffer = Buffer.from(left);
    const rightBuffer = Buffer.from(right);
    return leftBuffer.length === rightBuffer.length && timingSafeEqual(leftBuffer, rightBuffer);
  }
}
